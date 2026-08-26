{ user, ... }: {
    flake.modules.nixos.host_karla =
        { pkgs, ... }:
        {
            services.xserver.videoDrivers = [ "amdgpu" ];

            hardware.graphics = {
                enable = true;
                enable32Bit = true;
                extraPackages = with pkgs; [ libva ];
            };

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

            environment.sessionVariables = {
                AMD_VULKAN_ICD = "RADV";
                RADV_PERFTEST = "gpl,sam";
                LIBVA_DRIVER_NAME = "radeonsi";
                STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${user.primary}/.steam/root/compatibilitytools.d";
            };

            environment.systemPackages = with pkgs; [
                mangohud
                vulkan-tools
                mesa-demos
                libva-utils
            ];
        };
}
