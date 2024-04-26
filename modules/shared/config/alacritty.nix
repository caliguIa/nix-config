{ ... }: {
  enable = true;
  settings = {
    cursor = { style = "Block"; };
    mouse = { hide_when_typing = true; };

    window = {
      opacity = 1.0;
      blur = false;
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
        y = 5;
      };
    };

    colors = {
      primary = {
        background = "#1a1b26";
        foreground = "#c0caf5";
      };
      selection = {
        foreground = "0xc8c093";
        background = "0x2d4f67";
      };
      normal = {
        black = "#15161e";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#7dcfff";
        white = "#a9b1d6";
      };
      bright = {
        black = "#414868";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#7dcfff";
        white = "#c0caf5";
      };
    };
  };
}
