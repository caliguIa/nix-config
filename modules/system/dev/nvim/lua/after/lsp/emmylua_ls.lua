---@type vim.lsp.Config
return {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
            then
                client.config.settings = {}
            end
        end
    end,
    settings = {
        emmylua = {
            diagnostics = { globals = { 'vim' } },
            runtime = { version = 'LuaJIT' },
            semanticTokens = { enable = true },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
                    -- vim.api.nvim_get_runtime_file('lua/mini', false)[1],
                },
            },
        },
    },
}
