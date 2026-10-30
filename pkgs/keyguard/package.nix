# Repackaged upstream release; nixpkgs' from-source keyguard is stuck at 2.3.4.
{
    lib,
    stdenv,
    fetchurl,
    autoPatchelfHook,
    alsa-lib,
    cups,
    file,
    fontconfig,
    freetype,
    glib,
    gtk3,
    lcms2,
    libglvnd,
    libx11,
    libxext,
    libxi,
    libxinerama,
    libxrandr,
    libxrender,
    libxtst,
    systemdLibs,
    wayland,
    zlib,
}:

stdenv.mkDerivation (finalAttrs: {
    pname = "keyguard";
    version = "3.3.0";
    tag = "r20261012.2";

    src =
        let
            arch = stdenv.hostPlatform.parsed.cpu.name;
        in
        fetchurl {
            url = "https://github.com/AChep/keyguard-app/releases/download/${finalAttrs.tag}/Keyguard-${finalAttrs.version}-linux-${arch}.tar.gz";
            hash =
                {
                    x86_64 = "sha256-j5QcDJUPk1SzpxyNHBMFt6oWe9MYZClYS/ZpLlkg28g=";
                    aarch64 = "sha256-aXVviIZce70UYpCKUwQTnEJgj1VT/1UXMA3UgG+akOc=";
                }
                .${arch};
        };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
        alsa-lib
        cups
        file
        fontconfig
        freetype
        glib
        gtk3
        lcms2
        libglvnd
        libx11
        libxext
        libxi
        libxinerama
        libxrandr
        libxrender
        libxtst
        stdenv.cc.cc.lib
        systemdLibs
        wayland
        zlib
    ];

    # dlopen'd by the JVM / skiko rather than linked
    runtimeDependencies = [
        glib
        gtk3
        libglvnd
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
        runHook preInstall

        cp --recursive . $out
        install -D --mode=0644 $out/lib/Keyguard.png $out/share/icons/hicolor/512x512/apps/com.artemchep.keyguard.png

        runHook postInstall
    '';

    meta = {
        description = "Alternative client for the Bitwarden platform, created to provide the best user experience possible";
        homepage = "https://github.com/AChep/keyguard-app";
        mainProgram = "Keyguard";
        license = lib.licenses.unfree;
        sourceProvenance = with lib.sourceTypes; [
            binaryNativeCode
            binaryBytecode
        ];
        platforms = [
            "x86_64-linux"
            "aarch64-linux"
        ];
    };
})
