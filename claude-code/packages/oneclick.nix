{ pkgs, lib, claude-code, skillsSrc }:
let
  ccLib = import ../lib.nix;
  model = ccLib.defaultModel;

  # Build --set flags for all static env vars
  setFlags = lib.concatStringsSep " \\\n    "
    (lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") ccLib.juspayStaticEnv);
in
pkgs.runCommand "claude-code-juspay" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta.mainProgram = "claude";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe claude-code} $out/bin/claude \
    --run 'export CLAUDE_WRAPPER_ARGS="$@"' \
    --run '${ccLib.checkApiKey}' \
    --run '${ccLib.juspayEnvSetup model}' \
    ${setFlags}
''
