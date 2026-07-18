{config, ...}: let
    users = config.flake.meta.users;
    home = "/home/${users.primary}";
in {
    flake.modules.hjem.core = {pkgs, ...}: let
        # Assemble bat's custom assets (themes + syntaxes) into one source tree.
        # The ghostty syntax was previously provided by home-manager's ghostty
        # `installBatSyntax`; we vendor it directly from the ghostty package.
        batSrc = pkgs.symlinkJoin {
            name = "bat-src";
            paths = [
                (pkgs.runCommand "bat-assets" {} ''
                    mkdir -p $out/themes $out/syntaxes
                    cp ${./bat/themes/kanso-zen.tmTheme} $out/themes/kanso-zen.tmTheme
                    cp ${./bat/syntaxes/PHP-Inline.sublime-syntax} $out/syntaxes/PHP-Inline.sublime-syntax
                    cp ${pkgs.ghostty}/share/bat/syntaxes/ghostty.sublime-syntax $out/syntaxes/ghostty.sublime-syntax
                '')
            ];
        };

        # Prebuild bat's cache so custom themes/syntaxes are registered without
        # an activation-time `bat cache --build`.
        batCache = pkgs.runCommand "bat-cache" {nativeBuildInputs = [pkgs.bat];} ''
            mkdir -p $out
            bat cache --build --source ${batSrc} --target $out --blank
        '';

        bat = pkgs.symlinkJoin {
            name = "bat-with-cache";
            paths = [pkgs.bat];
            nativeBuildInputs = [pkgs.makeWrapper];
            postBuild = ''
                wrapProgram $out/bin/bat --set BAT_CACHE_PATH ${batCache}
            '';
        };
    in {
        packages = [bat];
        xdg.config.files."bat/config".text = ''
            --map-syntax=${home}/.config/ghostty/config:Ghostty Config
            --theme=kanso-zen
        '';
    };
}
