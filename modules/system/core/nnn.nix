{
    flake.modules.nixos.core =
        { pkgs, ... }:
        {
            environment = {
                systemPackages = [ (import ./_nnn.nix { inherit pkgs; }) ];
                # nnn has no config file; it reads its single-letter flags from here on
                # every start (including the nvim/helix `-` pickers): -e -H -a -i -o -U.
                variables.NNN_OPTS = "eHaioU";
                variables.NNN_TMPFILE = "/tmp/.lastd";
            };
        };
}
