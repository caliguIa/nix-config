{
    flake.modules.darwin.core = {
        networking = {
            dns = ["1.1.1.1" "1.0.0.1"];
            applicationFirewall = {
                enable = true;
                blockAllIncoming = false;
                enableStealthMode = true;
            };
        };
    };
    flake.modules.nixos.core = {
        networking = {
            firewall = {
                enable = false;
                allowPing = true;
            };
        };
    };
}
