{
    flake.modules.darwin.core = {
        networking = {
            dns = ["8.8.8.8"];
            applicationFirewall = {
                enable = true;
                blockAllIncoming = false;
                enableStealthMode = true;
            };
        };
    };
    flake.modules.nixos.core = {
        networking = {
            nameservers = ["8.8.8.8"];
            firewall = {
                enable = true;
                allowPing = true;
            };
        };
    };
}
