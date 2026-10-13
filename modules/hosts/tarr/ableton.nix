{ inputs, ... }: {
    flake.modules.nixos.host_tarr =
        { pkgs, ... }:
        {
            # ableton-live, ableton-wine, max9 + desktop entries.
            # Prefix is still imperative: `nix run github:shibco/ableton-linux#setup-prefix` once.
            environment.systemPackages = [
                inputs.ableton-linux.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            # Declarative setup-realtime: the launcher wraps wine in `chrt -r 10` when rtprio is allowed.
            # Swappiness is left alone, zram wants it high.
            security.pam.loginLimits = [
                {
                    domain = "@audio";
                    type = "-";
                    item = "rtprio";
                    value = "95";
                }
                {
                    domain = "@audio";
                    type = "-";
                    item = "memlock";
                    value = "unlimited";
                }
            ];

            # Declarative setup-link: the launcher starts ableton-linkd on demand in session mode.
            environment.sessionVariables.ABLETON_LINK_MODE = "session";
            networking.firewall.allowedUDPPorts = [ 20808 ];
        };
}
