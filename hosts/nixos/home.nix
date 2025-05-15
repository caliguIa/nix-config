{
  config,
  pkgs,
  lib,
  zls,
  neovim-nightly-overlay,
  ...
}: {
  # Home Manager configuration for NixOS
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "caligula";
  home.homeDirectory = "/home/caligula";
  
  # Import the core shared programs
  programs = import ../../modules/shared/home-manager.nix {
    inherit config pkgs lib zls neovim-nightly-overlay;
  };
  
  # Packages from shared module
  home.packages = pkgs.callPackage ../../modules/shared/packages.nix { };
  
  # The home.stateVersion should match your NixOS version
  home.stateVersion = "24.11";
}