{
  user,
  pkgs,
  lib,
  config,
}:
let
  modules = "${config.home.homeDirectory}/nix-config/modules/shared";
  configDir = "${modules}/config";
  binDir = "${modules}/bin";
in
{
  ".local/bin/tmux-cmd-launcher.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${binDir}/tmux-cmd-launcher.sh";
  ".local/bin/csv-sql-fmt.sh".source = config.lib.file.mkOutOfStoreSymlink "${binDir}/csv-sql-fmt.sh";
  ".hushlogin".text = "";
  ".config/kanata".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/kanata";
  ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/zellij";
  ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux";
  ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ghostty";
  ".config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/wezterm";
    recursive = true;
  };
  ".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nvim";
    recursive = true;
  };
}
