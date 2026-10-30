{ user, secret, ... }:
{
    flake.modules.nixos.dev = {
        # Read through INTELEPHENSE_KEY_PATH below.
        age.secrets.intelephense = {
            file = secret "intelephense";
            owner = user.primary;
            group = user.primary;
            mode = "400";
        };
        programs.fish.shellInit = ''
            set -gx INTELEPHENSE_KEY_PATH /run/agenix/intelephense
        '';
    };
}
