{
    flake.modules.homeManager.desktop-darwin-files = {
        xdg.configFile."frisk/config.toml".text = ''
            prompt = "frisk: "
            font_family = "Berkeley Mono"
            font_size = 32
            window_opacity = 0.85
            window_padding = 20
            prompt_to_items = 60
            item_spacing = 15
            background = "#282c34"
            items = "#ffffff"
            selected_item = "#61afef"
            query = "#e06c75"
            caret = "#e06c75"
        '';
        xdg.configFile."frisk/commands.toml".text = ''
            [[command]]
            name = "Clipboard History"
            action = "frisk --clipboard --prompt 'clipboard: '"

            [[command]]
            name = "email"
            action = "/etc/profiles/per-user/caligula/bin/openAercKitty"

            [[command]]
            name = "Homebrew"
            action = "frisk --homebrew --prompt 'homebrew: '"

            [[command]]
            name = "nixpkgs"
            action = "frisk --nixpkgs --prompt 'nixpkgs: '"

            [[command]]
            name = "Define"
            action = "frisk --dictionary 'define: '"

            [[command]]
            name = "Empty Trash"
            action = "osascript -e 'tell application \"Finder\" to empty trash'"

            [[command]]
            name = "Show Trash"
            action = "osascript -e 'tell application \"Finder\" to open trash' && open -a finder"

            [[command]]
            name = "Restart"
            action = "osascript -e 'tell application \"System Events\" to restart'"

            [[command]]
            name = "Shut Down"
            action = "osascript -e 'tell application \"System Events\" to shut down'"

            [[command]]
            name = "Sleep"
            action = "osascript -e 'tell application \"System Events\" to sleep'"

            [[command]]
            name = "Lock Screen"
            action = "pmset displaysleepnow"
        '';
        xdg.configFile."kission/config.toml".text = ''
            search_paths = ["/Users/caligula/dev"]
            bookmarks = ["/Users/caligula/nix-config", "/Users/caligula/ous/platform"]
        '';
    };
}
