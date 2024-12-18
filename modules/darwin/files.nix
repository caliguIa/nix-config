{
  user,
  pkgs,
  lib,
  config,
}:
let
  configDir = toString /Users/caligula/nix-config/modules/darwin/config;
in
{
  ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/aerospace";
}
