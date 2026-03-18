# Base OpenCode settings shared across all configurations.
# Provider-agnostic: no model defaults, no provider config.
{
  autoupdate = true;
  mcp = {
    deepwiki = {
      type = "remote";
      url = "https://mcp.deepwiki.com/mcp";
      enabled = true;
    };
  };
  plugin = [ ];
}
