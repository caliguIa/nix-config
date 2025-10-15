{pkgs, ...}: {
    home.packages = with pkgs; [kanata];
    xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;
}
