{
    flake.modules.darwin.ghostty = {
        homebrew.casks = ["ghostty"];
    };
    flake.modules.homeManager.ghostty = {self, ...}: let
        themeConfig = import (self + /utils/colours);
        colours = themeConfig.colours;
    in {
        xdg.configFile."ghostty/config".text = ''
            background = ${colours.base}
            foreground = ${colours.text}
            palette = 0=${colours.terminal.black}
            palette = 1=${colours.terminal.red}
            palette = 2=${colours.terminal.green}
            palette = 3=${colours.terminal.yellow}
            palette = 4=${colours.terminal.blue}
            palette = 5=${colours.terminal.magenta}
            palette = 6=${colours.terminal.cyan}
            palette = 7=${colours.terminal.white}
            palette = 8=${colours.terminal.bright_black}
            palette = 9=${colours.terminal.bright_red}
            palette = 10=${colours.terminal.bright_green}
            palette = 11=${colours.terminal.bright_yellow}
            palette = 12=${colours.terminal.bright_blue}
            palette = 13=${colours.terminal.bright_magenta}
            palette = 14=${colours.terminal.bright_cyan}
            palette = 15=${colours.terminal.bright_white}
            font-family = Berkeley Mono
            font-family = Symbols Nerd Font Mono
            font-feature = +liga
            font-size = 14
            macos-titlebar-style = transparent
            title = " "
            window-decoration = none
            window-theme = auto
            window-padding-color = background
            window-padding-balance = false
            window-padding-y = 0
            window-padding-x = 0
            maximize = true
            confirm-close-surface = false
            quit-after-last-window-closed = true
            macos-window-shadow = false
            window-save-state = always
            quick-terminal-animation-duration = 0
            macos-non-native-fullscreen = false
            macos-option-as-alt = true
            adjust-cell-height = 65%
            adjust-cursor-height = 65%
            adjust-underline-position = 15%
            adjust-font-baseline = 10%
            cursor-style = bar
            adjust-cursor-thickness = 2
            cursor-style-blink = true
            mouse-hide-while-typing = true
            clipboard-read = allow
            clipboard-write = allow
            clipboard-trim-trailing-spaces = true
            copy-on-select = clipboard
            keybind = alt+3=text:#
            shell-integration-features = sudo,cursor,no-title
        '';
    };
}
