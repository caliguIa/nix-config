{
    flake.modules.homeManager.core = {
        programs.fzf = {
            enable = true;
            enableFishIntegration = true;
            # Let atuin own Ctrl-R. fzf keeps Ctrl-T (files) and Alt-C (cd).
            historyWidget.command = "";
        };
    };
}
