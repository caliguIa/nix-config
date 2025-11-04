{
    flake.modules.nixos.system-desktop-glide = {pkgs, ...}: let
        glide-browser = pkgs.stdenv.mkDerivation rec {
            pname = "glide-browser";
            version = "0.1.53a";
            src = let
                sources = {
                    "x86_64-linux" = pkgs.fetchurl {
                        url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-x86_64.tar.xz";
                        sha256 = "1r8rnbgwhdqm639m5xixpw7b6v55rgjawjia5xp57g0pgyv243vr";
                    };
                    "aarch64-linux" = pkgs.fetchurl {
                        url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-aarch64.tar.xz";
                        sha256 = "sha256-F62mhBRKlNcNKLHBfO9cWSBH0QxvnD1sxEnOH3oLL8E=";
                    };
                };
            in
                sources.${pkgs.system};
            nativeBuildInputs = with pkgs; [
                wrapGAppsHook3
                autoPatchelfHook
                patchelfUnstable
            ];
            buildInputs = with pkgs; [
                gtk3
                adwaita-icon-theme
                gdk-pixbuf
                cairo
                pango
                atk
                glib
                libcanberra-gtk3
                xorg.libX11
                xorg.libxcb
                xorg.libXScrnSaver
                xorg.libXcomposite
                xorg.libXcursor
                xorg.libXdamage
                xorg.libXext
                xorg.libXfixes
                xorg.libXi
                xorg.libXrandr
                xorg.libXtst
                xorg.libxshmfence
                xorg.libXxf86dga
                xorg.libXxf86vm
                xorg.libXt
                libdrm
                libGL
                mesa
                libglvnd
                vulkan-loader
                alsa-lib
                pipewire
                ffmpeg
                libfido2
                libu2f-host
                libusb-compat-0_1
                opensc
                pam_u2f
                yubico-pam
                pcsc-tools
                dbus-glib
                cups
                stdenv.cc
                zlib
                speechd-minimal
                libkrb5
                desktop-file-utils
            ];
            runtimeDependencies = with pkgs;
                [
                    curl
                    pciutils
                    libva.out
                    libnotify
                    udev
                    libgbm
                ]
                ++ buildInputs;
            appendRunpaths = with pkgs; [
                "${pipewire}/lib"
                "${libglvnd}/lib"
                "${mesa}/lib"
            ];
            patchelfFlags = ["--no-clobber-old-sections"];
            sourceRoot = ".";
            installPhase = ''
                mkdir -p $out/lib/glide-browser-${version}
                cp -r glide/* $out/lib/glide-browser-${version}/
                mkdir -p $out/bin
                ln -s $out/lib/glide-browser-${version}/glide $out/bin/glide
                ln -s $out/bin/glide $out/bin/glide-browser
            '';
            preFixup = ''
                gappsWrapperArgs+=(
                  --set MOZ_LEGACY_PROFILES 1
                  --set MOZ_ALLOW_DOWNGRADE 1
                  --set-default MOZ_ENABLE_WAYLAND 1
                  --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath runtimeDependencies}"
                )
            '';
            meta = {
                description = "Glide Browser";
                homepage = "https://github.com/glide-browser/glide";
                platforms = ["x86_64-linux" "aarch64-linux"];
                mainProgram = "glide";
            };
        };
    in {
        environment.systemPackages = [glide-browser];
        environment.etc."1password/custom_allowed_browsers" = {
            text = ''
                glide
                glide-browser
            '';
            mode = "0755";
        };
        services.udev.packages = with pkgs; [
            yubikey-personalization
            libu2f-host
        ];
        services.pcscd.enable = true;
        xdg.mime = {
            enable = true;
            addedAssociations = {
                "application/pdf" = "glide.desktop";
                "text/xml" = [
                    "nvim.desktop"
                    "glide.desktop"
                ];
                "text/html" = [
                    "glide.desktop"
                    "nvim.desktop"
                ];
            };
            defaultApplications = {
                "x-scheme-handler/http" = "glide.desktop";
                "x-scheme-handler/https" = "glide.desktop";
                "x-scheme-handler/about" = "glide.desktop";
                "x-scheme-handler/unknown" = "glide.desktop";
                "text/html" = "glide.desktop";
                "text/xml" = "glide.desktop";
                "text/plain" = "glide.desktop";
                "text/css" = "glide.desktop";
                "text/csv" = "glide.desktop";
                "text/javascript" = "glide.desktop";
                "application/xhtml+xml" = "glide.desktop";
                "application/pdf" = "glide.desktop";
                "image/png" = "oculante.desktop";
                "image/jpeg" = "oculante.desktop";
                "image/avif" = "oculante.desktop";
                "image/tiff" = "oculante.desktop";
                "image/svg+xml" = "oculante.desktop";
            };
        };
    };
}
