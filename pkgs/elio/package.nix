{
    lib,
    stdenv,
    fetchurl,
    autoPatchelfHook,
}:
let
    version = "1.11.2";
    sources = {
        "x86_64-linux" = {
            url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-x86_64-unknown-linux-gnu.tar.gz";
            hash = "sha256-9cW/xUA9p0LEYI3/j4MGPVZvcyJpV1JYKYBuHur4sTM=";
        };
        "aarch64-linux" = {
            url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-aarch64-unknown-linux-gnu.tar.gz";
            hash = "sha256-zg141Dp+jHwAqzoaCNvOoC7ZFeAX+cO8HZF5W7wz1Qs=";
        };
    };
    source =
        sources.${stdenv.hostPlatform.system}
            or (throw "elio: unsupported platform ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
    pname = "elio";
    inherit version;

    src = fetchurl { inherit (source) url hash; };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ stdenv.cc.cc.lib ];

    installPhase = ''
        runHook preInstall

        install -Dm755 elio -t $out/bin

        for size in 48 128 256 512; do
            install -Dm644 \
                "packaging/linux/icons/hicolor/''${size}x''${size}/apps/elio.png" \
                "$out/share/icons/hicolor/''${size}x''${size}/apps/elio.png"
        done
        install -Dm644 packaging/linux/elio.desktop -t $out/share/applications

        runHook postInstall
    '';

    meta = {
        description = "Terminal file manager";
        homepage = "https://github.com/elio-fm/elio";
        license = lib.licenses.mit;
        mainProgram = "elio";
        platforms = builtins.attrNames sources;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
}
