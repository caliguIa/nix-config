{pkgs, ...}: {
    programs.helix = {
        enable = true;
        settings = {
            theme = "base16";
            editor = {
                line-number = "relative";
                lsp.display-messages = true;
            };
            keys.normal = {
                esc = ["collapse_selection" "keep_primary_selection"];
            };
        };
        languages = {
            language-server."typescript-language-server" = {
                command = "typescript-language-server";
                args = ["--stdio"];
            };
            language-server.intelephense = {
                command = "intelephense";
                args = ["--stdio"];
            };
            language = [
                {
                    name = "typescript";
                    language-servers = ["vtsls"];
                }
            ];
        };
        extraPackages = with pkgs; [
            lua-language-server
            marksman
            nixd
            taplo
            just-lsp
            vscode-langservers-extracted
            nodePackages.bash-language-server
            alejandra
            sleek
            stylua
        ];
    };
}
