{ inputs, ... }:
{
    perSystem =
        { pkgs, system, ... }:
        let
            zmk-nix = inputs.zmk-nix;
            zephyrDepsHash = "sha256-zDnYk7iavZLcuPRrl8QUMROnvikwBGOrDa5prc2cFtk=";

            firmware = zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
                name = "lily58-firmware";

                src = ./lily58;

                board = "nice_nano//zmk";
                shield = "lily58_%PART%";

                inherit zephyrDepsHash;

                meta = {
                    description = "Lily58 ZMK firmware";
                    license = pkgs.lib.licenses.mit;
                    platforms = pkgs.lib.platforms.all;
                };
            };

            # Clears stored BLE bonds/settings; flash to each half before
            # pairing a fresh board, then flash the real firmware over it.
            settingsReset = zmk-nix.legacyPackages.${system}.buildKeyboard {
                name = "settings-reset";
                src = ./lily58;
                board = "nice_nano//zmk";
                shield = "settings_reset";
                inherit zephyrDepsHash;
                inherit (firmware) westDeps;
            };

            # The same reset image under per-part names, so the flash script
            # prompts for each half in turn like it does for the real firmware.
            settingsResetSplit = pkgs.runCommand "settings-reset-split" {
                parts = [ "left" "right" ];
            } ''
                mkdir $out
                for part in $parts; do
                    ln -s ${settingsReset}/zmk.uf2 $out/zmk_"$part".uf2
                done
            '';

            # zmk-nix's flash script shells out to `udisksctl` but does not
            # include udisks in its runtimeInputs, so wrap it to guarantee it
            # is on PATH regardless of the ambient environment.
            mkFlash = name: firmware: pkgs.symlinkJoin {
                inherit name;
                paths = [ (zmk-nix.packages.${system}.flash.override { inherit firmware; }) ];
                buildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                    wrapProgram $out/bin/zmk-uf2-flash \
                        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.udisks ]}
                '';
                meta.mainProgram = "zmk-uf2-flash";
            };
        in
        {
            packages.zmk-firmware = firmware;
            packages.zmk-flash = mkFlash "lily58-flash" firmware;
            packages.zmk-settings-reset = settingsReset;
            packages.zmk-flash-reset = mkFlash "lily58-flash-reset" settingsResetSplit;
        };
}
