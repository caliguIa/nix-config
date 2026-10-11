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
            };
            security.pam.services.login.fprintAuth = false;
        };
}
