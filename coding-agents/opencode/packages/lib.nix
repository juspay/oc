let
  # Checks for JUSPAY_API_KEY, skipping for --version/--help.
  # Uses ${..:-} for nounset (set -u) compatibility.
  checkApiKey = ''
    case " $* " in
      *" --version "* | *" --help "* | *" -v "* | *" -h "*) ;;
      *)
        if [ -z "''${JUSPAY_API_KEY:-}" ]; then
          echo "" >&2
          echo "  Error: JUSPAY_API_KEY environment variable is not set." >&2
          echo "" >&2
          echo "  Create an API key at: https://grid.ai.juspay.net/dashboard" >&2
          echo "  (Requires Juspay VPN to access the dashboard)" >&2
          echo "" >&2
          echo "  Then run:" >&2
          echo "    export JUSPAY_API_KEY=your-api-key" >&2
          echo "" >&2
          exit 1
        fi
        ;;
    esac
  '';
in
{
  inherit checkApiKey;

  mkInitScript = configFile: ''
    ${checkApiKey}
    config_dir="$HOME/.config/opencode"
    config_file="$config_dir/opencode.json"
    if [ ! -f "$config_file" ]; then
      mkdir -p "$config_dir"
      cp ${configFile} "$config_file"
      chmod u+w "$config_file"
    fi
  '';

  mkConfigDir = { pkgs, configFile, skillsSrc }:
    pkgs.runCommand "opencode-config-dir" { } ''
      mkdir -p $out
      ln -s ${configFile} $out/opencode.json
      ln -s ${skillsSrc}/skills $out/skills
    '';
}
