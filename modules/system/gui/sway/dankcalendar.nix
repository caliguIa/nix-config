{ inputs, ... }:
{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            imports = [ inputs.dankcalendar.nixosModules.dank-calendar ];
            programs.dank-calendar = {
                enable = true;
                systemd.enable = true;
                systemd.target = "sway-session.target";
            };
            systemd.user.services.dcal.path = [ pkgs.xdg-utils ];
        };
}
