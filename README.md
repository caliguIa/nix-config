# Nix Configuration

My personal Nix configuration for both NixOS and macOS (via nix-darwin) systems.

## Structure

```
.
├── dots/              # Configuration files for programs
│   ├── git/           # Git configuration
│   │   └── default.nix
│   ├── zsh/           # ZSH configuration  
│   │   └── default.nix
│   ├── nvim/          # Neovim configuration
│   │   ├── default.nix
│   │   └── ... (lua config files)
│   ├── tmux/          # Tmux configuration
│   │   ├── default.nix
│   │   └── tmux.conf
│   ├── bin/           # Shell scripts
│   │   ├── default.nix
│   │   └── *.sh
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

## Usage

### NixOS

```bash
# Apply the configuration
sudo nixos-rebuild switch --flake .#george
# or
just build-nixos
```

### macOS (nix-darwin)

```bash
# Apply the configuration 
darwin-rebuild switch --flake .#polyakov
# or
just build-darwin
```

## Design Principles

1. **User-centric**: User configurations are machine-agnostic and defined once
2. **Machine-specific**: Machine configurations import machine-specific dot files
3. **Modular**: Each program has its own dot directory containing config and nix files
4. **Self-contained**: Config files are stored alongside their nix configuration

## Adding a New Machine

1. Create a new directory under `machines/{darwin,nixos}/hostname/`
2. Add the machine to `flake.nix`
3. Import any machine-specific dot configurations

## Adding a New User

1. Create a new directory under `users/username/`
2. Configure user with machine-agnostic configurations

## Adding a New Program Configuration

1. Create a new directory under `dots/program-name/`
2. Create a `default.nix` file within that directory
3. Add any program-specific config files in the same directory
4. Import in either user configuration (if common) or in machine configuration (if specific)