{inputs, ...}: {
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.neovim = {
            enable = true;
            package = inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
            withPython3 = false;
            withRuby = false;
        };
        home.packages = with pkgs; [
            tree-sitter
            gcc
            # mago
            (pkgs.stdenvNoCC.mkDerivation rec {
                pname = "mago";
                version = "1.30.0";
                src = pkgs.fetchurl {
                    url = "https://github.com/carthage-software/mago/releases/download/${version}/mago-${version}-x86_64-unknown-linux-musl.tar.gz";
                    hash = "sha256-u/UkBh6GhMTgzVwiBugGkvZsxXe6OotsRHDpEgNgxjw=";
                };
                installPhase = ''
                    runHook preInstall
                    install -Dm755 mago "$out/bin/mago"
                    runHook postInstall
                '';
            })
            inputs.phpantom-lsp.packages.${pkgs.stdenvNoCC.system}.phpantom-lsp
        ];
        xdg.desktopEntries.nvim = {
            name = "Neovim";
            genericName = "Text Editor";
            comment = "Edit text files";
            exec = "${pkgs.kitty}/bin/kitty -e nvim %F";
            type = "Application";
            icon = "nvim";
            terminal = false;
            categories = ["Utility" "TextEditor"];
            mimeType = ["text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++"];
        };
    };
}
