#!/bin/bash

commands=(  
    "ous bounce::cd ~/ous; make down; make platform-up"  
    "ous down::cd ~/ous; make down"  
    "ous up::cd ~/ous; make platform-up"  
    "nixos-rebuild darwin::cd ~/nix-config; just build-darwin"  
    "nix-gc::nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc"  
)

selected=$(printf '%s\n' "${commands[@]}" | cut -d':' -f1 | fzf)

if [ -n "$selected" ]; then  
    for cmd in "${commands[@]}"; do  
        if [[ $cmd == ${selected}::* ]]; then  
            command="${cmd#*::}"
            # Create a new pane and run the command
            tmux split-window -h "eval '$command'; echo 'Press any key to exit...'; read -n 1"
            exit 0
        fi  
    done  
fi
