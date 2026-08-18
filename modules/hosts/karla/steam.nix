{ user, inputs, ... }: {
    flake.modules.nixos.host_karla = { pkgs, ... }: let
        # Mesa 26.1.6 from a pinned nixpkgs, to dodge the 26.2.0 radeonsi
        # VAAPI green-box decode regression on the Radeon 780M. Remove the
        # nixpkgs-mesa input and this override once upstream Mesa is fixed.
        mesaPin = inputs.nixpkgs-mesa.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;
    in {
        services.xserver.videoDrivers = [ "amdgpu" ];

        hardware.graphics = {
            enable = true;
            enable32Bit = true;
            package = mesaPin;
            package32 = inputs.nixpkgs-mesa.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa;
            extraPackages = with pkgs; [
                libva
            ];
        };

        programs.steam = {
            enable = true;
            gamescopeSession.enable = true;
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
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
            libva-utils # vainfo, for verifying HW video accel
        ];
    };
}
