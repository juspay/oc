{
  description = "One-click OpenCode & Claude Code for Juspay";

  nixConfig = {
    extra-substituters = "https://cache.nixos.asia/oss";
    extra-trusted-public-keys = "oss:KO872wNJkCDgmGN3xy9dT89WAhvv13EiKncTtHDItVU=";
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nixpkgs.follows = "llm-agents/nixpkgs";
    nix-agent-wire.url = "github:srid/nix-agent-wire";
    skills = {
      url = "github:juspay/skills";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-parts, llm-agents, nixpkgs, nix-agent-wire, skills, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { self', lib, pkgs, system, inputs', ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            llm-agents.overlays.default
            # Expose agent packages directly for callPackage to auto-fill arguments
            (final: prev: {
              opencode = prev.llm-agents.opencode;
              claude-code = prev.llm-agents.claude-code;
            })
          ];
        };

        packages = {
          default = pkgs.callPackage ./opencode/packages/default.nix {
            opencode-init = self'.packages.opencode-init;
            opencode-oneclick = self'.packages.opencode-oneclick;
            claude-code-oneclick = self'.packages.claude-code-oneclick;
          };
          opencode = pkgs.opencode;
          opencode-init = pkgs.callPackage ./opencode/packages/init.nix { configFile = pkgs.callPackage ./opencode/packages/config.nix { }; };
          opencode-oneclick = pkgs.callPackage ./opencode/packages/oneclick.nix {
            configFile = pkgs.callPackage ./opencode/packages/config.nix { };
            skillsSrc = inputs.skills;
          };
          claude-code = pkgs.claude-code;
          claude-code-oneclick = pkgs.callPackage ./claude-code/packages/oneclick.nix {
            skillsSrc = inputs.skills;
          };
        };

        apps = {
          default.program = lib.getExe' self'.packages.default "opencode";
          opencode.program = lib.getExe' self'.packages.opencode "opencode";
          opencode-init.program = lib.getExe' self'.packages.opencode-init "opencode";
          opencode-oneclick.program = lib.getExe' self'.packages.opencode-oneclick "opencode";
          claude-code.program = lib.getExe self'.packages.claude-code;
          claude-code-oneclick.program = lib.getExe' self'.packages.claude-code-oneclick "claude";
        };
      };

      flake.homeModules = {
        default = import ./opencode/modules;
        with-skills = { ... }: {
          imports = [
            self.homeModules.default
            nix-agent-wire.homeModules.opencode
          ];
          programs.opencode.autoWire.dirs = [ skills ];
        };
        claude-code = import ./claude-code/modules;
        claude-code-with-skills = { ... }: {
          imports = [
            self.homeModules.claude-code
            nix-agent-wire.homeModules.claude-code
          ];
          programs.claude-code.autoWire.dirs = [ skills ];
        };
      };
    };
}
