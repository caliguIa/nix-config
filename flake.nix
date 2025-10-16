{
    description = "NixOS and Darwin system configuration";
    outputs = {
        self,
        nixpkgs,
        ...
    } @ inputs: let
        inherit (nixpkgs) lib;
        username = "caligula";
        sysLib = import ./lib {inherit inputs lib username;};
        inherit (sysLib) isDarwin systems mkSystem;
    in {
        neovim = import ./modules/nvim {
            inherit inputs username;
            nvimPath = self + /modules/nvim;
            helpers = {inherit (sysLib) isDarwin mkHomeDirectory;};
        };
        darwinConfigurations =
            lib.mapAttrs (name: cfg: mkSystem cfg)
            (lib.filterAttrs (n: v: isDarwin v.system) systems);
        nixosConfigurations =
            lib.mapAttrs (name: cfg: mkSystem cfg)
            (lib.filterAttrs (n: v: !isDarwin v.system) systems);
    };
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
}
