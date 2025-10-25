{
    flake.modules.homeManager.server = {
        services.ssh-agent.enable = true;
        programs.ssh = {
            enable = true;
            addKeysToAgent = "yes";
        };
    };
}
