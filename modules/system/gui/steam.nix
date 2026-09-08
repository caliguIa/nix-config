{ user, ... }: {
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.steam = {
                enable = true;
                gamescopeSession.enable = true;
                extraCompatPackages = with pkgs; [ proton-ge-bin ];
                package = pkgs.steam.override {
                    steam-unwrapped = pkgs.steam-unwrapped.overrideAttrs (old: {
                        postInstall = (old.postInstall or "") + ''
                            substituteInPlace $out/share/applications/steam.desktop \
                                --replace-fail "Exec=steam %U" "Exec=steam --pipewire %U"
                        '';
                    });
                };
            };
            programs.gamescope = {
                enable = true;
                capSysNice = true;
            };
            programs.gamemode = {
                enable = true;
                settings = {
                    general = {
                        renice = 10;
                    };
                    gpu = {
                        apply_gpu_optimisations = "accept-responsibility";
                        gpu_device = 0;
                        amd_performance_level = "high";
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
