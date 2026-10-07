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
                # capSysNice adds a setcap wrapper at /run/wrappers/bin/gamescope, which is the
                # ONLY gamescope on PATH when enabled. Steam launches games inside an FHS
                # sandbox with NoNewPrivs=1, where that wrapper aborts with "failed to inherit
                # capabilities" - so any launch option containing gamescope silently fails.
                capSysNice = false;
            };
            # VK_LAYER_FROG_gamescope_wsi. The gamescope package ships no Vulkan layer, so
            # DXVK inside gamescope cannot see HDR-capable surface formats without it.
            # Must land in /run/opengl-driver so the loader finds it inside Steam/Proton.
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
