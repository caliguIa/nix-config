{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.firefox = {
                enable = true;
                package = pkgs.firefox-devedition;
            };
            environment.systemPackages = [ pkgs.ungoogled-chromium ];
        };
}
