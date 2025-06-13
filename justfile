build:
    git add .
    @if [ -x "$(command -v darwin-rebuild)" ]; then \
        sudo darwin-rebuild switch --flake .#`hostname -s`; \
    elif [ -x "$(command -v nixos-rebuild)" ]; then \
        sudo nixos-rebuild switch --flake .#`hostname -s`; \
    else \
        echo "Error: Neither darwin-rebuild nor nixos-rebuild found"; \
        exit 1; \
    fi

update:
    nix flake update

pin-lock:
    git add flake.lock
    git commit -m "pin: update flake.lock"
    git push
