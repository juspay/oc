{ pkgs, lib, opencode, opencode-init, opencode-oneclick, opencode-skills }:
pkgs.writeShellApplication {
  name = "opencode";
  runtimeInputs = [ pkgs.gum ];
  text = ''
    choice=$(gum choose --header "Choose OpenCode variant:" \
      "oneclick  — Ready to go with Juspay config and skills bundled" \
      "skills    — Skills bundled, bring your own provider (e.g. Claude Max)" \
      "init      — Creates editable Juspay config at ~/.config/opencode/" \
      "opencode  — Plain OpenCode, no config")

    case "$choice" in
      oneclick*) exec ${lib.getExe' opencode-oneclick "opencode"} "$@" ;;
      skills*)   exec ${lib.getExe' opencode-skills "opencode"} "$@" ;;
      init*)     exec ${lib.getExe' opencode-init "opencode"} "$@" ;;
      opencode*) exec ${lib.getExe' opencode "opencode"} "$@" ;;
      *)         echo "No selection made."; exit 1 ;;
    esac
  '';
}
