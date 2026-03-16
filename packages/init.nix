{ pkgs, lib, opencode, configFile }:
let
  checkApiKey = import ./check-api-key.nix;
  initScript = checkApiKey + ''
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
