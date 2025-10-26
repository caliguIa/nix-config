{
    flake.modules.darwin.desktop = {pkgs, ...}: {
        homebrew.casks = [
            "docker-desktop"
            "ghostty@tip"
            "onyx"
            "tableplus"
        ];
        environment.systemPackages = with pkgs; [slack];
    };
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [];
    };
}
