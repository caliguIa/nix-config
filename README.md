# Nix Config for macOS (and soon NixOS)

## Layout

```
.
├── apps         # Nix commands used to bootstrap and build configuration
├── hosts        # Host-specific configuration (macOS only currently)
├── modules      # macOS and nix-darwin, and shared configuration
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

## Update dependencies

```sh
nix flake update
```
