{ user, config, ... }:

let
  xdgConfigHome = "${config.users.users.${user}.home}/.config";
in
{
  "${xdgConfigHome}/aerospace".source = ./config/aerospace;
}
