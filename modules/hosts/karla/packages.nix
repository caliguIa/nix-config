{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            spotify
            (slack.overrideAttrs (old: {
                postInstall = (old.postInstall or "") + ''
                    substituteInPlace $out/share/applications/slack.desktop \
                        --replace-fail "-s %U" "--ozone-platform=wayland --ozone-platform-hint=wayland -s %U"
                '';
            }))
            google-chrome
            unzip
        ];
    };
}
