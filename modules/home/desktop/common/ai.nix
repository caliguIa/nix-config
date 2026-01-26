{
    flake.modules.homeManager.desktop-common-ai = {
        programs.opencode = {
            enable = true;
            settings = {
                theme = "opencode";
                model = "anthropic/claude-sonnet-4-20250514";
                autoshare = false;
                autoupdate = true;
            };
        };
    };
}
