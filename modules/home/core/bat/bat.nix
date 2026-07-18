{
    flake.modules.hjem.core = {pkgs, ...}: let
        batSrc = pkgs.runCommand "bat-src" {} ''
            mkdir -p $out/themes $out/syntaxes
            cp ${./themes/kanso-zen.tmTheme} $out/themes/kanso-zen.tmTheme
            cp ${./syntaxes/PHP-Inline.sublime-syntax} $out/syntaxes/PHP-Inline.sublime-syntax
        '';

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
