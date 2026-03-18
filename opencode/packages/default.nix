{ pkgs, lib, opencode, opencode-init, opencode-oneclick, claude-code-oneclick }:
pkgs.writeShellApplication {
  name = "opencode";
  runtimeInputs = [ pkgs.gum ];
  text = ''
    choice=$(gum choose --header "Choose variant:" \
      "oneclick     — OpenCode with Juspay config and skills bundled" \
      "claude-code  — Claude Code with Juspay config" \
      "init         — OpenCode with editable Juspay config at ~/.config/opencode/" \
      "opencode     — Plain OpenCode, no Juspay config")

    case "$choice" in
      oneclick*)    exec ${lib.getExe' opencode-oneclick "opencode"} "$@" ;;
      claude-code*) exec ${lib.getExe' claude-code-oneclick "claude"} "$@" ;;
      init*)        exec ${lib.getExe' opencode-init "opencode"} "$@" ;;
      opencode*)    exec ${lib.getExe' opencode "opencode"} "$@" ;;
      *)            echo "No selection made."; exit 1 ;;
    esac
  '';
}
