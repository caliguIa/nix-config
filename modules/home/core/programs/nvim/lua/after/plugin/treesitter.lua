local filetype_ignore = {
    'fff_input',
    'fff_preview',
    'fff_list',
    'cmd',
    'dialog',
    'msg',
    'pager',
}

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
    desc = 'Enable treesitter highlighting and indentation',
    callback = function(ev)
        if vim.tbl_contains(filetype_ignore, ev.match) then return end

        local lang = vim.treesitter.language.get_lang(ev.match)
        local is_installed = #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) > 0
        if not is_installed then require('nvim-treesitter').install({ lang }) end
        local ok = pcall(vim.treesitter.start, ev.buf, lang)
        if ok then vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end,
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
