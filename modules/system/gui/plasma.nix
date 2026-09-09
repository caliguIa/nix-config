{
    flake.modules.nixos.gui =
        { lib, ... }:
        let
            renderGroup = group: "[" + lib.concatStringsSep "][" (lib.splitString "/" group) + "]";

            lockedIni =
                groups:
                lib.concatStringsSep "\n" (
                    lib.mapAttrsToList (
                        group: keys:
                        "${renderGroup group}\n"
                        + lib.concatStrings (lib.mapAttrsToList (key: value: "${key}[$i]=${value}\n") keys)
                    ) groups
                );

            # A global shortcut is "<active>,<default>,<friendly name>", where
            # several bindings for one action are joined by a literal \t. The
            # '' strings below keep that backslash literal.
            shortcut =
                active: default: name:
                "${active},${default},${name}";

            # Meta+<key> focuses a desktop
            # Meta+Shift+<key> moves the current window there
            desktopKeys = [
                "A"
                "S"
                "D"
                "F"
            ];
            desktopShortcuts = lib.listToAttrs (
                lib.concatLists (
                    lib.imap1 (
                        i: key:
                        let
                            n = toString i;
                        in
                        [
                            (lib.nameValuePair "Switch to Desktop ${n}" (
                                shortcut "Meta+${key}" ''Ctrl+F${n}\tMeta+F${n}'' "Switch to Desktop ${n}"
                            ))
                            (lib.nameValuePair "Window to Desktop ${n}" (
                                shortcut "Meta+Shift+${key}" "none" "Window to Desktop ${n}"
                            ))
                        ]
                    ) desktopKeys
                )
            );

            # Every default binding Plasma registers, disabled. The shortcuts we
            # actually want are merged over the top below.
            disabledShortcuts = import ./_plasma-default-shortcuts.nix;

            keptShortcuts = {
                kwin = desktopShortcuts // {
                    "Window Maximize" = shortcut "Meta+M" "Meta+PgUp" "Maximise Window";
                };
                "services/org.kde.krunner.desktop"._launch = "Meta+R";
            };

            # 9 is KWin's ElectricNone, i.e. "no edge triggers this".
            noEdge = "9";
            screenEdges = [
                "Top"
                "TopRight"
                "Right"
                "BottomRight"
                "Bottom"
                "BottomLeft"
                "Left"
                "TopLeft"
            ];

            lockedSettings = {
                kglobalshortcutsrc = lib.recursiveUpdate disabledShortcuts keptShortcuts;

                kwinrc = {
                    Desktops = {
                        Number = "4";
                        Rows = "1";
                    };

                    # Screen edges, disabled from every direction. The named
                    # edge actions go first, then the drag-a-window-to-an-edge
                    # behaviours, then each effect that can claim an edge of its
                    # own.
                    ElectricBorders = lib.genAttrs screenEdges (_: "None");
                    Windows = {
                        ElectricBorders = "0";
                        ElectricBorderMaximize = "false";
                        ElectricBorderTiling = "false";
                        ElectricBorderAllScreenCorner = "false";
                    };
                    "Effect-overview" = {
                        BorderActivate = noEdge;
                        BorderActivateAll = noEdge;
                    };
                    "Effect-windowview" = {
                        BorderActivate = noEdge;
                        BorderActivateAll = noEdge;
                        BorderActivateClass = noEdge;
                    };
                    "Effect-desktopgrid".BorderActivate = noEdge;
                    TabBox = {
                        BorderActivate = noEdge;
                        BorderAlternativeActivate = noEdge;
                    };
                };

                kdeglobals = {
                    General = {
                        ColorScheme = "BreezeDark";
                        fixed = "Berkeley Mono,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    };
                    KDE = {
                        LookAndFeelPackage = "org.kde.breezedark.desktop";
                        widgetStyle = "Breeze";
                        AnimationDurationFactor = "0";
                    };
                    Icons.Theme = "breeze-dark";
                };

                ksmserverrc.General.loginMode = "emptySession";
            };
        in
        {
            environment.etc = lib.mapAttrs' (
                file: groups: lib.nameValuePair "xdg/${file}" { text = lockedIni groups; }
            ) lockedSettings;
        };
}
