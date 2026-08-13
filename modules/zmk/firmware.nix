{ inputs, ... }:
{
    perSystem =
        { pkgs, system, ... }:
        let
            zmk-nix = inputs.zmk-nix;

            firmware = zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
                name = "lily58-firmware";

                src = pkgs.lib.sourceFilesBySuffices ./. [
                    ".board"
                    ".cmake"
                    ".conf"
                    ".defconfig"
                    ".dts"
                    ".dtsi"
                    ".json"
                    ".keymap"
                    ".overlay"
                    ".shield"
                    ".yml"
                    "_defconfig"
                ];

                board = "nice_nano";
                shield = "lily58_%PART%";

                zephyrDepsHash = "sha256-9nQeZNViGZft1Xd8DnEllDi1MeQTd1ejTKzf1x2XlG0=";

                meta = {
                    description = "Lily58 ZMK firmware";
                    license = pkgs.lib.licenses.mit;
                    platforms = pkgs.lib.platforms.all;
                };
            };

            # zmk-nix's flash script shells out to `udisksctl` but does not
            # include udisks in its runtimeInputs, so wrap it to guarantee it
            # is on PATH regardless of the ambient environment.
            flash = pkgs.symlinkJoin {
                name = "lily58-flash";
                paths = [ (zmk-nix.packages.${system}.flash.override { inherit firmware; }) ];
                buildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                    wrapProgram $out/bin/zmk-uf2-flash \
                        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.udisks ]}
                '';
            };
        in
        {
            packages.zmk-firmware = firmware;
            packages.zmk-flash = flash;
        };
}
