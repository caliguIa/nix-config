{
    flake.modules.nixos.system-desktop-clipboard = {pkgs, ...}: let
        clipvault = let
            version = "1.0.6";
        in
            pkgs.stdenvNoCC.mkDerivation {
                pname = "clipvault";
                version = version;
                src = pkgs.fetchurl {
                    url = "https://github.com/Rolv-Apneseth/clipvault/releases/download/v${version}/clipvault-${pkgs.stdenvNoCC.hostPlatform.parsed.cpu.name}-unknown-linux-gnu.tar.gz";
                    sha256 = "sha256-30cPuSyOJijOBNsJ0suJAK1/DWYIs7BGIJ+/uBWNue8=";
                };
                nativeBuildInputs = [pkgs.autoPatchelfHook pkgs.patchelf];
                buildInputs = [pkgs.stdenv.cc.cc.lib];
                dontConfigure = true;
                dontBuild = true;
                unpackPhase = "tar -xzf $src";
                installPhase = ''
                    mkdir -p $out/bin
                    install -m755 clipvault $out/bin/clipvault
                '';
                meta.platforms = ["aarch64-linux" "x86_64-linux"];
            };
        kickoff-clipvault = pkgs.writeShellScriptBin "kickoff-clipvault" ''
            ${clipvault}/bin/clipvault list \
            | ${pkgs.kickoff}/bin/kickoff --from-stdin --stdout \
            | ${pkgs.gawk}/bin/awk '{print $1}' \
            | ${clipvault}/bin/clipvault get \
            | ${pkgs.wl-clipboard}/bin/wl-copy
        '';
    in {
        environment.systemPackages = with pkgs; [
            wl-clipboard
            clipvault
            kickoff-clipvault
        ];
    };
}
