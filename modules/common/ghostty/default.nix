{
    xdg.configFile."ghostty/config".text = ''
        background = 121212
        #foreground = d5d5d5
        #selection-background = 323232
        font-family = BerkeleyMono Nerd Font
        font-feature = +liga
        font-size = 15
        macos-titlebar-style = hidden
        window-decoration = true
        window-theme = auto
        window-padding-color = background
        window-padding-balance = false
        window-padding-y = 0
        window-padding-x = 0
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
        shell-integration-features = no-cursor,sudo,no-title
    '';
}
