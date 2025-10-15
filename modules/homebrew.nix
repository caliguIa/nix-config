{
    inputs,
    username,
}: {
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
}
