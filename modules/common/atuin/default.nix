{...}: {
    programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        settings = {
            dialect = "uk";
            auto_sync = true;
            update_check = true;
            sync_frequency = "5m";
            sync_address = "https://api.atuin.sh";
        };
    };
}
