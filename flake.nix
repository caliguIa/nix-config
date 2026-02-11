{
    description = "NixOS and Darwin system configuration";
    outputs = {flake-parts, ...} @ inputs: flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        apple-silicon.url = "github:nix-community/nixos-apple-silicon";
        hyprland.url = "github:hyprwm/Hyprland";
        fonts.url = "git+ssh://git@github.com/caliguIa/fonts";
        stylix.url = "github:nix-community/stylix";
        stylix.inputs.nixpkgs.follows = "nixpkgs";
        nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
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
