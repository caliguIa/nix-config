{
    inputs,
    lib,
    username,
    self,
}: let
    helpers = import ./helpers.nix {inherit lib;};
    config = import ./config.nix {inherit inputs username self;};
    system = import ./system.nix {
        inherit inputs username helpers self;
        platformConfigs = config.platformConfigs;
    };
in
    helpers
    // config
    // system
