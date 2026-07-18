{
    flake.meta.nvimExtraPackages = pkgs:
        with pkgs; [
            # lsp
            emmylua-ls
            nixd
            taplo
            bash-language-server
            # formatter
            alejandra
            stylua
        ];

    flake.modules.hjem.core = {pkgs, ...}: {
        packages = with pkgs; [
            tree-sitter
            gcc
        ];
    };
}
