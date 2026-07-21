{
    description = "NixOS system configuration";
    outputs = inputs: let
        import-tree = import ./lib/recursivelyImport.nix {lib = inputs.nixpkgs.lib;};
    in
        inputs.flake-parts.lib.mkFlake {inherit inputs;} {
            imports = import-tree [./modules];
        };
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        hjem = {
            url = "github:feel-co/hjem";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.darwin.follows = "";
        };
        nixos-core.url = "github:manic-systems/nixos-core";
        apple-silicon.url = "github:nix-community/nixos-apple-silicon";
        fonts.url = "git+ssh://git@github.com/caliguIa/fonts";
        nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "";
        };
    };
}
