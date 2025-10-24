let
    username = "caligula";
in {
    flake.modules.darwin.home-manager = {inputs, ...}: {
        imports = [inputs.home-manager.darwinModules.home-manager];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
        };
    };
    flake.modules.nixos.home-manager = {inputs, ...}: {
        imports = [inputs.home-manager.nixosModules.home-manager];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
        };
    };
}
