{
    description = "NixOS and Darwin system configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts = {
            url = "github:hercules-ci/flake-parts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        import-tree = {
            url = "github:vic/import-tree";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        darwin = {
            url = "github:LnL7/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };
        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
            flake = false;
        };
        fonts = {
            url = "git+ssh://git@github.com/caliguIa/fonts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixCats.url = "github:BirdeeHub/nixCats-nvim";
        neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        plugins-indentmini = {
            url = "github:nvimdev/indentmini.nvim";
            flake = false;
        };
        plugins-zendiagram = {
            url = "github:caliguIa/zendiagram.nvim";
            flake = false;
        };
        plugins-fff = {
            url = "github:dmtrKovalenko/fff.nvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        plugins-ts-error = {
            url = "github:dmmulroy/ts-error-translator.nvim";
            flake = false;
        };
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    };
    outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (
        {config, ...}: {
	    systems = ["aarch64-darwin", "x86_64-linux"];
            imports = [
                ./modules/dendrite.nix
                (inputs.import-tree ./modules)
            ];
            
            flake.darwinConfigurations.polyakov = inputs.darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                modules = 
                    (with config.flake.modules.darwin; [home-manager homebrew network nix packages security shell ssh system user ghostty keymap nvim rainfrog tmux wm])
                    ++ [inputs.nix-homebrew.darwinModules.nix-homebrew]
                    ++ (with config.flake.modules.homeManager; [user atuin fonts fzf git helix newsboat nh packages shell ssh starship nvim]);
            };
            
            flake.nixosConfigurations.george = inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = 
                    (with config.flake.modules.nixos; [home-manager network nix packages security shell ssh system user nvim media minecraft proxy usenet])
                    ++ (with config.flake.modules.homeManager; [user atuin fonts fzf git nh packages shell ssh starship nvim]);
            };
        }
    );
}
