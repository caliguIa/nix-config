vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

return {
    settings = {
        zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
        },
    },
}
