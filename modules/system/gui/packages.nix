{ ... }: {
    flake.modules.nixos.gui = { pkgs, ... }: {
        services.dbus.enable = true;
        services.mullvad-vpn.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
                zlib
                zstd
                stdenv.cc.cc
                curl
                openssl
                attr
                libssh
                bzip2
                libxml2
                acl
                libsodium
                util-linux
                xz
                systemd

                kdePackages.qtbase
                libXcomposite
                libXtst
                libXrandr
                libXext
                libX11
                libXfixes
                libGL
                libva
                pipewire
                libxcb
                libXdamage
                libxshmfence
                libXxf86vm
                libelf

                # glibc_multi.bin
                #
                # networkmanager
                # vulkan-loader
                # libgbm
                # libdrm
                # libxcrypt
                # coreutils
                # pciutils
                # zenity
                #
                # # Required
                # glib
                # gtk2
                #
                # freetype
                # fontconfig
                # xorg.libX11
                # xorg.libXrandr
                # xorg.libXcursor
                # xorg.libXi
                # libGL
            ];
        };
        programs.localsend.enable = true;
        programs.firefox = {
            enable = true;
            package = pkgs.firefox-devedition;
        };
        services.tlp.enable = false;
        services.power-profiles-daemon.enable = true;
        environment.sessionVariables = {
            OPENCODE_EXPERIMENTAL_OXFMT = "true";
            MOZ_DISABLE_RDD_SANDBOX = "1";
        };
        environment.systemPackages = with pkgs; [
            bitwarden-cli
            bitwarden-desktop
            bruno
            claude-code
            epiphany
            luakit
            gelly
            glib.bin
            mullvad
            mullvad-vpn
            opencode
            poppler
            resvg
            slack
            spotify
            tableplus
            ungoogled-chromium
        ];
    };
}
