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
        # Pinned to the last known-good linux-firmware (20260622); the 20260810
        # bump regresses AMD power/thermal behaviour. See nixpkgs#556260.
        # Consumed only by the linux-firmware overlay, not the system as a whole.
        nixpkgs-firmware.url = "github:nixos/nixpkgs/a7466627e66d";
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
