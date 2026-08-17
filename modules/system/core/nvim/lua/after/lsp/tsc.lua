---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = 'tsc'
        local bins = { 'tsgo' }
        for _, bin in ipairs(bins) do
            if (config or {}).root_dir then
                local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', bin)
                if vim.fn.executable(local_cmd) == 1 then
                    cmd = local_cmd
                    break
                end
            end
            if vim.fn.executable(bin) == 1 then
                cmd = bin
                break
            end
        end
        return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
    end,
    settings = {
        complete_function_calls = true,
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
            },
        },
    },
}
