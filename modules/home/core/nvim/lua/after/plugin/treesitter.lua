vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
    pattern = nil,
    callback = function(ev)
        if not ev.match or ev.match == '' or ev.match == 'text' then vim.treesitter.stop() end
        pcall(function() vim.treesitter.start() end)
    end,
})

require('ts-comments').setup()
require('timber').setup({
    log_templates = {
        default = {
            php = [[dd('%log_target', %log_target);]],
        },
        plain = {
            php = [[dd(%insert_cursor);]],
        },
        batch_log_templates = {
            default = {
                php = [[dd(%repeat<'%log_target', %log_target>);]],
            },
        },
    },
})
require('treesitter-context').setup({
    max_lines = 4,
})
