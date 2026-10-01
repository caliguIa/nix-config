{ inputs, user, ... }:
{
    flake.modules.nixos.gui =
        { config, ... }:
        {
            imports = [ inputs.dank-greeter.nixosModules.default ];

            # DMS's greeter on greetd. greetd's PAM substacks login, which
            # unlocks the GNOME keyring with the typed password.
            programs.dms-greeter = {
                enable = true;
                compositor.name = "sway";
                # Copies DMS's settings, wallpaper and colours into the greeter's
                # cache when greetd starts, so it matches the logged-in shell.
                configHome = config.users.users.${user.primary}.home;
            };

            # Fingerprint only unlocks (DMS lock, sudo, polkit), never logs in: a
            # fingerprint login would leave the keyring locked, as it needs the
            # typed password. This also covers the greeter, which reads login's
            # stack for its UI.
            security.pam.services.login.fprintAuth = false;
        };
}
