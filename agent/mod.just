# Run recipes from project root, not agents/
set working-directory := '..'

apm_cmd := "nix run github:numtide/llm-agents.nix#apm --"
ai_agent := env('AI_AGENT', 'claude')
# Extract program name (e.g. "claude" from "claude --dangerously-skip-permissions")
apm_target := replace_regex(ai_agent, ' .*', '')

# Deploy APM primitives for current agent target
# --force: without it, apm skips existing files and omits them from the lock
apm:
    {{ apm_cmd }} install --force -t {{ apm_target }}

# Regenerate all vendored APM output (.claude/ and .opencode/) from scratch
# Wipe first to catch orphan files not produced by current apm deps
apm-vendor:
    rm -rf .claude/ .opencode/
    {{ apm_cmd }} install --force -t claude
    {{ apm_cmd }} install --force -t opencode

# Update APM dependencies to latest
update:
    {{ apm_cmd }} install --update --force -t {{ apm_target }}

# Launch coding agent (AI_AGENT overrides default)
[default]
run *args:
    {{ ai_agent }} {{ args }}
