{
    lib,
    flake-parts-lib,
    ...
}: {
    options = {
        flake = flake-parts-lib.mkSubmoduleOptions {
            homeConfigurations = lib.mkOption {
                type = with lib.types; lazyAttrsOf raw;
                default = {};
            };
        };
    };
}
