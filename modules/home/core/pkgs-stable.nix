{inputs, ...}: {
    flake.modules.homeManager.core = {pkgs, ...}: {
        _module.args.pkgs-stable = import inputs.nixpkgs-stable {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
        };
    };
}
