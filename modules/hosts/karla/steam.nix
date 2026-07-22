{user, ...}: {
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        services.xserver.videoDrivers = ["amdgpu"];

        # Mesa RADV is the recommended Vulkan driver for AMD gaming.
        # enable32Bit is already on via nixos-hardware; add vaapi + tools.
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
            # Proton-GE, managed declaratively. Coexists with the manual
            # protonup-rs compat tools dir below.
            extraCompatPackages = with pkgs; [proton-ge-bin];
        };

        # Run individual games in gamescope for FSR upscaling (big win on the
        # 780M iGPU). capSysNice lets gamescope raise scheduling priority.
        # Example launch option: gamescope -W 1920 -H 1080 -U -f -- %command%
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

        # Force the Mesa RADV Vulkan ICD (over any amdvlk that sneaks in).
        # RADV_PERFTEST enables extra optimisations; drop if a game misbehaves.
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
