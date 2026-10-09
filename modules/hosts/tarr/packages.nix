{
    flake.modules.nixos.host_tarr = { pkgs, ... }: {
        environment.systemPackages = [ ];
        services.sunshine = {
            enable = true;
            package = pkgs.sunshine.override { cudaSupport = true; };
            autoStart = true;
            capSysAdmin = true;
            openFirewall = true;
            settings.capture = "kms";
        };
    };
}
