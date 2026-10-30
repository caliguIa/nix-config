{
    flake.modules.nixos.host_smiley =
        { pkgs, ... }:
        {
            environment.systemPackages = [ pkgs.ghostty.terminfo ];
        };
}
