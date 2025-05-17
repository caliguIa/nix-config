{ config, ... }:
{
  home.file.".config/aerospace" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dots/aerospace/files";
    recursive = true;
  };
}
