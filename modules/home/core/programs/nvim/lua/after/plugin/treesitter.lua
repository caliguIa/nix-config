require('nvim-treesitter.configs').setup({
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = true },
    highlight = { enable = true },
})
require('ts-comments').setup()
require('nvim-ts-autotag').setup()
require('timber').setup({
    log_templates = {
        default = {
            php = [[dump("%log_target", %log_target);]],
        },
        plain = {
            php = [[dump(%insert_cursor);]],
        },
        batch_log_templates = {
            default = {
                php = [[dump(%repeat<"%log_target", %log_target>);]],
            },
        },
    },
})
