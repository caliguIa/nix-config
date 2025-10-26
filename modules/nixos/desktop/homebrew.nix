{
    inputs,
    config,
    ...
}: let
    users = config.flake.meta.users;
in {
    flake.modules.darwin.desktop = {
        imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
        nix-homebrew.enable = true;
        nix-homebrew.user = users.primary;
        nix-homebrew.taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        nix-homebrew.mutableTaps = false;
        nix-homebrew.autoMigrate = true;
        homebrew = {
            enable = true;
            onActivation = {
                autoUpdate = true;
                upgrade = true;
            };
        };
    };
}
