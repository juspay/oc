{ pkgs, lib, opencode, configFile, skillsSrc }:
let
  configDir = pkgs.runCommand "opencode-config-dir" { } ''
    mkdir -p $out
    ln -s ${configFile} $out/opencode.json
    ln -s ${skillsSrc}/skills $out/skills
  '';
in
pkgs.runCommand "opencode-skills" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta.mainProgram = "opencode";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe opencode} $out/bin/opencode \
    --set OPENCODE_CONFIG_DIR ${configDir}
''
