{user, ...}: {
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        services.xserver.videoDrivers = ["amdgpu"];

        hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
                libva
                libvdpau-va-gl
                libva-vdpau-driver
            ];
        };

        programs.steam = {
            enable = true;
            gamescopeSession.enable = true;
            extraCompatPackages = with pkgs; [proton-ge-bin];
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
            STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${user.primary}/.steam/root/compatibilitytools.d";
        };

        environment.systemPackages = with pkgs; [
            mangohud
            vulkan-tools
            mesa-demos
        ];
    };
}
