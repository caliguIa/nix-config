{
    inputs,
    lib,
    username,
}: let
    helpers = import ./helpers.nix {inherit lib;};
    config = import ./config.nix {inherit inputs username;};
    system = import ./system.nix {
        inherit inputs username helpers;
        platformConfigs = config.platformConfigs;
    };
in
    helpers
    // config
    // system
