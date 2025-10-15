{pkgs, ...}: {
    home.packages = [pkgs.kanata];
    xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;
}
