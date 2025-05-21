{...}: {
    home.file = {
        ".local/bin/tmux-cmd-launcher.sh" = {
            source = ./files/tmux-cmd-launcher.sh;
            executable = true;
        };
        ".local/bin/csv-sql-fmt.sh" = {
            source = ./files/csv-sql-fmt.sh;
            executable = true;
        };
    };
}
