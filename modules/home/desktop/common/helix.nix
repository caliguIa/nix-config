{
    flake.modules.homeManager.desktop-common-helix = {pkgs, ...}: {
        stylix.targets.helix.enable = true;
        programs.helix = {
            enable = true;
            settings = {
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
            extraPackages = [
                pkgs.lua-language-server
                pkgs.marksman
                pkgs.nixd
                pkgs.taplo
                pkgs.just-lsp
                pkgs.vscode-langservers-extracted
                pkgs.nodePackages.bash-language-server
                pkgs.alejandra
                pkgs.sleek
                pkgs.stylua
            ];
        };
    };
}
