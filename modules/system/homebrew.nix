let
    username = "caligula";
in {
    flake.modules.darwin.homebrew = {inputs, ...}: {
        nix-homebrew = {
            enable = true;
            user = username;
            taps = {
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-core" = inputs.homebrew-core;
            };
            mutableTaps = false;
            autoMigrate = true;
        };
    };
}
