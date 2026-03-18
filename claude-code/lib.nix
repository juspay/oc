rec {
  # Shared init script snippet that checks for JUSPAY_API_KEY.
  # Skips the check when --version or --help is passed.
  checkApiKey = ''
    case " $CLAUDE_WRAPPER_ARGS " in
      *" --version "* | *" --help "* | *" -v "* | *" -h "*) ;;
      *)
        if [ -z "$JUSPAY_API_KEY" ]; then
          echo "" >&2
          echo "  Error: JUSPAY_API_KEY environment variable is not set." >&2
          echo "" >&2
          echo "  Create an API key at: https://grid.ai.juspay.net/dashboard" >&2
          echo "  (Requires Juspay VPN to access the dashboard)" >&2
          echo "" >&2
          echo "  Then run:" >&2
          echo "    export JUSPAY_API_KEY=your-api-key" >&2
          echo "" >&2
          exit 1
        fi
        ;;
    esac
  '';

  # Default model for Juspay's LLM proxy
  defaultModel = "glm-latest";

  # All env vars from the official Juspay jclaude() wrapper.
  # Takes the model name as argument.
  juspayEnvSetup = model: ''
    export ANTHROPIC_AUTH_TOKEN="$JUSPAY_API_KEY"
    export ANTHROPIC_MODEL="${model}"
    export ANTHROPIC_SMALL_FAST_MODEL="${model}"
    export CLAUDE_CODE_SUBAGENT_MODEL="${model}"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="${model}"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="${model}"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="${model}"
  '';

  # Static env vars that can be set at build time via --set
  juspayStaticEnv = {
    ANTHROPIC_BASE_URL = "https://grid.ai.juspay.net/";
    DISABLE_INTERLEAVED_THINKING = "true";
    API_TIMEOUT_MS = "600000";
    BASH_MAX_TIMEOUT_MS = "300000";
    CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS = "1";
    # Unset conflicting vars
    GEMINI_API_KEY = "";
    GOOGLE_CLOUD_PROJECT = "";
    GOOGLE_APPLICATION_CREDENTIALS = "";
    CLAUDE_CODE_USE_VERTEX = "";
    CLOUD_ML_REGION = "";
    GOOGLE_VERTEX_PROJECT = "";
    ANTHROPIC_VERTEX_PROJECT_ID = "";
  };
}
