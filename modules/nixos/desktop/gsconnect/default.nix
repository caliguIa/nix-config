{
    flake.modules.nixos.desktop = {pkgs, ...}: let
        gsconnect = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "gnome-shell-extension-gsconnect";
            version = "72";

            outputs = [
                "out"
                "installedTests"
            ];

            src = pkgs.fetchFromGitHub {
                owner = "GSConnect";
                repo = "gnome-shell-extension-gsconnect";
                rev = "v${finalAttrs.version}";
                hash = "sha256-w9MQVEUQUcO1lqftBi76w5xSTlryKuZJxE6Ogg1J+ho=";
            };

            patches = [
                (pkgs.replaceVars ./fix-paths.patch {
                    gapplication = "${pkgs.glib.bin}/bin/gapplication";
                    # Replaced in postPatch
                    typelibPath = null;
                })
                ./installed-tests-path.patch
            ];

            nativeBuildInputs = with pkgs; [
                meson
                ninja
                pkg-config
                gobject-introspection
                wrapGAppsHook3
                desktop-file-utils
            ];

            buildInputs = with pkgs; [
                glib
                glib-networking
                gtk3
                gsound
                gjs
                evolution-data-server-gtk4
            ];

            mesonFlags = [
                (pkgs.lib.mesonOption "gnome_shell_libdir" "${pkgs.gnome-shell}/lib")
                (pkgs.lib.mesonOption "chrome_nmhdir" "${placeholder "out"}/etc/opt/chrome/native-messaging-hosts")
                (pkgs.lib.mesonOption "chromium_nmhdir" "${placeholder "out"}/etc/chromium/native-messaging-hosts")
                (pkgs.lib.mesonOption "openssl_path" "${pkgs.openssl}/bin/openssl")
                (pkgs.lib.mesonOption "sshadd_path" "${pkgs.openssh}/bin/ssh-add")
                (pkgs.lib.mesonOption "sshkeygen_path" "${pkgs.openssh}/bin/ssh-keygen")
                (pkgs.lib.mesonOption "session_bus_services_dir" "${placeholder "out"}/share/dbus-1/services")
                (pkgs.lib.mesonOption "installed_test_prefix" "${placeholder "installedTests"}")
            ];

            postPatch = ''
                patchShebangs installed-tests/prepare-tests.sh

                substituteInPlace src/__nix-prepend-search-paths.js \
                    --subst-var-by typelibPath "$GI_TYPELIB_PATH"

                substituteInPlace data/config.js.in \
                    --subst-var-by GSETTINGS_SCHEMA_DIR \
                        ${pkgs.glib.makeSchemaPath (placeholder "out") "${finalAttrs.pname}-${finalAttrs.version}"}
            '';

            postFixup = ''
                for file in $out/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/service/{daemon,nativeMessagingHost}.js; do
                    echo "Wrapping program $file"
                    wrapGApp "$file"
                done

                for file in $installedTests/libexec/installed-tests/gsconnect/minijasmine; do
                    echo "Wrapping program $file"
                    wrapGApp "$file"
                done
            '';

            passthru = {
                extensionUuid = "gsconnect@andyholmes.github.io";
                extensionPortalSlug = "gsconnect";
            };

            meta = with pkgs.lib; {
                description = "KDE Connect implementation for Gnome Shell";
                homepage = "https://github.com/GSConnect/gnome-shell-extension-gsconnect/wiki";
                license = licenses.gpl2Plus;
                platforms = platforms.linux;
            };
        });
    in {
        environment.systemPackages = [gsconnect];
    };
}
