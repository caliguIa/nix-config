{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.packages = with pkgs; [xdg-desktop-portal-gtk];
        # xdg.portal = {
        #     enable = true;
        #     config = {
        #         hyprland = {
        #             default = ["hyprland" "gtk"];
        #             "org.freedesktop.impl.portal.FileChooser" = "gtk";
        #             "org.freedesktop.portal.FileChooser" = "gtk";
        #         };
        #     };
        # };
    };
}
