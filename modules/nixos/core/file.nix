{
    flake.modules.darwin.core = {
        system = {
            defaults = {
                NSGlobalDomain = {
                    AppleShowAllExtensions = true;
                    AppleInterfaceStyle = "Dark";
                    AppleShowAllFiles = true;
                    AppleShowScrollBars = "WhenScrolling";
                    AppleWindowTabbingMode = "always";
                    NSAutomaticWindowAnimationsEnabled = false;
                    NSNavPanelExpandedStateForSaveMode = true;
                    NSTableViewDefaultSizeMode = 1;
                };
                dock = {
                    orientation = "bottom";
                    autohide-delay = 5.0;
                    autohide = true;
                    launchanim = false;
                    mru-spaces = false;
                    show-recents = false;
                    static-only = true;
                    tilesize = 1;
                    wvous-bl-corner = 1;
                    wvous-br-corner = 1;
                    wvous-tl-corner = 1;
                    wvous-tr-corner = 1;
                };
                finder = {
                    AppleShowAllExtensions = true;
                    AppleShowAllFiles = true;
                    CreateDesktop = false;
                    FXDefaultSearchScope = "SCcf";
                    FXPreferredViewStyle = "clmv";
                    FXRemoveOldTrashItems = true;
                    NewWindowTarget = "Home";
                    ShowPathbar = true;
                    ShowStatusBar = true;
                    _FXSortFoldersFirst = true;
                    _FXShowPosixPathInTitle = true;
                };
            };
        };
    };

    flake.modules.nixos.core = {
        systemd.tmpfiles.rules = ["d /data 0755 root root -"];
    };
}
