# Run recipes from project root, not agents/
set working-directory := '..'

apm_cmd := "nix run github:numtide/llm-agents.nix#apm --"
ai_agent := env('AI_AGENT', 'claude')

# Regenerate vendored APM output (.claude/ and .opencode/) from scratch
apm-vendor:
    rm -rf .claude/ .opencode/
    {{ apm_cmd }} install --force -t claude
    {{ apm_cmd }} install --force -t opencode

# Update APM dependencies to latest, then re-vendor
update:
    {{ apm_cmd }} install --update --force -t claude
    rm -rf .claude/ .opencode/
    {{ apm_cmd }} install --force -t claude
    {{ apm_cmd }} install --force -t opencode

# Launch coding agent (AI_AGENT overrides default)
[default]
run *args:
    {{ ai_agent }} {{ args }}
