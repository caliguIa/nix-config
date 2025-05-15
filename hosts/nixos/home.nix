{
  config,
  pkgs,
  lib,
  neovim-nightly-overlay,
  ...
}:
let
  user = "caligula";
in
{
  # Home Manager configuration for NixOS

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "caligula";
  home.homeDirectory = "/home/caligula";

  # Configure all programs including home-manager itself
  programs = lib.mkMerge [
    { home-manager.enable = true; }
    { zsh.enable = true; }
    (import ../../modules/shared/home-manager.nix {
      inherit
        config
        pkgs
        lib
        neovim-nightly-overlay
        ;
    })
    (import ../../modules/nixos/home-manager.nix {
      inherit config pkgs lib;
    })
  ];

  # Packages from shared module
  home.packages = pkgs.callPackage ../../modules/shared/packages.nix { };
  home.file = lib.mkMerge [
    (import ../../modules/shared/files.nix {
      inherit user pkgs lib;
      config = config;
    })
  ];

  # The home.stateVersion should match your NixOS version
  home.stateVersion = "24.11";
}
