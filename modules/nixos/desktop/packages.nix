{
    flake.modules.darwin.desktop = {pkgs, ...}: {
        homebrew.casks = [
            "docker-desktop"
            "losslessswitcher"
            "ghostty"
            "onyx"
            "sabnzbd"
            "slack"
            "tableplus"
        ];
        environment.systemPackages = with pkgs; [];
    };
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [];
    };
}
