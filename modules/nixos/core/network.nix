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
            nameservers = ["1.1.1.1"];
            firewall = {
                enable = false;
                allowPing = true;
            };
        };
    };
}
