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
                    "x86_64-darwin" = pkgs.fetchurl {
                        url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.macos-x86_64.dmg";
                        sha256 = "15iqc2x0d40s1kjvc0qzkyfgg6vfzbpg0y92r9asbxl2sjmwcc1w";
                    };
                    "aarch64-darwin" = pkgs.fetchurl {
                        url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.macos-aarch64.dmg";
                        sha256 = "1sq6j5siss02m2pg9hv4ahqfrl76xm8w2idbpw75p4vzl2a72yns";
                    };
                };
            in
                sources.${pkgs.system};
            sourceRoot = ".";
            installPhase = ''
                mkdir -p $out/bin $out/lib/glide
                cp -r glide/* $out/lib/glide/
                chmod +x $out/lib/glide/glide

                cat > $out/bin/glide <<EOF
                #!/bin/sh
                cd $out/lib/glide
                exec $out/lib/glide/glide "\$@"
                EOF
                chmod +x $out/bin/glide

                cat > $out/bin/glide-browser <<EOF
                #!/bin/sh
                cd $out/lib/glide
                exec $out/lib/glide/glide "\$@"
                EOF
                chmod +x $out/bin/glide-browser
            '';
            meta = {
                description = "Glide Browser (Firefox-based)";
                homepage = "https://github.com/glide-browser/glide";
                platforms = ["x86_64-linux" "aarch64-linux"];
            };
        };
    in {
        environment.systemPackages = [glide-browser];
        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = with pkgs; [
            alsa-lib
            atk
            cairo
            gdk-pixbuf
            glib
            gtk3
            libdrm
            libGL
            mesa
            pango
            pciutils
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

            # gtk2
            # dbus
            # dbus-glib
            # libxkbcommon
            # wayland
            # libpulseaudio
            # nspr
            # nss
            # fontconfig
            # freetype
            # at-spi2-atk
            # at-spi2-core
            # cups
            # expat
            # stdenv.cc.cc.lib
            # zlib
        ];
    };
}
