# AGENTS.md

NixOS configuration repository for agentic development.

## Overview

- **Purpose**: Personal NixOS system configuration for milaptop, zefir, rpi4 hosts
- **Desktop**: Niri compositor, Hyprland (phasing out), Gnome (abandoned)
- **Shell**: DankMaterialShell + Fish/Nushell + Starship
- **Editor**: Neovim (Nixvim configuration)

## Build Commands

### Verify flake and build

```bash
nix flake check                    # Validate flake.lock and inputs
nix flake lock                     # Update flake.lock
nix build                          # Build default host (auto-detect)
nix build '.#milaptop'              # Build milaptop configuration
nix build '.#zefir'                 # Build zefir configuration
nix build '.#rpi4'                  # Build raspberry pi 4 configuration
```

### Build specific outputs

```bash
cat $(nix build '.#misc-tools')     # Build misc tools overlay
nix build '.#host.milaptop'         # Alternative host-specific build
```

## Test Commands

NixOS flake configurations don't have unit tests, but we can verify:

```bash
# Evaluate configuration (syntax check)
nix eval @.

# Check flake metadata and inputs
nix flake metadata .

# Validate specific package
nix build '.#specialiser'           # Build specialiser for testing

# Check if Nixpkgs is accessible
nix eval 'nixpkgs.lib.version'

# Dry-run build to catch errors early
nix build --no-build-input-depends
```

## Code Style Guidelines

### File Organization

```
hosts/            # Host-specific overrides (milaptop, zefir, rpi4)
modules/          # Modular configurations
  apps/           # Application configs
  desktop/        # Desktop environment configs
  hardware/       # Hardware-specific fixes
  home/           # Home-manager configurations
  services/       # Service configs
  system/         # System-level configs
  work/           # Work-related configs
overlays/         # Custom package overlays
variables.nix     # Shared constants and variables
flake.nix         # Main flake definition
```

### Naming Conventions

| Element    | Convention        | Example              |
|------------|--------------------|----------------------|
| Directories| kebab-case          | hardware, services   |
| Files      | kebab-case + .nix   | nvidia.nix, docker.nix|
| Functions  | camelCase           | mkSvc, onActivation  |
| Variables  | camelCase           | config, lib          |
| Options    | kebab-case          | services.nginx.enable|

### Nix Expression Patterns

```nix
# Import pattern: group by category, alphabetical within
default = import ./modules
```

### Modules: structure and conventions

#### Aggregators (auto-import)

`modules/default.nix` auto-import NixOS modules from:

```nix
[
  ./apps
  ./hardware
  ./services
  ./system
  ./work
]
```

Rules:
- include directories, include `*.nix` files
- skip entries with `_` prefix

`modules/home/default.nix` same pattern for Home Manager modules:

```nix
[
  ./apps
  ./options
  ./services
  ./system
]
```

#### Typical NixOS feature module (modules/{apps,hardware,services,system,work}/*.nix)

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.custom.<namespace>;
in {
  options.custom.<namespace> = {
    enable = lib.mkEnableOption "<desc>";
    # more options...
  };

  config = lib.mkIf cfg.enable {
    # system config...
  };
}
```

Variant: base/system bundles sometimes use `cfg = config.custom;` and `config = { ... };` (no `mkIf`).

#### Typical Home Manager feature module (modules/home/**.nix)

Namespace: `custom-hm`.

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.custom-hm.<namespace>;
in {
  options.custom-hm.<namespace> = {
    enable = lib.mkEnableOption "<desc>";
    # more options...
  };

  config = lib.mkIf cfg.enable {
    # home-manager config...
  };
}
```

#### Desktop “profile” modules (modules/desktop/<wm>/default.nix)

Often no `options`/`enable` toggle. Apply config directly, sometimes wire HM config:

```nix
{ pkgs, vars, ... }:
{
  home-manager.users.${vars.username} = import ./config;
  programs.<wm>.enable = true;
  # session vars, portals, packages...
}
```

Home side lives under `modules/desktop/<wm>/config/` with explicit `imports = [ ... ];`.

#### Attribute set merging rule

