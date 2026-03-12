{
  description = "OpenCode Nix - Company-specific LiteLLM configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs@{ self, flake-parts, llm-agents, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { system, ... }: {
        packages.default = llm-agents.packages.${system}.opencode;

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/opencode";
        };
      };
    };
}
