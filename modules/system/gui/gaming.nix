{ user, ... }: {
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.steam = {
                enable = true;
                gamescopeSession.enable = true;
                extraCompatPackages = with pkgs; [ proton-ge-bin ];
                package = pkgs.steam.override { extraArgs = "--pipewire"; };
            };
            programs.gamescope = {
                enable = true;
                enableWsi = true;
                capSysNice = false;
            };
            programs.gamemode = {
                enable = true;
                settings.general.renice = 10;
            };
            # gamemode's governor/GPU helpers are polkit-limited to this group.
            users.users.${user.primary}.extraGroups = [ "gamemode" ];
            environment.systemPackages = [
                pkgs.mangohud
                pkgs.vulkan-tools
                pkgs.mesa-demos
                pkgs.libva-utils
                pkgs.moonlight-qt
            ];
        };
}
