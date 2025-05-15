{
  config,
  pkgs,
  lib,
  zls,
  neovim-nightly-overlay,
  ...
}: {
  # Home Manager configuration for NixOS
  
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "caligula";
  home.homeDirectory = "/home/caligula";
  
  # Configure all programs including home-manager itself
  programs = lib.mkMerge [
    { home-manager.enable = true; }
    (import ../../modules/shared/home-manager.nix {
      inherit config pkgs lib zls neovim-nightly-overlay;
    })
    (import ../../modules/nixos/home-manager.nix {
      inherit config pkgs lib;
    })
  ];
  
  # Packages from shared module
  home.packages = pkgs.callPackage ../../modules/shared/packages.nix { };
  
  # The home.stateVersion should match your NixOS version
  home.stateVersion = "24.11";
}