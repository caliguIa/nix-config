{ inputs, self, ... }:
let
    inherit (inputs.nixpkgs) lib;
    localPackages =
        callPackage:
        lib.packagesFromDirectoryRecursive {
            inherit callPackage;
            directory = ../../pkgs;
        };
    names = builtins.attrNames (localPackages (_: _: { }));
in
{
    # pkgs/<name>/package.nix -> pkgs.<name> on every host and .#<name>.
    flake.overlays.default =
        final: prev:
        lib.mapAttrs (
            name: pkg:
            # Shadowing nixpkgs is allowed (keyguard does it on purpose), but say so once nixpkgs catches up.
            lib.warnIf (
                prev ? ${name} && lib.versionAtLeast prev.${name}.version pkg.version
            ) "pkgs/${name}: nixpkgs has ${prev.${name}.version}, drop the local copy" pkg
        ) (localPackages final.callPackage);

    perSystem =
        { pkgs, system, ... }:
        {
            _module.args.pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ self.overlays.default ];
            };
            packages = lib.filterAttrs (_: lib.meta.availableOn pkgs.stdenv.hostPlatform) (
                lib.getAttrs names pkgs
            );
        };
}
