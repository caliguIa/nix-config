{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.ghostty.enable = true;
        programs.ghostty = {
            enable = true;
            enableFishIntegration = true;
            package =
                if pkgs.stdenvNoCC.isDarwin
                then null
                else pkgs.ghostty;
            settings = {
                font-feature = "+liga";
                macos-titlebar-style = "transparent";
                title = " ";
                window-decoration = "none";
                window-theme = "auto";
                window-padding-color = "background";
                window-padding-balance = false;
                window-padding-y = 0;
                window-padding-x = 0;
                maximize = true;
                confirm-close-surface = false;
                quit-after-last-window-closed = true;
                macos-window-shadow = false;
                window-save-state = "always";
                quick-terminal-animation-duration = 0;
                macos-non-native-fullscreen = false;
                macos-option-as-alt = true;
                adjust-cell-height = "65%";
                adjust-cursor-height = "65%";
                adjust-underline-position = "15%";
                adjust-font-baseline = "10%";
                cursor-style = "bar";
                adjust-cursor-thickness = 2;
                cursor-style-blink = true;
                mouse-hide-while-typing = true;
                clipboard-read = "allow";
                clipboard-write = "allow";
                clipboard-trim-trailing-spaces = true;
                copy-on-select = "clipboard";
                shell-integration-features = "sudo,cursor,no-title";
                keybind = [
                    "alt+3=text:#"
                ];
            };
        };
    };
}
