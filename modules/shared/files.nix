{
  user,
  pkgs,
  lib,
  config,
}:
let
  configDir = toString /Users/caligula/nix-config/modules/shared/config;
in
{
  ".hushlogin".text = "";
  ".config/kanata".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/kanata";
  ".config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/wezterm";
    recursive = true;
  };
}
