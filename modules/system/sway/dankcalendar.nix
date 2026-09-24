{ inputs, ... }:
{
    flake.modules.nixos.sway =
        { pkgs, ... }:
        {
            imports = [ inputs.dankcalendar.nixosModules.dank-calendar ];

            # Backs DMS's bar calendar (its "auto" backend prefers a running dcal) and
            # sends event reminders. Accounts live in the keyring, so they're added at
            # runtime with `dcal account add`, not declared here.
            programs.dank-calendar = {
                enable = true;
                systemd.enable = true;
                systemd.target = "sway-session.target";
            };

            # The unit's PATH is pinned; OAuth sign-in from the UI needs xdg-open.
            systemd.user.services.dcal.path = [ pkgs.xdg-utils ];
        };
}
