{ user, ... }: {
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.steam = {
                enable = true;
                gamescopeSession.enable = true;
                extraCompatPackages = with pkgs; [ proton-ge-bin ];
                package = pkgs.steam.override { extraArgs = "--pipewire"; };
                remotePlay.openFirewall = true;
            };
            programs.gamescope = {
                enable = true;
                capSysNice = false;
            };
            hardware.graphics.extraPackages = [ pkgs.gamescope-wsi ];
            hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.gamescope-wsi ];

            programs.gamemode = {
                enable = true;
                settings = {
                    general = {
                        renice = 10;
                    };
                };
            };

            environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${user.primary}/.steam/root/compatibilitytools.d";
            environment.systemPackages = [
                pkgs.mangohud
                pkgs.vulkan-tools
                pkgs.mesa-demos
                pkgs.libva-utils
            ];
        };
}
