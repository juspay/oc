# Run recipes from project root, not agents/
set working-directory := '..'

# Pinned to `master` (not a tag): comma-separated `-t claude,opencode` is
# only available on unreleased master — the last tagged release (v0.8.12)
# rejects it and also makes the multi-target flow hit the lock-file hash
# mismatch bug (microsoft/apm#529).
apm_cmd := "uvx --from git+https://github.com/microsoft/apm apm"
ai_agent := env('AI_AGENT', 'claude')

# Regenerate vendored APM output (.claude/ and .opencode/) from scratch
apm-vendor:
    rm -rf .claude/ .opencode/ apm.lock.yaml
    {{ apm_cmd }} install --force -t claude,opencode

# Update APM dependencies to latest, then re-vendor
update: && apm-vendor
    {{ apm_cmd }} install --update --force -t claude,opencode

# Launch coding agent (AI_AGENT overrides default)
[default]
run *args:
    {{ ai_agent }} {{ args }}
