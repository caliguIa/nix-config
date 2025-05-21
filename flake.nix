{
    description = "NixOS and Darwin system configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        darwin = {
            url = "github:LnL7/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-homebrew = {
            url = "github:zhaofengli-wip/nix-homebrew";
        };

        homebrew-bundle = {
            url = "github:homebrew/homebrew-bundle";
            flake = false;
        };

        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };

        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
            flake = false;
        };

        neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";
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
                    ./machines/nixos/${hostname}
                    inputs.home-manager.nixosModules.home-manager
                    {
                        networking.hostName = hostname;
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            extraSpecialArgs = {
                                inherit
                                    inputs
                                    system
                                    hostname
                                    username
                                    ;
                            };
                            users.${username} = ./users/${username};
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
                                "homebrew/homebrew-core" = inputs.homebrew-core;
                                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                            };
                            mutableTaps = false;
                            autoMigrate = true;
                        };

                        users.users.${username}.home = "/Users/${username}";

                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            extraSpecialArgs = {
                                inherit
                                    inputs
                                    system
                                    hostname
                                    username
                                    ;
                            };
                            users.${username} = ./users/${username};
                        };
                    }
                ];
            };
    in {
        nixosConfigurations = {
            george = mkNixosSystem {
                system = "x86_64-linux";
                hostname = "george";
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
