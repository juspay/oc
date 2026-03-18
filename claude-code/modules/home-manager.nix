{ config, lib, pkgs, ... }:
let
  ccLib = import ../lib.nix;
in
{
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        ANTHROPIC_BASE_URL = "https://grid.ai.juspay.net/";
        ANTHROPIC_MODEL = ccLib.defaultModel;
        ANTHROPIC_SMALL_FAST_MODEL = ccLib.defaultModel;
        CLAUDE_CODE_SUBAGENT_MODEL = ccLib.defaultModel;
        ANTHROPIC_DEFAULT_SONNET_MODEL = ccLib.defaultModel;
        ANTHROPIC_DEFAULT_OPUS_MODEL = ccLib.defaultModel;
        ANTHROPIC_DEFAULT_HAIKU_MODEL = ccLib.defaultModel;
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
      permissions = {
        defaultMode = "bypassPermissions";
      };
    };
  };
}
