{ ... }:
{
  enable = true;
  settings = {
    cursor = {
      style = "Block";
    };
    mouse = {
      hide_when_typing = true;
    };

    window = {
      opacity = 1.0;
      blur = true;
      decorations = "none";
      startup_mode = "Maximized";
      padding = {
        x = 0;
        y = 0;
      };
    };

    font = {
      normal = {
        family = "BerkeleyMono Nerd Font";
        style = "Regular";
      };
      bold = {
        family = "BerkeleyMono Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "BerkeleyMono Nerd Font";
        style = "Italic";
      };
      size = 14.0;
      offset = {
        x = 0;
        y = 15;
      };
    };

    colors = {
        primary = {
            background = "#1e1e2e";
            foreground = "#cdd6f4";
            dim_foreground = "#7f849c";
            bright_foreground = "#cdd6f4";
        };
        cursor = {
            text = "#1e1e2e";
            cursor = "#f5e0dc";
        };
        selection = {
            text = "#1e1e2e";
            background = "#f5e0dc";
        };
        normal = {
            black = "#45475a";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#bac2de";
        };
        bright = {
            black = "#585b70";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#a6adc8";
        };
        dim = {
            black = "#45475a";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#bac2de";
        };
    };
  };
}
