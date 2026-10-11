{
    flake.modules.nixos.core =
        { pkgs, ... }:
        {
            environment = {
                systemPackages = [ (import ./_nnn.nix { inherit pkgs; }) ];
                variables.NNN_OPTS = "eHaioU";
                variables.NNN_TMPFILE = "/tmp/.lastd";
            };
        };
}
