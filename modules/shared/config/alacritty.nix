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
      # tokyonight
      #   primary = {
      #     background = "#1a1b26";
      #     foreground = "#c0caf5";
      #   };
      #   selection = {
      #     foreground = "0xc8c093";
      #     background = "0x2d4f67";
      #   };
      #   normal = {
      #     black = "#15161e";
      #     red = "#f7768e";
      #     green = "#9ece6a";
      #     yellow = "#e0af68";
      #     blue = "#7aa2f7";
      #     magenta = "#bb9af7";
      #     cyan = "#7dcfff";
      #     white = "#a9b1d6";
      #   };
      #   bright = {
      #     black = "#414868";
      #     red = "#f7768e";
      #     green = "#9ece6a";
      #     yellow = "#e0af68";
      #     blue = "#7aa2f7";
      #     magenta = "#bb9af7";
      #     cyan = "#7dcfff";
      #     white = "#c0caf5";
      #   };
      # };

      # melange
      primary = {
        foreground = "#ECE1D7";
        background = "#292522";
      };
      normal = {
        black = "#34302C";
        red = "#BD8183";
        green = "#78997A";
        yellow = "#E49B5D";
        blue = "#7F91B2";
        magenta = "#B380B0";
        cyan = "#7B9695";
        white = "#C1A78E";
      };
      bright = {
        black = "#867462";
        red = "#D47766";
        green = "#85B695";
        yellow = "#EBC06D";
        blue = "#A3A9CE";
        magenta = "#CF9BC2";
        cyan = "#89B3B6";
        white = "#ECE1D7";
      };
    };
  };
}
