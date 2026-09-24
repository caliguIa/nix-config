{
    flake.modules.nixos.gui =
        {
            pkgs,
            lib,
            ...
        }:
        let
            dbx = pkgs.stdenv.mkDerivation (finalAttrs: {
                pname = "dbx";
                version = "0.6.20";

                # The upstream flake builds from source and its vendored hashes drift,
                # so take the prebuilt Tauri bundle from the release instead.
                src = pkgs.fetchurl {
                    url = "https://github.com/t8y2/dbx/releases/download/v${finalAttrs.version}/DBX_${finalAttrs.version}_amd64.deb";
                    hash = "sha256-0HakI5jhko+Hza/IBaxeIARPrU09ZQ4auqjf6l7PqpU=";
                };

                unpackCmd = "dpkg-deb -x $curSrc .";
                sourceRoot = ".";

                nativeBuildInputs = with pkgs; [
                    autoPatchelfHook
                    dpkg
                    makeBinaryWrapper
                ];

                buildInputs = with pkgs; [
                    cairo
                    dbus
                    fontconfig
                    gdk-pixbuf
                    glib
                    gtk3
                    libsoup_3
                    webkitgtk_4_1
                ];

                # The tray icon is dlopen'd rather than linked.
                runtimeDependencies = with pkgs; [
                    libayatana-appindicator
                ];

                installPhase = ''
                    runHook preInstall

                    install -Dm755 usr/bin/dbx $out/bin/dbx
                    cp -r usr/share $out/share

                    runHook postInstall
                '';

                postFixup = ''
                    wrapProgram $out/bin/dbx \
                        --prefix PATH : ${
                            lib.makeBinPath (
                                with pkgs;
                                [
                                    # The JDBC driver agent is a jar and needs a Java 21 runtime;
                                    # dbx only sees the environment it was started with.
                                    jdk21_headless
                                    xdg-utils
                                ]
                            )
                        } \
                        --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
                '';

                meta = {
                    description = "Open-source database management tool";
                    homepage = "https://github.com/t8y2/dbx";
                    license = lib.licenses.asl20;
                    mainProgram = "dbx";
                    platforms = [ "x86_64-linux" ];
                    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
                };
            });
        in
        {
            environment.systemPackages = [
                dbx
            ];
        };
}
