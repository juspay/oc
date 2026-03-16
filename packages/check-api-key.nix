# Shared init script snippet that checks for JUSPAY_API_KEY.
# Skips the check when --version or --help is passed.
''
  case " $OPENCODE_WRAPPER_ARGS " in
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
''
