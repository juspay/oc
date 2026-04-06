apm_cmd := "uvx --from 'git+https://github.com/microsoft/apm' apm"

# List available targets
default:
    @just --list

# Deploy APM primitives (rules, commands, skills, hooks)
apm:
    #!/usr/bin/env bash
    set -euo pipefail
    agent="${AI_AGENT:-claude}"
    # Extract program name (e.g. "claude" from "claude --dangerously-skip-permissions")
    target="${agent%% *}"
    {{ apm_cmd }} install -t "$target"

# Install APM config and launch coding agent (AI_AGENT overrides default)
agent *args: apm
    {{ env('AI_AGENT', 'claude') }} {{ args }}

# Record the demo screencast (requires JUSPAY_API_KEY)
demo:
    nix run ./demo --override-input oc . -- coding-agents/opencode/demo.tape
    mv demo.gif demo/
