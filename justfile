build:
    git add .
    nix run .#build-switch

update:
    nix flake update

pin-lock:
    git add flake.lock
    git commit -m "pin: update flake.lock"
    git push
