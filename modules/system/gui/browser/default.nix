{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            environment.systemPackages = [ pkgs.ungoogled-chromium ];
        };
}
