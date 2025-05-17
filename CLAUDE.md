# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- macOS: `nix run .#build-switch` or `just build` to build and apply changes
- macOS: `nix run .#build` to verify configuration without applying
- NixOS: `nixos-rebuild switch --flake .#hostname` to build and apply changes
- Update dependencies: `nix flake update` or `just update`
- Rollback: `nix run .#rollback` (macOS) or `nixos-rebuild --rollback` (NixOS)

## Code Style
- 2-space indentation consistently across Nix files
- camelCase for variable and function names
- Single quotes for simple strings, double quotes for strings with interpolation
- Vertical alignment for multi-line attribute sets
- Modular organization: platform-specific (darwin/, nixos/), shared (shared/), host-specific (hosts/)
- Package and service configurations in separate modules
- Functions take attribute sets with default arguments specified using `{ param ? defaultValue }`
- When adding packages or services, follow existing patterns in respective modules