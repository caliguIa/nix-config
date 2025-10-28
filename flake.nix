{
    description = "NixOS and Darwin system configuration";
    outputs = {flake-parts, ...} @ inputs: flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
        homebrew-cask.url = "github:homebrew/homebrew-cask";
        homebrew-cask.flake = false;
        fonts.url = "git+ssh://git@github.com/caliguIa/fonts";
        fonts.inputs.nixpkgs.follows = "nixpkgs";
        stylix.url = "github:nix-community/stylix";
        stylix.inputs.nixpkgs.follows = "nixpkgs";
        nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
        nvim-nightly.inputs.nixpkgs.follows = "nixpkgs";
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    };
}
