{ pkgs, lib, opencode, configFile, skillsDir }:
let
  ocLib = import ./lib.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "opencode";
  text = ''
    ${ocLib.ensureApiKey}
    ${ocLib.setupConfigDir { inherit configFile skillsDir; }}
    exec ${lib.getExe opencode} "$@"
  '';
}
