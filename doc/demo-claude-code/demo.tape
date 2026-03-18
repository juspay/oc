# Claude Code Demo
# Records a screencast of Claude Code with Juspay config
#
# Usage:
#   export JUSPAY_API_KEY=your-key
#   vhs demo.tape

Output demo.gif

Require nix

Set Shell "bash"
Set FontSize 22
Set Width 1200
Set Height 800
Set TypingSpeed 50ms
Set Theme "Catppuccin Mocha"
Set Padding 20

# Type the run command
Type "nix run github:juspay/oc#claude-code-oneclick"
Sleep 500ms
Enter

# Wait for Claude Code to load
Wait+Screen />/
Sleep 2s

# Type a hello world prompt.
# Trick: ask the LLM to concatenate two words (ALFA+BRAVO) and print the result.
# The prompt contains "ALFA" and "BRAVO" separately, but never "ALFABRAVO" as
# one string — so Wait+Screen only matches when the LLM outputs the combined form.
Type "briefly explain this repo. Then print ALFA concatenated with BRAVO."
Sleep 500ms
Enter

# Wait for the combined marker (only appears in the response)
Wait+Screen /ALFABRAVO/
Sleep 4s

# Exit Claude Code cleanly
Type "/exit"
Enter
Sleep 2s
