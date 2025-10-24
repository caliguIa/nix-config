let
    username = "caligula";
in {
    flake.modules.nixos.ssh = {
        users.users.${username}.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
        ];
        services.openssh.enable = true;
    };

    flake.modules.darwin.ssh = {};

    flake.modules.homeManager.ssh = {
        services.ssh-agent.enable = true;
        programs.ssh = {
            enable = true;
            addKeysToAgent = "yes";
        };
    };
}
