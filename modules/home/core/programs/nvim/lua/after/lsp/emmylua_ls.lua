local function get_plugin_lua_paths()
    local packpath = vim.env.NVIM_PACKPATH
    if not packpath then return {} end

    local start_path = packpath .. '/pack/nvim/start'
    local handle = vim.uv.fs_scandir(start_path)
    if not handle then return {} end

    local lua_paths = {}
    for name, type in vim.uv.fs_scandir_next, handle do
        if type == 'directory' or type == 'link' then
            local lua_dir = start_path .. '/' .. name .. '/lua'
            if vim.uv.fs_stat(lua_dir) then lua_paths[#lua_paths + 1] = lua_dir end
        end
    end

    return lua_paths
end

---@type vim.lsp.Config
return {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
        Lua = {
            completion = {
                enable = true,
                autoRequire = true,
                autoRequireFunction = 'require',
                autoRequireNamingConvention = 'keep',
                autoRequireSeparator = '.',
                callSnippet = false,
                postfix = '@',
                baseFunctionIncludesName = true,
            },
            codeLens = { enable = true },
            doc = { syntax = 'md' },
            hint = {
                enable = true,
                paramHint = true,
                indexHint = true,
                localHint = true,
                overrideHint = true,
                metaCallHint = true,
            },
            inlineValues = { enable = true },
            runtime = {
                version = 'LuaJIT',
                requirePattern = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                    '?/lua/?.lua',
                    '?/lua/?/init.lua',
                },
            },
            semanticTokens = { enable = true },
            signature = { detailSignatureHelper = true },
            strict = {
                requirePath = true,
                typeCall = true,
                arrayIndex = true,
                metaOverrideFileDefine = true,
                docBaseConstMatchBaseType = true,
            },
            workspace = {
                library = vim.list_extend({
                    '$VIMRUNTIME',
                }, get_plugin_lua_paths()),
                ignoreGlobs = { '**/*_spec.lua' },
            },
        },
    },
}
