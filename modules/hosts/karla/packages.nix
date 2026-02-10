{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            spotify
            slack
            google-chrome
        ];
        # system.activationScripts.binbash = {
        #     text = ''
        #         ln -sf ${pkgs.bash}/bin/bash /bin/bash
        #     '';
        # };
    };
}
