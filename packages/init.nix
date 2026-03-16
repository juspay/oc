{ pkgs, lib, opencode, configFile }:
let
  initScript = ''
    case " $OPENCODE_WRAPPER_ARGS " in
      *" --version "* | *" --help "* | *" -v "* | *" -h "*) ;;
      *)
        if [ -z "$JUSPAY_API_KEY" ]; then
          echo "Error: JUSPAY_API_KEY environment variable is not set." >&2
          echo "Please set it before running opencode:" >&2
          echo "  export JUSPAY_API_KEY=your-api-key" >&2
          exit 1
        fi
        ;;
    esac
    config_dir="$HOME/.config/opencode"
    config_file="$config_dir/opencode.json"
    if [ ! -f "$config_file" ]; then
      mkdir -p "$config_dir"
      cp ${configFile} "$config_file"
      chmod u+w "$config_file"
    fi
  '';
in
pkgs.runCommand "opencode-juspay-init" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta.mainProgram = "opencode";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe opencode} $out/bin/opencode \
    --run 'export OPENCODE_WRAPPER_ARGS="$@"' \
    --run '${initScript}'
''
