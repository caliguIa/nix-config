{
    description = "NixOS and Darwin system configuration";
    outputs = {flake-parts, ...} @ inputs: flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        apple-silicon.url = "github:nix-community/nixos-apple-silicon";
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
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                home-manager.follows = "home-manager";
            };
        };
    };
}
