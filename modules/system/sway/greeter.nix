{ inputs, user, ... }:
{
    flake.modules.nixos.sway =
        { config, lib, ... }:
        {
            imports = [ inputs.dank-greeter.nixosModules.default ];

            # DMS's greeter on greetd, replacing SDDM. It still lists every installed
            # session, so Plasma stays selectable.
            programs.dms-greeter = {
                enable = true;
                compositor.name = "sway";
                # Copies DMS's settings, wallpaper and colours into the greeter's
                # cache when greetd starts, so it matches the logged-in shell.
                configHome = config.users.users.${user.primary}.home;
            };

            # greetd's PAM substacks login, which already unlocks KWallet.
            services.displayManager.sddm.enable = lib.mkForce false;

            # Fingerprint only unlocks (DMS lock, sudo, polkit), never logs in: a
            # fingerprint login would skip KWallet, which needs the typed password.
            # This also covers the greeter, which reads login's stack for its UI.
            security.pam.services.login.fprintAuth = false;
        };
}
