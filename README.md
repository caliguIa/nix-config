# Nix Config for macOS and NixOS

## Layout

```
.
├── apps         # Nix commands used to bootstrap and build configuration
├── hosts        # Host-specific configuration for both macOS and NixOS
│   ├── darwin   # macOS configuration
│   └── nixos    # NixOS server configuration
├── modules      # Configuration modules
│   ├── darwin   # macOS-specific modules
│   ├── nixos    # NixOS-specific modules
│   └── shared   # Shared configuration modules
```

# Installing

## For MacOS

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install Nix

Via [Determinate Systems'](https://determinate.systems/) installer

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. Initialize repo

```sh
git clone git@github.com:caliguIa/nix-config.git
```

### 4. Make apps executable

```sh
find apps/$(uname -m)-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys \) -exec chmod +x {} \;
```

### 5. Apply your current user info

```sh
nix run .#apply
```

### 6. Install configuration

First-time installations require you to move the current `/etc/nix/nix.conf` out of the way.

```sh
[ -f /etc/nix/nix.conf ] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

### 7. Making changes

Edit away, if you want to ensure the build works before deploying the configuration, run:

```sh
nix run .#build
```

Finally, alter your system with this command:

```sh
nix run .#build-switch
```

## For NixOS

### 1. Install NixOS

Install NixOS according to the [official documentation](https://nixos.org/manual/nixos/stable/index.html#sec-installation).

### 2. Clone this repository

```sh
git clone https://github.com/caliguIa/nix-config.git
cd nix-config
```

### 3. No need to copy hardware configuration

The system is configured to use the hardware-configuration.nix directly from its location at `/etc/nixos/hardware-configuration.nix`.

### 4. Build and apply the configuration

```sh
nixos-rebuild switch --flake .#george
```

## Update dependencies

```sh
nix flake update
```
