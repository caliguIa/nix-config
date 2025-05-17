# macOS (darwin) commands
build-darwin:
    git add .
    darwin-rebuild switch --flake .#polyakov

# NixOS commands
build-nixos:
    git add .
    sudo nixos-rebuild switch --flake .#george

# General commands
update:
    nix flake update

pin-lock:
    git add flake.lock
    git commit -m "pin: update flake.lock"
    git push
