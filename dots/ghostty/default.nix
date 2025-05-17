{ config, ... }:
{
  home.file.".config/ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dots/ghostty/files";
    recursive = true;
  };
}
