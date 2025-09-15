build:
    git add .
    @if [ -x "$(command -v darwin-rebuild)" ]; then \
        nh darwin switch .; \
    elif [ -x "$(command -v nixos-rebuild)" ]; then \
        sudo nixos-rebuild switch --flake .; \
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
