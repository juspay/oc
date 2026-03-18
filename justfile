# List available targets
default:
    @just --list

# Record the demo screencast (requires JUSPAY_API_KEY)
demo:
    nix run ./doc/demo --override-input oc .
    mv demo.gif doc/demo/

# Record the Claude Code demo screencast (requires JUSPAY_API_KEY)
demo-claude-code:
    nix run ./doc/demo-claude-code --override-input oc .
    mv demo.gif doc/demo-claude-code/
