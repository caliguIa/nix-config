{
    flake.modules.homeManager.host_george = {
        services.ssh-agent.enable = true;
        programs.ssh = {
            enable = true;
            addKeysToAgent = "yes";
        };
    };
}
