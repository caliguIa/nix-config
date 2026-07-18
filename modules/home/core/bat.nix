{
    flake.modules.hjem.core = {pkgs, ...}: let
        # Custom bat assets (theme + php-inline syntax) assembled into one tree.
        batSrc = pkgs.runCommand "bat-src" {} ''
            mkdir -p $out/themes $out/syntaxes
            cp ${./bat/themes/kanso-zen.tmTheme} $out/themes/kanso-zen.tmTheme
            cp ${./bat/syntaxes/PHP-Inline.sublime-syntax} $out/syntaxes/PHP-Inline.sublime-syntax
        '';

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
            --theme=kanso-zen
        '';
    };
}
