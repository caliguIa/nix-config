{ ... }:
{
  enable = true;
  settings = {
    # Basic options
    default_keybindings = true;
    use_nerdfont = true;
    notify = true;
    gapless = true;
    flip_status_indicators = true;
    library_tabs = [
      "playlists"
      "tracks"
      "artists"
      "albums"
      "browse"
    ];
    keybindings = {
      ##################;
      # Fast forward / rewind;
      ##################;
      "<" = "seek -10000";
      ">" = "seek +10000";
      ##################;
      # Play / pause;
      ##################;
      "Space" = "playpause";
      "Enter" = "play";
      "x" = "stop";
      ##################;
      # Track manipulation;
      ##################;
      "p" = "previous";
      "n" = "next";
      "r" = "repeat";
      "z" = "shuffle";
      "Shift+d" = "delete";
      "Shift+s" = "save";
      # Open context menu;
      "Shift+o" = "open current";
      "o" = "open selected";
      "Shift+a" = "goto artist";
      "a" = "goto album";
      ##################;
      # Queue;
      ##################;
      # Add to queue;
      "i" = "queue";
      "Ctrl+s" = "save queue";
      # Move selected song up/down in the queue;
      "Shift+j" = "shift down 1";
      "Shift+k" = "shift up 1";
      "Shift+c" = "clear";
      # Open the context menu for a Spotify link in the clipboard;
      "Ctrl+v" = "insert";
      ######################################;
      # Sound;
      ######################################;
      # "=" = "volup 1";
      # "-" = "voldown 1";
      "=" = "volup 5";
      "-" = "voldown 5";
      ######################################;
      # Movements;
      ######################################;
      "F1" = "focus queue";
      "F2" = "focus library";
      "F3" = "focus search";
      "1" = "focus queue";
      "2" = "focus library";
      "Ctrl+q" = "focus queue";
      "Ctrl+w" = "focus library";
      # Navigation;
      "Down" = "move down 1";
      "Shift+g" = "move bottom";
      "g" = "move top";
      "Left" = "move left 1";
      "Right" = "move right 1";
      "Ctrl+d" = "move down 5";
      "Ctrl+u" = "move up 5";
      "Up" = "move up 1";
      "h" = "move left 1";
      "j" = "move down 1";
      "k" = "move up 1";
      "l" = "move right 1";
      "." = "move playing";
      "q" = "back";
      ######################################;
      # Sorting;
      ######################################;
      "t" = "sort added d";
      "Shift+t" = "sort title a";
      ######################################;
      # Sharing;
      ######################################;
      "Shift+y" = "share selected";
      "y" = "share current";
      ######################################;
      # Other;
      ######################################;
      "Shift+q" = "quit";
      "Shift+z" = "quit";
      "?" = "help";
      "Shift+u" = "update";
    };
  };
}
