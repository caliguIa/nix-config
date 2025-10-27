topLevel @ {inputs, ...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.darwin.system-desktop-homebrew = {config, ...}: {
        imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
        nix-homebrew.enable = true;
        nix-homebrew.user = users.primary;
        nix-homebrew.taps = {"homebrew/homebrew-cask" = inputs.homebrew-cask;};
        nix-homebrew.mutableTaps = false;
        nix-homebrew.autoMigrate = true;
        homebrew = {
            enable = true;
            onActivation = {
                autoUpdate = true;
                cleanup = "zap";
                upgrade = true;
            };
            taps = builtins.attrNames config.nix-homebrew.taps;
            global = {
                brewfile = true;
                lockfiles = false;
            };
        };
    };
}
