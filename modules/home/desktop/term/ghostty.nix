{
    flake.modules.homeManager.desktop = {
        stylix.targets.ghostty.enable = true;
        programs.ghostty = {
            enable = true;
            systemd.enable = true;
            enableFishIntegration = true;
            installBatSyntax = true;
            installVimSyntax = true;
        };
    };
}
