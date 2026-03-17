{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.packages = with pkgs; [xdg-desktop-portal-gtk];
    };
}
