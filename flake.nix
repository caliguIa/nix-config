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
        plugins-fold-imports = {
            url = "github:dmtrKovalenko/fold-imports.nvim";
            flake = false;
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
    outputs = {...} @ inputs: let
        mkNixosSystem = {
            system,
            hostname,
            username,
        }:
            inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                    inherit
                        inputs
                        system
                        hostname
                        username
                        ;
                };
                modules = [
                    {nixpkgs.config.allowUnfree = true;}
                    ./machines/nixos/${hostname}
                    inputs.home-manager.nixosModules.home-manager
                    {
                        networking.hostName = hostname;
                        home-manager = {
                            useUserPackages = true;
                            extraSpecialArgs = {
                                inherit
                                    inputs
                                    system
                                    hostname
                                    username
                                    ;
                                homeDirectory = "/home/${username}";
                            };
                            users.${username} = ./users/${username}/home.nix;
                        };
                    }
                ];
            };
        mkDarwinSystem = {
            system,
            hostname,
            username,
        }:
            inputs.darwin.lib.darwinSystem {
                inherit system;
                specialArgs = {
                    inherit
                        inputs
                        system
                        hostname
                        username
                        ;
                };
                modules = [
                    ./machines/darwin/${hostname}
                    inputs.home-manager.darwinModules.home-manager
                    inputs.nix-homebrew.darwinModules.nix-homebrew
                    {
                        nix-homebrew = {
                            enable = true;
                            user = username;
                            taps = {
                                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                                "homebrew/homebrew-core" = inputs.homebrew-core;
                            };
                            mutableTaps = false;
                            autoMigrate = true;
                        };
                        home-manager = {
                            useUserPackages = true;
                            extraSpecialArgs = {
                                inherit
                                    inputs
                                    system
                                    hostname
                                    username
                                    ;
                                homeDirectory = "/Users/${username}";
                            };
                            users.${username} = ./users/${username}/home.nix;
                        };
                    }
                ];
            };
    in {
        neovim = import ./modules/common/nvim {inherit inputs;};
        nixosConfigurations = {
            george = mkNixosSystem {
                system = "x86_64-linux";
                hostname = "george";
                username = "caligula";
            };
            westerby = mkNixosSystem {
                system = "aarch64-linux";
                hostname = "westerby";
                username = "caligula";
            };
        };
        darwinConfigurations = {
            polyakov = mkDarwinSystem {
                system = "aarch64-darwin";
                hostname = "polyakov";
                username = "caligula";
            };
        };
    };
}
