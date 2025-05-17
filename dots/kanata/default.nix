{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    kanata
  ];

  home.file.".config/kanata" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dots/kanata/files";
      recursive = true;
  };

}
