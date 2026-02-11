{
    flake.modules.homeManager.desktop-linux-kickoff = {config, ...}: {
        programs.kickoff = {
            enable = true;
            settings = {
                fonts = [config.stylix.fonts.monospace.name];
                font-size = 32;
                prompt = "> ";
                padding = 100;
                search.show_hidden_files = false;
                history.decrease_interval = 48;
                keybindings = {
                    paste = ["ctrl+v" "ctrl+shift+v"];
                    execute = ["KP_Enter" "Return" "ctrl+y"];
                    delete = ["KP_Delete" "Delete" "BackSpace"];
                    delete_word = ["ctrl+KP_Delete" "ctrl+Delete" "ctrl+BackSpace"];
                    complete = ["Tab" "Left" "ctrl+Left"];
                    nav_up = ["Up" "ctrl+Up" "ctrl+p"];
                    nav_down = ["Down" "ctrl+Down" "ctrl+n"];
                    exit = ["Escape" "ctrl+c"];
                };
                colors = let
                    colours = config.lib.stylix.colors;
                in {
                    background = "#${colours.base01}aa";
                    prompt = "#${colours.base06}";
                    text = "#${colours.base07}";
                    text_query = "#${colours.base07}";
                    text_selected = "#${colours.base0A}";
                };
            };
        };
    };
}
