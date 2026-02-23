{
    flake.modules.homeManager.desktop = {
        stylix.enableReleaseChecks = false;
        # stylix.targets.console.enable = true;
        stylix.targets.gnome.enable = true;
        stylix.targets.gtk.enable = true;
        stylix.targets.hyprland.enable = true;
        stylix.targets.hyprlock.enable = false;
    };
}
