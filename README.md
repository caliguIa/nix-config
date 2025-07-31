# Nix Configuration

My personal Nix configuration for both NixOS and macOS (via nix-darwin) systems.

## Structure

```
.
├── dots/              # Configuration files for programs
│   └── ...
├── machines/          # Host-specific configurations
│   ├── darwin/        # macOS configurations
│   │   └── polyakov/  # Configuration for macOS host "polyakov"
│   └── nixos/         # NixOS configurations
│       └── george/    # Configuration for NixOS host "george"
├── modules/           # Common modules
│   └── common/        # Shared modules for all systems
└── users/             # User-specific configurations
    └── caligula/      # Configuration for user "caligula"
```

