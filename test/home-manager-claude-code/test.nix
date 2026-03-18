{ oc, home-manager }:
{
  name = "claude-code-home-manager";

  nodes.machine = { pkgs, ... }: {
    imports = [ home-manager.nixosModules.home-manager ];

    users.users.testuser = {
      isNormalUser = true;
      uid = 1000;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.testuser = {
        imports = [ oc.homeModules.claude-code ];

        programs.bash.enable = true;

        home = {
          username = "testuser";
          homeDirectory = "/home/testuser";
          stateVersion = "24.05";
        };
      };
    };

    system.stateVersion = "24.05";
  };

  testScript = ''
    import json

    machine.start()
    machine.wait_for_unit("multi-user.target")

    machine.succeed("loginctl enable-linger testuser")

    # Verify claude-code settings file was created
    settings_path = "/home/testuser/.claude/settings.json"
    settings_file = machine.succeed(f"su - testuser -c 'cat {settings_path}'")
    print(f"Settings file contents: {settings_file}")

    settings = json.loads(settings_file)
    env = settings.get("env", {})

    if env.get("ANTHROPIC_BASE_URL") == "https://grid.ai.juspay.net/":
        print("✅ ANTHROPIC_BASE_URL configured correctly")
    else:
        raise Exception("ANTHROPIC_BASE_URL not found or incorrect")

    if env.get("ANTHROPIC_MODEL") == "glm-latest":
        print("✅ ANTHROPIC_MODEL configured correctly")
    else:
        raise Exception("ANTHROPIC_MODEL not found or incorrect")

    if settings.get("permissions", {}).get("defaultMode") == "bypassPermissions":
        print("✅ Permissions configured correctly")
    else:
        raise Exception("Permissions not configured correctly")

    print("✅ Claude Code home-manager module configured correctly")
  '';
}
