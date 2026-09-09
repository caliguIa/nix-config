# Generated from a live ~/.config/kglobalshortcutsrc (Plasma 6.7.4) with:
#
#   awk -f ... (see git history) -- every global shortcut Plasma had registered,
#   rewritten to the disabled form.
#
# This is the "disable every default keybinding" list. Each value is written
# verbatim into /etc/xdg/kglobalshortcutsrc with an immutability marker, so the
# action exists but has no binding and cannot be rebound. Values keep the
# "<active>,<default>,<friendly name>" shape so System Settings still shows a
# readable action name; the [services][...] groups use the single-field shape
# those entries actually take on disk.
#
# The hardware-key components -- kmix, mediacontrol and org_kde_powerdevil --
# are deliberately absent, so volume, media, brightness and the power/sleep
# keys keep working. Anything Plasma registers that was not present in the
# source file keeps its built-in default; re-generate after installing new KDE
# applications.
#
# Underscore-prefixed so lib/recursivelyImport.nix does not pick it up as a
# flake-parts module; plasma.nix imports it explicitly.
{
    "ActivityManager" = {
        "switch-to-activity-1f6d1bb3-2c57-4a70-a956-4315595f9763" =
            "none,none,Switch to activity \"Default\"";
    };
    "kaccess" = {
        "Toggle Screen Reader On and Off" = "none,none,Toggle Screen Reader On and Off";
    };
    "KDE Keyboard Layout Switcher" = {
        "Switch to Last-Used Keyboard Layout" = "none,none,Switch to Last-Used Keyboard Layout";
        "Switch to Next Keyboard Layout" = "none,none,Switch to Next Keyboard Layout";
    };
    "ksmserver" = {
        "Halt Without Confirmation" = "none,none,Shut Down Without Confirmation";
        "Lock Session" = "none,none,Lock Session";
        "Log Out" = "none,none,Show Logout Screen";
        "LogOut" = "none,none,Log Out";
        "Log Out Without Confirmation" = "none,none,Log Out Without Confirmation";
        "Reboot" = "none,none,Reboot";
        "Reboot Without Confirmation" = "none,none,Reboot Without Confirmation";
        "Shut Down" = "none,none,Shut Down";
    };
    "kwin" = {
        "Activate Window Demanding Attention" = "none,none,Activate Window Demanding Attention";
        "Cycle Overview" = "none,none,Cycle through Overview and Grid View";
        "Cycle Overview Opposite" = "none,none,Cycle through Grid View and Overview";
        "Decrease Opacity" = "none,none,Decrease Opacity of Active Window by 5%";
        "disableInputCapture" = "none,none,Disable Active Input Capture";
        "Edit Tiles" = "none,none,Toggle Tiles Editor";
        "Expose" = "none,none,Toggle Present Windows (Current desktop)";
        "ExposeAll" = "none,none,Toggle Present Windows (All desktops)";
        "ExposeClass" = "none,none,Toggle Present Windows (Window class)";
        "ExposeClassCurrentDesktop" = "none,none,Toggle Present Windows (Window class on current desktop)";
        "Grid View" = "none,none,Toggle Grid View";
        "Increase Opacity" = "none,none,Increase Opacity of Active Window by 5%";
        "Kill Window" = "none,none,Kill Window";
        "MoveMouseToCenter" = "none,none,Move Mouse to Centre";
        "MoveMouseToFocus" = "none,none,Move Mouse to Focus";
        "Move Tablet to Next LogicalOutput" = "none,none,Move the tablet to the next output";
        "MoveZoomDown" = "none,none,Move Zoomed Area Downwards";
        "MoveZoomLeft" = "none,none,Move Zoomed Area to Left";
        "MoveZoomRight" = "none,none,Move Zoomed Area to Right";
        "MoveZoomUp" = "none,none,Move Zoomed Area Upwards";
        "Overview" = "none,none,Toggle Overview";
        "Setup Window Shortcut" = "none,none,Setup Window Shortcut";
        "Show Desktop" = "none,none,Peek at Desktop";
        "Switch One Desktop Down" = "none,none,Switch One Desktop Down";
        "Switch One Desktop to the Left" = "none,none,Switch One Desktop to the Left";
        "Switch One Desktop to the Right" = "none,none,Switch One Desktop to the Right";
        "Switch One Desktop Up" = "none,none,Switch One Desktop Up";
        "Switch to Desktop 1" = "none,none,Switch to Desktop 1";
        "Switch to Desktop 10" = "none,none,Switch to Desktop 10";
        "Switch to Desktop 11" = "none,none,Switch to Desktop 11";
        "Switch to Desktop 12" = "none,none,Switch to Desktop 12";
        "Switch to Desktop 13" = "none,none,Switch to Desktop 13";
        "Switch to Desktop 14" = "none,none,Switch to Desktop 14";
        "Switch to Desktop 15" = "none,none,Switch to Desktop 15";
        "Switch to Desktop 16" = "none,none,Switch to Desktop 16";
        "Switch to Desktop 17" = "none,none,Switch to Desktop 17";
        "Switch to Desktop 18" = "none,none,Switch to Desktop 18";
        "Switch to Desktop 19" = "none,none,Switch to Desktop 19";
        "Switch to Desktop 2" = "none,none,Switch to Desktop 2";
        "Switch to Desktop 20" = "none,none,Switch to Desktop 20";
        "Switch to Desktop 21" = "none,none,Switch to Desktop 21";
        "Switch to Desktop 22" = "none,none,Switch to Desktop 22";
        "Switch to Desktop 23" = "none,none,Switch to Desktop 23";
        "Switch to Desktop 24" = "none,none,Switch to Desktop 24";
        "Switch to Desktop 25" = "none,none,Switch to Desktop 25";
        "Switch to Desktop 3" = "none,none,Switch to Desktop 3";
        "Switch to Desktop 4" = "none,none,Switch to Desktop 4";
        "Switch to Desktop 5" = "none,none,Switch to Desktop 5";
        "Switch to Desktop 6" = "none,none,Switch to Desktop 6";
        "Switch to Desktop 7" = "none,none,Switch to Desktop 7";
        "Switch to Desktop 8" = "none,none,Switch to Desktop 8";
        "Switch to Desktop 9" = "none,none,Switch to Desktop 9";
        "Switch to Next Desktop" = "none,none,Switch to Next Desktop";
        "Switch to Next Screen" = "none,none,Switch to Next Screen";
        "Switch to Previous Desktop" = "none,none,Switch to Previous Desktop";
        "Switch to Previous Screen" = "none,none,Switch to Previous Screen";
        "Switch to Screen 0" = "none,none,Switch to Screen 0";
        "Switch to Screen 1" = "none,none,Switch to Screen 1";
        "Switch to Screen 2" = "none,none,Switch to Screen 2";
        "Switch to Screen 3" = "none,none,Switch to Screen 3";
        "Switch to Screen 4" = "none,none,Switch to Screen 4";
        "Switch to Screen 5" = "none,none,Switch to Screen 5";
        "Switch to Screen 6" = "none,none,Switch to Screen 6";
        "Switch to Screen 7" = "none,none,Switch to Screen 7";
        "Switch to Screen Above" = "none,none,Switch to Screen Above";
        "Switch to Screen Below" = "none,none,Switch to Screen Below";
        "Switch to Screen to the Left" = "none,none,Switch to Screen to the Left";
        "Switch to Screen to the Right" = "none,none,Switch to Screen to the Right";
        "Switch Window Down" = "none,none,Switch to Window Below";
        "Switch Window Left" = "none,none,Switch to Window to the Left";
        "Switch Window Right" = "none,none,Switch to Window to the Right";
        "Switch Window Up" = "none,none,Switch to Window Above";
        "Toggle Night Color" = "none,none,Suspend/Resume Night Light";
        "Toggle Window Raise/Lower" = "none,none,Toggle Window Raise/Lower";
        "view_actual_size" = "none,none,Zoom to Actual Size";
        "view_zoom_in" = "none,none,Zoom In";
        "view_zoom_out" = "none,none,Zoom Out";
        "Walk Through Windows" = "none,none,Walk Through Windows";
        "Walk Through Windows Alternative" = "none,none,Walk Through Windows Alternative";
        "Walk Through Windows Alternative (Reverse)" =
            "none,none,Walk Through Windows Alternative (Reverse)";
        "Walk Through Windows of Current Application" =
            "none,none,Walk Through Windows of Current Application";
        "Walk Through Windows of Current Application Alternative" =
            "none,none,Walk Through Windows of Current Application Alternative";
        "Walk Through Windows of Current Application Alternative (Reverse)" =
            "none,none,Walk Through Windows of Current Application Alternative (Reverse)";
        "Walk Through Windows of Current Application (Reverse)" =
            "none,none,Walk Through Windows of Current Application (Reverse)";
        "Walk Through Windows (Reverse)" = "none,none,Walk Through Windows (Reverse)";
        "Window Above Other Windows" = "none,none,Keep Window Above Others";
        "Window Below Other Windows" = "none,none,Keep Window Below Others";
        "Window Close" = "none,none,Close Window";
        "Window Custom Quick Tile Bottom" = "none,none,Custom Quick Tile Window to the Bottom";
        "Window Custom Quick Tile Left" = "none,none,Custom Quick Tile Window to the Left";
        "Window Custom Quick Tile Right" = "none,none,Custom Quick Tile Window to the Right";
        "Window Custom Quick Tile Top" = "none,none,Custom Quick Tile Window to the Top";
        "Window Fullscreen" = "none,none,Make Window Fullscreen";
        "Window Grow Horizontal" = "none,none,Expand Window Horizontally";
        "Window Grow Vertical" = "none,none,Expand Window Vertically";
        "Window Lower" = "none,none,Lower Window";
        "Window Maximize" = "none,none,Maximise Window";
        "Window Maximize Horizontal" = "none,none,Maximise Window Horizontally";
        "Window Maximize Vertical" = "none,none,Maximise Window Vertically";
        "Window Minimize" = "none,none,Minimise Window";
        "Window Move" = "none,none,Move Window";
        "Window Move Center" = "none,none,Move Window to the Centre";
        "Window No Border" = "none,none,Toggle Window Titlebar and Frame";
        "Window On All Desktops" = "none,none,Keep Window on All Desktops";
        "Window One Desktop Down" = "none,none,Window One Desktop Down";
        "Window One Desktop to the Left" = "none,none,Window One Desktop to the Left";
        "Window One Desktop to the Right" = "none,none,Window One Desktop to the Right";
        "Window One Desktop Up" = "none,none,Window One Desktop Up";
        "Window One Screen Down" = "none,none,Move Window One Screen Down";
        "Window One Screen to the Left" = "none,none,Move Window One Screen to the Left";
        "Window One Screen to the Right" = "none,none,Move Window One Screen to the Right";
        "Window One Screen Up" = "none,none,Move Window One Screen Up";
        "Window Operations Menu" = "none,none,Window Menu";
        "Window Pack Down" = "none,none,Move Window Down";
        "Window Pack Left" = "none,none,Move Window Left";
        "Window Pack Right" = "none,none,Move Window Right";
        "Window Pack Up" = "none,none,Move Window Up";
        "Window Quick Tile Bottom" = "none,none,Quick Tile Window to the Bottom";
        "Window Quick Tile Bottom Left" = "none,none,Quick Tile Window to the Bottom Left";
        "Window Quick Tile Bottom Right" = "none,none,Quick Tile Window to the Bottom Right";
        "Window Quick Tile Left" = "none,none,Quick Tile Window to the Left";
        "Window Quick Tile Right" = "none,none,Quick Tile Window to the Right";
        "Window Quick Tile Top" = "none,none,Quick Tile Window to the Top";
        "Window Quick Tile Top Left" = "none,none,Quick Tile Window to the Top Left";
        "Window Quick Tile Top Right" = "none,none,Quick Tile Window to the Top Right";
        "Window Raise" = "none,none,Raise Window";
        "Window Resize" = "none,none,Resize Window";
        "Window Restore" = "none,none,Restore Window";
        "Window Shrink Horizontal" = "none,none,Shrink Window Horizontally";
        "Window Shrink Vertical" = "none,none,Shrink Window Vertically";
        "Window to Desktop 1" = "none,none,Window to Desktop 1";
        "Window to Desktop 10" = "none,none,Window to Desktop 10";
        "Window to Desktop 11" = "none,none,Window to Desktop 11";
        "Window to Desktop 12" = "none,none,Window to Desktop 12";
        "Window to Desktop 13" = "none,none,Window to Desktop 13";
        "Window to Desktop 14" = "none,none,Window to Desktop 14";
        "Window to Desktop 15" = "none,none,Window to Desktop 15";
        "Window to Desktop 16" = "none,none,Window to Desktop 16";
        "Window to Desktop 17" = "none,none,Window to Desktop 17";
        "Window to Desktop 18" = "none,none,Window to Desktop 18";
        "Window to Desktop 19" = "none,none,Window to Desktop 19";
        "Window to Desktop 2" = "none,none,Window to Desktop 2";
        "Window to Desktop 20" = "none,none,Window to Desktop 20";
        "Window to Desktop 21" = "none,none,Window to Desktop 21";
        "Window to Desktop 22" = "none,none,Window to Desktop 22";
        "Window to Desktop 23" = "none,none,Window to Desktop 23";
        "Window to Desktop 24" = "none,none,Window to Desktop 24";
        "Window to Desktop 25" = "none,none,Window to Desktop 25";
        "Window to Desktop 3" = "none,none,Window to Desktop 3";
        "Window to Desktop 4" = "none,none,Window to Desktop 4";
        "Window to Desktop 5" = "none,none,Window to Desktop 5";
        "Window to Desktop 6" = "none,none,Window to Desktop 6";
        "Window to Desktop 7" = "none,none,Window to Desktop 7";
        "Window to Desktop 8" = "none,none,Window to Desktop 8";
        "Window to Desktop 9" = "none,none,Window to Desktop 9";
        "Window to Next Desktop" = "none,none,Window to Next Desktop";
        "Window to Next Screen" = "none,none,Move Window to Next Screen";
        "Window to Previous Desktop" = "none,none,Window to Previous Desktop";
        "Window to Previous Screen" = "none,none,Move Window to Previous Screen";
        "Window to Screen 0" = "none,none,Move Window to Screen 0";
        "Window to Screen 1" = "none,none,Move Window to Screen 1";
        "Window to Screen 2" = "none,none,Move Window to Screen 2";
        "Window to Screen 3" = "none,none,Move Window to Screen 3";
        "Window to Screen 4" = "none,none,Move Window to Screen 4";
        "Window to Screen 5" = "none,none,Move Window to Screen 5";
        "Window to Screen 6" = "none,none,Move Window to Screen 6";
        "Window to Screen 7" = "none,none,Move Window to Screen 7";
    };
    "plasmashell" = {
        "activate application launcher" = "none,none,Activate Application Launcher";
        "activate task manager entry 1" = "none,none,Activate Task Manager Entry 1";
        "activate task manager entry 10" = "none,none,Activate Task Manager Entry 10";
        "activate task manager entry 2" = "none,none,Activate Task Manager Entry 2";
        "activate task manager entry 3" = "none,none,Activate Task Manager Entry 3";
        "activate task manager entry 4" = "none,none,Activate Task Manager Entry 4";
        "activate task manager entry 5" = "none,none,Activate Task Manager Entry 5";
        "activate task manager entry 6" = "none,none,Activate Task Manager Entry 6";
        "activate task manager entry 7" = "none,none,Activate Task Manager Entry 7";
        "activate task manager entry 8" = "none,none,Activate Task Manager Entry 8";
        "activate task manager entry 9" = "none,none,Activate Task Manager Entry 9";
        "clear history" = "none,none,Clear Notification History";
        "clear-history" = "none,none,Clear Clipboard History";
        "clipboard_action" = "none,none,Automatic Action Popup Menu";
        "cycleNextAction" = "none,none,Next History Item";
        "cycle-panels" = "none,none,Move keyboard focus between panels";
        "cyclePrevAction" = "none,none,Previous History Item";
        "edit_clipboard" = "none,none,Edit Contents…";
        "manage activities" = "none,none,Show Activity Switcher";
        "next activity" = "none,none,Walk through activities";
        "previous activity" = "none,none,Walk through activities (Reverse)";
        "repeat_action" = "none,none,Manually Invoke Action on Current Clipboard";
        "show-barcode" = "none,none,Show Barcode…";
        "show dashboard" = "none,none,Show Desktop";
        "show-on-mouse-pos" = "none,none,Show Clipboard Items at Mouse Position";
        "Slideshow Wallpaper Next Image" = "none,none,Next Wallpaper Image";
        "switch to next activity" = "none,none,Switch to Next Activity";
        "switch to previous activity" = "none,none,Switch to Previous Activity";
        "toggle do not disturb" = "none,none,Toggle do not disturb";
    };
    "services/org.kde.spectacle.desktop" = {
        "_launch" = "none";
        "RecordRegion" = "none";
    };
}
