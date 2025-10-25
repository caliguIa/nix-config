{inputs, ...}: {
    flake.modules.darwin.desktop = let
        username = "caligula";
    in {
        imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
        nix-homebrew.enable = true;
        nix-homebrew.user = username;
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
