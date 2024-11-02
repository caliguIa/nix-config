{ user, config, ... }:

let
  xdgConfigHome = "${config.users.users.${user}.home}/.config";
in
{
  "${xdgConfigHome}/karabiner".source = ./config/karabiner;
  "${xdgConfigHome}/aerospace".source = ./config/aerospace;
}
