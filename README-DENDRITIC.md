# Dendritic Nix Configuration

This is a clean Dendritic flake-parts configuration supporting both Darwin (macOS) and NixOS.

## Structure

```
.
├── flake.nix               # Minimal flake entry point
├── hosts/                  # Host-specific configurations (imports modules)
│   ├── darwin.nix          # macOS host "polyakov"
│   └── nixos.nix           # NixOS host "george"
└── modules/                # Auto-loaded flake-parts modules
    ├── flake-parts.nix     # Declares flake.modules option
    ├── system/             # System-level modules
    │   ├── nix.nix         # Core Nix settings
    │   ├── user.nix        # User account configuration
    │   ├── home-manager.nix # Home-manager integration
    │   └── homebrew.nix    # Homebrew (Darwin only)
    └── home/               # Home-manager modules (cross-platform)
        └── git.nix         # Git configuration

```

## Key Principles

### 1. Aspect-Oriented Configuration

Each `.nix` file is a "feature" or "aspect" that configures the same concern across multiple platforms:

```nix
# modules/home/git.nix - configures git for ALL users on ALL systems
{
    flake.modules.homeManager.git = {
        programs.git = { ... };
    };
}
```

### 2. Platform Modules

Modules contribute to platform-specific configurations via `flake.modules.{platform}.{aspect}`:

- `flake.modules.darwin.{aspect}` - Darwin (macOS) system modules
- `flake.modules.nixos.{aspect}` - NixOS system modules  
- `flake.modules.homeManager.{aspect}` - Home-manager modules (cross-platform)

### 3. No Circular Dependencies

**Critical**: Modules MUST NOT use `inputs` in function signatures or imports. External dependencies should be imported in `hosts/*.nix`:

```nix
# ❌ BAD - creates circular dependency
flake.modules.darwin.foo = {inputs, ...}: {
    imports = [inputs.some-module];
};

# ✅ GOOD - import in hosts file instead
# hosts/darwin.nix
modules = [
    inputs.some-module
    inputs.self.modules.darwin.foo
];
```

## Adding New Features

### System-Level Feature

Create `modules/system/feature.nix`:

```nix
{
    flake.modules.darwin.feature = {
        # Darwin-specific config
    };
    
    flake.modules.nixos.feature = {
        # NixOS-specific config
    };
}
```

Then add to `hosts/{darwin,nixos}.nix`:

```nix
modules = with inputs.self.modules.darwin; [
    nix user homebrew home-manager
    feature  # <-- add here
];
```

### Home-Manager Feature

Create `modules/home/feature.nix`:

```nix
{
    flake.modules.homeManager.feature = {
        programs.something.enable = true;
    };
}
```

No need to modify hosts - homeManager modules are automatically loaded!

## Building

```bash
# Darwin
nix build .#darwinConfigurations.polyakov.system
darwin-rebuild switch --flake .

# NixOS  
nix build .#nixosConfigurations.george.config.system.build.toplevel
nixos-rebuild switch --flake .
```

## Next Steps

Now you can add:
- More packages to `modules/system/packages.nix`
- Shell configuration in `modules/home/shell.nix`
- Your Neovim config in `modules/home/nvim.nix` (without using `inputs`)
- Any other features as separate aspect modules