When a module configures multiple sub-attributes of the same parent attribute, nest them under one parent block. Never repeat the parent prefix:

```nix
# WRONG — repeated parent
programs.fish.shellAliases = { ... };
programs.fish.functions.ax = '' ... '';
programs.fish.functions.ar = '' ... '';

# CORRECT — nested, sorted keys
programs.fish = {
  shellAliases = { ... };
  functions = {
    ar = '' ... '';
    ax = '' ... '';
  };
};
```

Sort keys alphabetically within each attribute set.

### Import Style

```nix
# Recommended: use flake inputs directly
import nixpkgs.lib.systems.flakeExposed

# Use builtins from flake inputs
import inputs.nixpkgs.lib.mkBin

# For home-manager with flake inputs
import home-manager.nixosModules.home-manager
```

### Type Conventions

Nix uses type inference (Haskell-style), but we add annotations:

```nix
# Type annotations for clarity
let
  config = { config, lib, ... }: {
    type = "nixos-config";
  };
in config
```

### Formatting Rules

- **Imports**: Top of file, grouped by category, alphabetical within group
- **Comments**: Use `/` for block comments, `//` for single-line
- **Spacing**: 
  - 2 spaces indentation (not tabs)
  - Single space after `{`, before `}`
  - No extra spaces after `let`, `in`
- **Parentheses**: Group complex expressions, no unnecessary grouping

### Error Handling

```
# Avoid: throws that fail
# Prefer: conditional expressions
config = if x != null then x else defaultValue

# Use withSystem for NixOS-specific code
withSystem "x86_64-linux":
  import <nixpkgs>

# Optional access patterns
name = config ? name.name

# Early returns null-check first
let
  x = { config, ... }:
    config.name != null /
    config.name
in x
```

### Best Practices

1. **Pure functions**: Use `imports` from flake inputs when available
2. **Reusability**: Create reusable modules for common patterns
3. **Documentation**: Add comments only before complex/non-obvious logic. Never comment trivial code.
4. **Testing**: Use `nix flake check` before committing
5. **Overlays**: Keep overlays minimal, prefer direct imports
6. **Variables**: Use `variables.nix` for shared configuration

## Cursor/Copilot Rules

No existing Cursor rules (`.cursor/rules/`, `.cursorrules`) or Copilot rules (`.github/copilot-instructions.md`) found.

## Package Management

Key Nix packages used (no custom derivations needed):
- Kitty terminal (overlay: `overlays/kitty.nix`)
- Spotify player (overlay: `overlays/spotify-player.nix`)
- Curl WebSocket upgrade (overlay: `overlays/curl-ws.nix`)
- Cato client (overlay: `overlays/cato-client.nix`)
- VCV Rack (overlay: `overlays/vcv-rack.nix`)
- Ansible 2.17 (overlay: `overlays/ansible_2_17.nix`)

## Common Workflows

### Add new service

```bash
1. Create in modules/services/<service>.nix
2. Import in modules/default.nix
3. Test with nix build
```

### Hardware-specific fix

```bash
1. Create in modules/hardware/<issue>.nix
2. Group with hardware/ directory in imports
```

### Desktop configuration split
```
1. modules/desktop/<wm>/default.nix    # NixOS-side profile (enable compositor, portals, session vars)
2. modules/desktop/<wm>/config/*.nix   # Home Manager side (WM config, keybinds, theming), via imports
```

### Variables shared across hosts

```bash
modules/variables.nix    # Common variables
hosts/<host>/variables   # Host-specific overrides
```

## Quick Reference

| Command | Purpose | Command |
|---------|---------|---------|
| Validate | Check flake syntax | `nix flake check` |
| Build | Build host | `nix build .#<host>` |
| Test | Verify inputs | `nix eval @.` |
| Lock | Update lockfile | `nix flake lock`

## Notes

- Avoid shell scripts; use Nix where possible
- Use `inputs.nixpkgs` from flake for package lookups
- `inputs.home-manager` for Home Manager modules
- `inputs.nix-gaming` enables gaming package set
- `inputs.lanzaboote` provides secure boot support
- `inputs.sops-nix` encodes sensitive secrets
- `inputs.catppuccin` provides color themes
