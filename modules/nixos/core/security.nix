{self, ...}: {
    flake.modules.darwin.core = {
        imports = [self.modules.generic.system-core-security];
        security.pam.services.sudo_local = {
            enable = true;
            touchIdAuth = true;
            reattach = true;
        };
    };

    flake.modules.nixos.core = {
        imports = [self.modules.generic.system-core-security];
        security.sudo.enable = true;
    };

    flake.modules.generic.system-core-security = {
        security.sudo.extraConfig = ''
            Defaults    timestamp_timeout=30
        '';
    };
}
