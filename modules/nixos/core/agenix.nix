{inputs, ...}: {
    flake.modules.nixos.core = {pkgs, ...}: {
        imports = [inputs.agenix.nixosModules.default];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenvNoCC.system}.default];
        age.secrets = {
            passwordfile-caligula.file = ../../../.secrets/passwordfile-caligula.age;
            cloudflared-audiobookshelf.file = ../../../.secrets/cloudflared-audiobookshelf.age;
            cloudflared-navidrome.file = ../../../.secrets/cloudflared-navidrome.age;
            cloudflared-slskd.file = ../../../.secrets/cloudflared-slskd.age;
            slskd-envars.file = ../../../.secrets/slskd-envars.age;
        };
    };
}
