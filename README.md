# OpenCode Nix

One-click [OpenCode](https://opencode.ai/) for Juspay.

> [!IMPORTANT]
> This flake is for **Juspay employees only**. It provides pre-configured OpenCode with Juspay's internal LLM API.

<figure>
<img width="1320" height="1098" alt="OpenCode running in the terminal with Juspay's LLM" src="https://github.com/user-attachments/assets/8a79ff2d-24c6-4142-a012-46687ab8bdeb" />
<figcaption>OpenCode running in the terminal with Juspay's LLM</figcaption>
</figure>

## Prerequisites

- **Nix** — Install via [nixone](https://juspay.github.io/nixone/), which also sets up [home-manager](https://github.com/nix-community/home-manager) in `~/.config/home-manager`
- **Nix flakes** — If you're new to flakes, see the [Nix First Steps](https://nixos.asia/en/nix-first) tutorial
- **`JUSPAY_API_KEY`** — Create one at [grid.ai.juspay.net/dashboard](https://grid.ai.juspay.net/dashboard) (requires VPN to create, but **not** to use OpenCode afterwards)

## Quick Start

### Choosing a mode

| | One-click | Default | home-manager |
|---|---|---|---|
| Command | `nix run github:juspay/oc#oneclick` | `nix run github:juspay/oc` | Via module in your config |
| Config | Embedded (read-only) | `~/.config/opencode/opencode.json` (editable) | Declarative via Nix |
| [Skills](https://opencode.ai/docs/skills/) | ✅ Bundled from [juspay/skills](https://github.com/juspay/skills) | ❌ | ✅ With `with-skills` module |
| Customizable | ❌ | ✅ Edit JSON | ✅ Via Nix |

### One-click

Config and skills embedded in package. Skills from [juspay/skills](https://github.com/juspay/skills) are bundled automatically:

```bash
export JUSPAY_API_KEY=your-api-key
nix run github:juspay/oc#oneclick
```

### Default

Auto-creates `~/.config/opencode/opencode.json` on first run. Edit this file to [customize your configuration](https://opencode.ai/docs/configuration/):

```bash
export JUSPAY_API_KEY=your-api-key
nix run github:juspay/oc
```

### With home-manager

> [!NOTE]
> If you installed Nix via [nixone](https://juspay.github.io/nixone/), home-manager is already configured at `~/.config/home-manager`. Otherwise, see [nixos-unified-template](https://github.com/juspay/nixos-unified-template) for getting started with home-manager.

Basic setup (no skills):

```nix
{
  inputs.oc.url = "github:juspay/oc";
  
  outputs = { inputs, ... }: {
    homeConfigurations.yourhost = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        inputs.oc.homeModules.default
        {
          programs.opencode.package = inputs.oc.packages.x86_64-linux.default;
        }
      ];
    };
  };
}
```

With skills from [juspay/skills](https://github.com/juspay/skills):

```nix
modules = [
  inputs.oc.homeModules.with-skills
  {
    programs.opencode.package = inputs.oc.packages.x86_64-linux.default;
  }
];
```

The `JUSPAY_API_KEY` environment variable must be set when running OpenCode, regardless of installation method.

To update opencode to the latest version (the flake.lock is auto-updated daily):

```bash
nix flake update oc
```

## Tips

### Web UI

OpenCode can run as a web application in your browser:

```bash
nix run github:juspay/oc -- web
```

This starts a local server and opens OpenCode in your default browser. Sessions are shared between the web UI and CLI, so you can switch between them seamlessly. You can also specify a port or make it accessible on your network with `--port 4096 --hostname 127.0.0.1`.

See the [OpenCode Web docs](https://opencode.ai/docs/web/) for more.

## Related

- [OpenCode Documentation](https://opencode.ai/docs/) — Full docs on usage, configuration, and providers
- [OpenCode GitHub](https://github.com/anomalyco/opencode) — The upstream OpenCode project
- [llm-agents.nix](https://github.com/numtide/llm-agents.nix) — The upstream Nix packaging that this flake builds on
- [juspay/skills](https://github.com/juspay/skills) — Juspay's OpenCode skills (Nix flake, Nix Haskell, etc.)
