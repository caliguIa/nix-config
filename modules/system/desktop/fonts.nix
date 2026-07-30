{lib, ...}: let
    # Berkeley Mono is proprietary, so the raw font files cannot live
    # unencrypted in this public repo. They are stored as agenix secrets and
    # decrypted at activation into /run/fonts, which fontconfig is pointed at
    # via a <dir> include below. The decrypted bytes only ever exist on tmpfs
    # at runtime, never in git or the world-readable Nix store.
    fontDir = "/run/fonts";
    fontFiles = [
        "BerkeleyMono-Regular.otf"
        "BerkeleyMono-Bold.otf"
        "BerkeleyMono-Oblique.otf"
        "BerkeleyMono-Bold-Oblique.otf"
        "BerkeleyMono-Regular.ttf"
        "BerkeleyMono-Bold.ttf"
        "BerkeleyMono-Oblique.ttf"
        "BerkeleyMono-Bold-Oblique.ttf"
    ];
    mkSecret = name: {
        name = "font-${name}";
        value = {
            file = ../../../.secrets/fonts/${name}.age;
            path = "${fontDir}/${name}";
            mode = "444";
        };
    };
in {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        age.secrets = lib.listToAttrs (map mkSecret fontFiles);

        fonts.fontconfig.confPackages = [
            (pkgs.writeTextDir "etc/fonts/conf.d/10-berkeley-mono.conf" ''
                <?xml version="1.0"?>
                <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
                <fontconfig>
                  <dir>${fontDir}</dir>
                </fontconfig>
            '')
        ];
    };

    flake.modules.hjem.desktop = {pkgs, ...}: {
        packages = [pkgs.nerd-fonts.symbols-only];
    };
}
