{
    flake.modules.darwin.system-desktop-packages = {pkgs, ...}: {
        homebrew.casks = [
            "docker-desktop"
            "ghostty@tip"
            "onyx"
            "tableplus"
        ];
        environment.systemPackages = with pkgs; [
            slack
        ];
    };

    flake.modules.nixos.system-desktop-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
        ];
    };
}
