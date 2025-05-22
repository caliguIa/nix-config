return {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            diagnostics = { workspaceDelay = -1 },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                ignoreSubmodules = true,
            },
            telemetry = { enable = false },
        },
    },
}
