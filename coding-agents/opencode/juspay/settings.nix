let
  juspayProvider = import ./default.nix;
  baseSettings = import ../settings-base.nix;
in
baseSettings // {
  model = "litellm/glm-latest";
  agent = {
    explore = {
      mode = "subagent";
      model = "litellm/open-fast";
    };
  };
  provider = {
    litellm = juspayProvider;
  };
}
