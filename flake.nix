{
    description = "NixOS and Darwin system configurations";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
        plugins-timber = {
            url = "github:Goose97/timber.nvim";
            flake = false;
        };
    };
    outputs = {
        self,
        nixpkgs,
        home-manager,
        darwin,
        ...
    } @ inputs: let
        inherit (nixpkgs) lib;
        username = "caligula";
        systems = {
            george = {
                system = "x86_64-linux";
                hostname = "george";
            };
            westerby = {
                system = "aarch64-linux";
                hostname = "westerby";
            };
            polyakov = {
                system = "aarch64-darwin";
                hostname = "polyakov";
            };
        };

        isDarwin = system: lib.hasSuffix "-darwin" system;

        platformConfigs = {
            darwin = {
                builder = darwin.lib.darwinSystem;
                homeManagerModule = home-manager.darwinModules.home-manager;
                extraModules = [
                    inputs.nix-homebrew.darwinModules.nix-homebrew
                    (import ./modules/homebrew.nix {inherit inputs username;})
                ];
            };
            nixos = {
                builder = lib.nixosSystem;
                homeManagerModule = home-manager.nixosModules.home-manager;
                extraModules = [];
            };
        };

        mkSystem = {
            system,
            hostname,
        }: let
            config =
                platformConfigs.${
                    if isDarwin system
                    then "darwin"
                    else "nixos"
                };
            specialArgs = {
                inherit inputs system hostname username;
                homeDirectory =
                    if isDarwin system
                    then "/Users/${username}"
                    else "/home/${username}";
            };
        in
            config.builder {
                inherit system;
                specialArgs = specialArgs;
                modules =
                    [
                        ./machines/${hostname}
                        config.homeManagerModule
                        {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                backupFileExtension = "backup";
                                extraSpecialArgs = specialArgs;
                                users.${username} = ./user/home.nix;
                            };
                        }
                    ]
                    ++ config.extraModules;
            };
    in {
        neovim = import ./modules/nvim {
            inherit inputs;
            nvimPath = self + /modules/nvim;
        };
        darwinConfigurations =
            lib.mapAttrs (name: cfg: mkSystem cfg)
            (lib.filterAttrs (n: v: isDarwin v.system) systems);
        nixosConfigurations =
            lib.mapAttrs (name: cfg: mkSystem cfg)
            (lib.filterAttrs (n: v: !isDarwin v.system) systems);
    };
}
