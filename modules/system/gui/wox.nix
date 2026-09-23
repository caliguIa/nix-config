{
    flake.modules.nixos.gui =
        {
            pkgs,
            lib,
            ...
        }:
        let
            wox = pkgs.stdenv.mkDerivation (finalAttrs: {
                pname = "wox";
                version = "2.4.5";

                src = pkgs.fetchurl {
                    url = "https://github.com/Wox-launcher/Wox/releases/download/v${finalAttrs.version}/wox-linux-amd64";
                    hash = "sha256-OWEdeM+KVhsCAFa/hsyK7qS46a0vpwV8mNRVQqzSNqI=";
                };

                icon = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Wox-launcher/Wox/v${finalAttrs.version}/assets/app.png";
                    hash = "sha256-OKJ6YzwVOjIBX/HQJqpVuwScAhQR2zDUgWfHTuNI391=";
                };

                dontUnpack = true;

                nativeBuildInputs = with pkgs; [
                    autoPatchelfHook
                    copyDesktopItems
                    makeBinaryWrapper
                ];

                buildInputs = with pkgs; [
                    atk
                    cairo
                    fontconfig
                    gdk-pixbuf
                    glib
                    gtk3
                    libayatana-appindicator
                    libepoxy
                    libx11
                    libxkbcommon
                    libxrandr
                    libxtst
                    pango
                    wayland
                ];

                # Tray/clipboard integration is dlopen'd rather than linked.
                runtimeDependencies = with pkgs; [
                    libayatana-appindicator
                    libxkbcommon
                    wayland
                ];

                # wox registers its own deeplink handler at runtime and looks itself up
                # by this exact ID, so the desktop entry and icon must not be renamed.
                desktopItems = [
                    (pkgs.makeDesktopItem {
                        name = "io.github.WoxLauncher.Wox";
                        desktopName = "Wox";
                        exec = "wox %U";
                        icon = "io.github.WoxLauncher.Wox";
                        categories = [ "Utility" ];
                        startupWMClass = "wox";
                        mimeTypes = [
                            "x-scheme-handler/wox"
                            "application/x-wox-plugin"
                            "application/x-wox-theme"
                        ];
                        extraConfig."X-KDE-DBUS-Restricted-Interfaces" = "org.kde.KWin.ScreenShot2";
                    })
                ];

                installPhase = ''
                    runHook preInstall

                    install -Dm755 $src $out/bin/wox
                    install -Dm644 $icon \
                        $out/share/icons/hicolor/1024x1024/apps/io.github.WoxLauncher.Wox.png

                    runHook postInstall
                '';

                postFixup = ''
                    wrapProgram $out/bin/wox \
                        --prefix PATH : ${
                            lib.makeBinPath (
                                with pkgs;
                                [
                                    nodejs
                                    python3
                                    desktop-file-utils
                                    xdg-utils
                                    gtk3
                                ]
                            )
                        }
                '';

                meta = {
                    description = "Cross-platform launcher that simply works";
                    homepage = "https://github.com/Wox-launcher/Wox";
                    changelog = "https://github.com/Wox-launcher/Wox/blob/v${finalAttrs.version}/CHANGELOG.md";
                    license = lib.licenses.gpl3Plus;
                    mainProgram = "wox";
                    platforms = [ "x86_64-linux" ];
                    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
                };
            });
        in
        {
            environment.systemPackages = [
                wox
            ];
        };
}
