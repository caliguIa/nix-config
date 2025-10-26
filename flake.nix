{
    description = "NixOS and Darwin system configuration";
    outputs = {flake-parts, ...} @ inputs:
        flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
            flake = false;
        };
        fonts = {
            url = "git+ssh://git@github.com/caliguIa/fonts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix";
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
        # plugins-timber = {
        #     url = "github:Goose97/timber.nvim";
        #     flake = false;
        # };
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    };
}
