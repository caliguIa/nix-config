{ inputs, user, ... }:
{
    flake.modules.nixos.gui =
        { config, ... }:
        {
            imports = [ inputs.dank-greeter.nixosModules.default ];
            programs.dms-greeter = {
                enable = true;
                compositor.name = "sway";
                configHome = config.users.users.${user.primary}.home;
                # The greeter sway has no config of its own, so it would type in
                # xkbcommon's default (us) while the session uses the NixOS layout.
                compositor.customConfig = ''
                    input type:keyboard {
                        xkb_layout ${config.services.xserver.xkb.layout}
                    }
                '';
            };
            security.pam.services.login.fprintAuth = false;
        };
}
