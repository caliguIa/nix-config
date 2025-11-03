{
    flake.modules.nixos.system-desktop-glide = {pkgs, ...}: let
        wrapGlide = {nativeMessagingHosts ? []}: let
            allNativeMessagingHosts = map pkgs.lib.getBin nativeMessagingHosts;
        in
            glide-browser.overrideAttrs (oldAttrs: {
                postFixup =
                    (oldAttrs.postFixup or "")
                    + ''
                        # Link native messaging hosts
                        for ext in ${toString allNativeMessagingHosts}; do
                          ln -sLt $out/lib/mozilla/native-messaging-hosts $ext/lib/mozilla/native-messaging-hosts/*
                        done
                    '';
            });
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
            passthru = {
                nativeMessagingHosts = [];
            };
            nativeBuildInputs = [
                pkgs.wrapGAppsHook3
                pkgs.autoPatchelfHook
                pkgs.patchelfUnstable
            ];
            buildInputs = with pkgs; [
                gtk3
                adwaita-icon-theme
                alsa-lib
                dbus-glib
                xorg.libXtst
                libdrm
                libGL
                mesa
                libglvnd
                xorg.libX11
                xorg.libxcb
                xorg.libXcomposite
                xorg.libXcursor
                xorg.libXdamage
                xorg.libXext
                xorg.libXfixes
                xorg.libXi
                xorg.libXrandr
                xorg.libxshmfence
                cairo
                pango
                gdk-pixbuf
                atk
                glib
            ];
            runtimeDependencies = with pkgs; [
                curl
                pciutils
                libva.out
            ];
            appendRunpaths = [
                "${pkgs.pipewire}/lib"
                "${pkgs.libglvnd}/lib"
                "${pkgs.mesa}/lib"
            ];
            patchelfFlags = ["--no-clobber-old-sections"];
            sourceRoot = ".";
            installPhase = ''
                mkdir -p $out/lib/glide-browser-${version}
                cp -r glide/* $out/lib/glide-browser-${version}/
                mkdir -p $out/bin
                ln -s $out/lib/glide-browser-${version}/glide $out/bin/glide
                ln -s $out/bin/glide $out/bin/glide-browser
                # Create native messaging hosts directory
                mkdir -p $out/lib/mozilla/native-messaging-hosts
            '';
            preFixup = ''
                gappsWrapperArgs+=(
                  --set MOZ_LEGACY_PROFILES 1
                  --set MOZ_ALLOW_DOWNGRADE 1
                  --set-default MOZ_ENABLE_WAYLAND 1
                  --set MOZ_SYSTEM_DIR "$out/lib/mozilla"
                )
            '';
            meta = {
                description = "Glide Browser";
                homepage = "https://github.com/glide-browser/glide";
                platforms = ["x86_64-linux" "aarch64-linux"];
                mainProgram = "glide";
            };
        };
        glide-with-hosts = wrapGlide {
            nativeMessagingHosts = with pkgs; [
                firefoxpwa
                # Add other native messaging hosts here
            ];
        };
    in {environment.systemPackages = [glide-with-hosts];};
}
