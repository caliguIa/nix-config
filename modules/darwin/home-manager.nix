{
  pkgs,
  zls,
  neovim-nightly-overlay,
  ...
}:

let
  user = "caligula";
in
{
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            (import ../shared/files.nix {
              inherit user pkgs lib;
              config = config;
            })
            (import ./files.nix {
              inherit user pkgs lib;
              config = config;
            })
          ];
          stateVersion = "23.11";
        };
        programs =
          { }
          // import ../shared/home-manager.nix {
            inherit
              config
              pkgs
              lib
              zls
              neovim-nightly-overlay
              ;
          };
      };
  };
}
