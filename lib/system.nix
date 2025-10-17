{
  inputs,
  helpers,
  platformConfigs,
  username,
  self,
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
          (self + /machines/${hostname})
          config.homeManagerModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              users.${username} = self + /user/home.nix;
            };
          }
        ]
        ++ config.extraModules;
    };
}
