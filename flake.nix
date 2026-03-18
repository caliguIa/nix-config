{
    description = "NixOS system configuration";
    outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.darwin.follows = "";
        };
        apple-silicon.url = "github:nix-community/nixos-apple-silicon";
        fonts.url = "git+ssh://git@github.com/caliguIa/fonts";
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                home-manager.follows = "home-manager";
            };
        };
    };
}
