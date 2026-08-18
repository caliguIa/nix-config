{
    description = "NixOS system configuration";
    outputs =
        inputs:
        let
            import-tree = import ./lib/recursivelyImport.nix { lib = inputs.nixpkgs.lib; };
        in
        inputs.flake-parts.lib.mkFlake { inherit inputs; } {
            imports = import-tree [ ./modules ];
        };
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        # Pinned to the last nixpkgs commit shipping Mesa 26.1.6. Mesa 26.2.0
        # introduced a radeonsi VAAPI green-box decode regression on RDNA3
        # (Radeon 780M / karla). Used only for hardware.graphics.package on
        # karla; drop once upstream Mesa fixes the regression.
        nixpkgs-mesa.url = "github:nixos/nixpkgs/5482002f056a0e1260b794366cc84f8f4e7d1ee7";
        flake-parts.url = "github:hercules-ci/flake-parts";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        hjem = {
            url = "github:feel-co/hjem";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "";
            inputs.darwin.follows = "";
        };
        nixos-core.url = "github:manic-systems/nixos-core";
        apple-silicon.url = "github:nix-community/nixos-apple-silicon";
        nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "";
        };
        zmk-nix = {
            url = "github:lilyinstarlight/zmk-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
