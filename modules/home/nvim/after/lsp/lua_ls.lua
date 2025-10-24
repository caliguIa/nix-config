---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
            diagnostics = {
                workspaceDelay = -1,
                globals = {
                    'nixCats',
                    'MiniStatusline',
                    'MiniExtra',
                    'MiniBufremove',
                    'MiniCompletion',
                    'MiniDiff',
                    'MiniMisc',
                    'MiniIcons',
                    'MiniPick',
                    'Zendiagram',
                },
                disable = { 'missing-fields' },
            },
            workspace = {
                ignoreSubmodules = true,
                library = { vim.env.VIMRUNTIME },
            },
            signatureHelp = { enabled = true },
            telemetry = { enable = false },
        },
    },
}
