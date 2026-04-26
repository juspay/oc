{ pkgs }:
let
  gumBin = "${pkgs.gum}/bin/gum";
  # Ensures JUSPAY_API_KEY is set, prompting interactively if missing.
  # Always runs — we don't bypass based on args, so the user's positional
  # parameters reach opencode untouched (the prior `case " $* "` bypass
  # also incorrectly matched substrings like " -v " inside messages).
  # Uses ${..:-} for nounset (set -u) compatibility.
  ensureApiKey = ''
    if [ -z "''${JUSPAY_API_KEY:-}" ]; then
      cat >&2 <<'MSG'

  JUSPAY_API_KEY is not set.

  Create an API key at: https://grid.ai.juspay.net/dashboard
  (Requires Juspay VPN to access the dashboard)

  Tip: export JUSPAY_API_KEY=... to skip this prompt next time.

MSG
      if [ ! -t 0 ]; then
        echo "Error: cannot prompt for JUSPAY_API_KEY (stdin is not a terminal)." >&2
        exit 1
      fi
      JUSPAY_API_KEY=$(${gumBin} input --password --prompt "JUSPAY_API_KEY: ") || {
        echo "Error: failed to read JUSPAY_API_KEY." >&2
        exit 1
      }
      if [ -z "$JUSPAY_API_KEY" ]; then
        echo "Error: no API key provided." >&2
        exit 1
      fi
      export JUSPAY_API_KEY
    fi
  '';
in
{
  inherit ensureApiKey;

  mkInitScript = configFile: ''
    ${ensureApiKey}
    config_dir="$HOME/.config/opencode"
    config_file="$config_dir/opencode.json"
    if [ ! -f "$config_file" ]; then
      mkdir -p "$config_dir"
      cp ${configFile} "$config_file"
      chmod u+w "$config_file"
    fi
  '';

  mkConfigDir = { pkgs, configFile, skillsDir }:
    pkgs.runCommand "opencode-config-dir" { } ''
      mkdir -p $out
      ln -s ${configFile} $out/opencode.json
      ln -s ${skillsDir} $out/skills
    '';
}
