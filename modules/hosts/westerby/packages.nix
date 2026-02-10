{
    flake.modules.nixos.host_westerby = {pkgs, ...}: let
        widevine-firefox = pkgs.stdenv.mkDerivation {
            name = "widevine-firefox";
            version = pkgs.widevine-cdm.version;

            buildCommand = ''
                mkdir -p $out/gmp-widevinecdm/system-installed
                ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json" $out/gmp-widevinecdm/system-installed/manifest.json
                ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so" $out/gmp-widevinecdm/system-installed/libwidevinecdm.so
            '';

            meta =
                pkgs.widevine-cdm.meta
                // {
                    platforms = ["aarch64-linux"];
                };
        };
    in {

        environment.variables.MOZ_GMP_PATH = ["${widevine-firefox}/gmp-widevinecdm/system-installed"];
        environment.systemPackages = with pkgs; [
            mesa-demos
            vulkan-tools
        ];
    };
}
