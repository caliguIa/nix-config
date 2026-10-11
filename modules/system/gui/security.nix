{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            services.gnome.gnome-keyring.enable = true;
            services.gnome.gcr-ssh-agent.enable = false;
            programs.seahorse.enable = true;
            security.polkit.enable = true;
            environment.systemPackages = with pkgs; [
                polkit
            ];
        };
}
