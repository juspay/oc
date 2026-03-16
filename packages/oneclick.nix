{ pkgs, lib, opencode, configFile, skillsSrc }:
let
  initScript = ''
    case " $OPENCODE_WRAPPER_ARGS " in
      *" --version "* | *" --help "* | *" -v "* | *" -h "*) ;;
      *)
        if [ -z "$JUSPAY_API_KEY" ]; then
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
  configDir = pkgs.runCommand "opencode-config-dir" { } ''
    mkdir -p $out
    ln -s ${configFile} $out/opencode.json
    ln -s ${skillsSrc}/skills $out/skills
  '';
in
pkgs.runCommand "opencode-juspay" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta.mainProgram = "opencode";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe opencode} $out/bin/opencode \
    --run 'export OPENCODE_WRAPPER_ARGS="$@"' \
    --run '${initScript}' \
    --set OPENCODE_CONFIG_DIR ${configDir}
''

