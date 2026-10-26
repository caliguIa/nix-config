{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
            zmx-go = pkgs.writeShellApplication {
                name = "zmx-go";
                runtimeInputs = [
                    pkgs.coreutils
                    pkgs.findutils
                    pkgs.gawk
                    pkgs.gnugrep
                    pkgs.gnused
                    pkgs.jq
                    pkgs.fzf
                    pkgs.git
                    pkgs.ghostty
                    pkgs.sway
                    pkgs.zmx
                ];
                text = builtins.readFile ./zmx-go.sh;
            };
        in
        {
            environment.systemPackages = [
                pkgs.zmx
                zmx-go
            ];
        };

    flake.modules.hjem.gui.xdg.config.files."sway/config.d/zmx.conf".text = ''
        # Every terminal window is a zmx session; detach with ctrl+\.
        bindsym $mod+Return exec zmx-go open
        bindsym $mod+o exec ghostty --class=zmx.picker -e zmx-go sessions
        bindsym $mod+p exec ghostty --class=zmx.picker -e zmx-go projects
        for_window [app_id="zmx.picker"] floating enable, resize set width 70 ppt height 60 ppt, move position center
    '';
}
