{
    # Self-contained Lua modules (logic, not config): placed under plugin/ and
    # auto-sourced by neovim after init.lua has run vim.pack.add. Each is
    # luacheck-validated at build time by the extraFiles machinery.
    flake.modules.hjem.nvim-module = {
        programs.nvim-module.extraFiles = {
            "plugin/git.lua" = ./lua/plugin/git.lua;
            "plugin/lsp.lua" = ./lua/plugin/lsp.lua;
            "plugin/vim-test.lua" = ./lua/plugin/vim-test.lua;
            "plugin/usercmds.lua" = ./lua/plugin/usercmds.lua;
            "plugin/artisan.lua" = ./lua/plugin/artisan.lua;

            "plugin/mini/ai.lua" = ./lua/mini/ai.lua;
            "plugin/mini/bufremove.lua" = ./lua/mini/bufremove.lua;
            "plugin/mini/clue.lua" = ./lua/mini/clue.lua;
            "plugin/mini/completion.lua" = ./lua/mini/completion.lua;
            "plugin/mini/diff.lua" = ./lua/mini/diff.lua;
            "plugin/mini/extra.lua" = ./lua/mini/extra.lua;
            "plugin/mini/icons.lua" = ./lua/mini/icons.lua;
            "plugin/mini/indentscope.lua" = ./lua/mini/indentscope.lua;
            "plugin/mini/input.lua" = ./lua/mini/input.lua;
            "plugin/mini/jump.lua" = ./lua/mini/jump.lua;
            "plugin/mini/pick.lua" = ./lua/mini/pick.lua;
            "plugin/mini/statusline.lua" = ./lua/mini/statusline.lua;

            # Experimental message-UI setup (logic).
            "plugin/ui.lua" = ./lua/plugin/ui.lua;

            # Logic-heavy ftplugins.
            "after/ftplugin/markdown.lua" = ./lua/ftplugin/markdown.lua;
            "after/ftplugin/sql.lua" = ./lua/ftplugin/sql.lua;
            "after/ftplugin/sqls_output.lua" = ./lua/ftplugin/sqls_output.lua;

            # Logic-heavy LSP configs (functions / computed paths).
            "after/lsp/nixd.lua" = ./lua/lsp/nixd.lua;
            "after/lsp/emmylua_ls.lua" = ./lua/lsp/emmylua_ls.lua;
        };
    };
}
