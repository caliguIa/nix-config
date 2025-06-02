build-polyakov:
    git add .
    sudo darwin-rebuild switch --flake .#polyakov

build-george:
    git add .
    sudo nixos-rebuild switch --flake .#george

build-westerby:
    git add .
    sudo nixos-rebuild switch --flake .#westerby

update:
    nix flake update

pin-lock:
    git add flake.lock
    git commit -m "pin: update flake.lock"
    git push
