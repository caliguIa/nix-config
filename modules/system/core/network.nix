{
    flake.modules.nixos.core = {
        networking = {
            firewall = {
                enable = true;
                allowPing = true;
            };
        };
    };
}
