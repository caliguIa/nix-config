{
  inputs,
  helpers,
  platformConfigs,
  username,
}: {
  mkSystem = {
    system,
    hostname,
  }: let
    config =
      platformConfigs.${
        if helpers.isDarwin system
        then "darwin"
        else "nixos"
      };
    specialArgs = {
      inherit inputs system hostname username;
      homeDirectory = helpers.mkHomeDirectory username system;
    };
  in
    config.builder {
      inherit system;
      specialArgs = specialArgs;
      modules =
        [
          ../machines/${hostname}
          config.homeManagerModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              users.${username} = ../user/home.nix;
            };
          }
        ]
        ++ config.extraModules;
    };
}
