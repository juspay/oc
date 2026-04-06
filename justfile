apm_cmd := "uvx --from 'git+https://github.com/microsoft/apm' apm"

# List available targets
default:
    @just --list

# Install apm dependencies and compile local instructions
apm:
    {{ apm_cmd }} install -t claude
    {{ apm_cmd }} compile -t claude

# Record the demo screencast (requires JUSPAY_API_KEY)
demo:
    nix run ./demo --override-input oc . -- coding-agents/opencode/demo.tape
    mv demo.gif demo/
