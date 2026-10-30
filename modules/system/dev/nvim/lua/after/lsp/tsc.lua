---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        -- NVIM_TSC is set by the nix wrapper to nixpkgs' tsc (7.x); a bare `tsc`
        -- may resolve to a project's typescript 5.x, which has no --lsp.
        local cmd = vim.env.NVIM_TSC or 'tsc'
        local root = (config or {}).root_dir
        local local_tsgo = root and vim.fs.joinpath(root, 'node_modules/.bin/tsgo')
        if local_tsgo and vim.fn.executable(local_tsgo) == 1 then
            cmd = local_tsgo
        elseif vim.fn.executable('tsgo') == 1 then
            cmd = 'tsgo'
        end
        return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
    end,
    -- lspconfig's root_dir refuses to attach unless a tsc/tsgo >= 7 is found in
    -- node_modules/.bin or on PATH, ignoring cmd. Same root detection, minus that check.
    root_dir = function(bufnr, on_dir)
        local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        local project_root = vim.fs.root(bufnr, { lockfiles, { '.git' } })
        local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
        local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
        if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then return end
        if deno_root and (not project_root or #deno_root >= #project_root) then return end
        on_dir(project_root or vim.fn.getcwd())
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
