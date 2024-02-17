{ config, pkgs, lib, home-manager, ... }:

let
  user = "caligula";
  sharedFiles = import ../shared/files.nix { inherit user config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };
}
