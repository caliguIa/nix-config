{lib, config, ...}: let
    platformType = lib.types.lazyAttrsOf lib.types.deferredModule;
in {
    options.flake.modules = lib.mkOption {
        type = lib.types.submodule {
            freeformType = lib.types.lazyAttrsOf platformType;
            options = {
                darwin = lib.mkOption {
                    type = platformType;
                    default = {};
                };
                nixos = lib.mkOption {
                    type = platformType;
                    default = {};
                };
                homeManager = lib.mkOption {
                    type = platformType;
                    default = {};
                };
            };
        };
        default = {};
        description = "Modules organized by platform (darwin, nixos, homeManager)";
    };
}
