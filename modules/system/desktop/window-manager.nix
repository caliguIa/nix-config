{
    flake.modules.nixos.desktop = { pkgs, lib, ... }: {
        services.desktopManager.plasma6.enable = true;

        # KDE Connect (replaces the gsconnect GNOME extension). Opens the
        # required firewall port ranges for phone pairing/transfer.
        programs.kdeconnect.enable = true;

        # Trim the default Plasma app bundle down to a minimal set. Klipper
        # (clipboard) and the system tray are built into Plasma, so the
        # clipboard-indicator / appindicator extensions have native equivalents
        # and need nothing here. Dolphin and kwalletmanager are kept.
        environment.plasma6.excludePackages = with pkgs.kdePackages; [
            elisa                        # music player (was: gnome-music)
            khelpcenter                  # help viewer (was: yelp/gnome-user-docs)
            konsole                      # terminal (ghostty is used instead)
            plasma-browser-integration   # (was: gnome-browser-connector, disabled)
            kate                         # editor (nvim is used instead)
            plasma-systemmonitor
        ];

        environment.systemPackages = with pkgs.kdePackages; [
            # Minimal PIM stack for CalDAV (Fastmail) + Google (Gmail) calendar
            # event desktop notifications. akonadi + kdepim-runtime come from
            # programs.kde-pim.enable (default on); these two add the reminder
            # daemon and the Digital Clock event source respectively.
            akonadi-calendar   # provides kalendarac: fires calendar reminders
            kdepim-addons      # provides pimevents.so: events in the Digital Clock
            merkuro            # GUI to add the CalDAV/Google calendar accounts
        ];

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = [
            "/share/xdg-desktop-portal"
            "/share/applications"
        ];
    };
}
