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
            mago
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
