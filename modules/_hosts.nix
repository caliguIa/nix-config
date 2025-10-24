{inputs, ...}: {
    flake.darwinConfigurations.polyakov = inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = 
            (with inputs.self.modules.darwin; [home-manager homebrew network nix packages security shell ssh system user ghostty keymap nvim rainfrog tmux wm])
            ++ [inputs.nix-homebrew.darwinModules.nix-homebrew]
            ++ (with inputs.self.modules.homeManager; [user atuin fonts fzf git helix newsboat nh packages shell ssh starship nvim]);
    };
    flake.nixosConfigurations.george = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = 
            (with inputs.self.modules.nixos; [home-manager network nix packages security shell ssh system user nvim media minecraft proxy usenet])
            ++ (with inputs.self.modules.homeManager; [user atuin fonts fzf git nh packages shell ssh starship nvim]);
    };
}
