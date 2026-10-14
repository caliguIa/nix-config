-- stylua: ignore
require('nvim-treesitter').install({
    'bash', 'css', 'fish', 'go', 'html', 'javascript', 'json', 'jsx', 'lua',
    'markdown', 'markdown_inline', 'nix', 'nu', 'php', 'rust', 'scss', 'toml',
    'tsx', 'typescript', 'yaml', 'zig', 'zsh',
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
    callback = function(ev)
        if ev.match == '' or ev.match == 'text' then
            vim.treesitter.stop(ev.buf)
            return
        end
        if not pcall(vim.treesitter.start, ev.buf) then return end

        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'

        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.query.get(lang, 'indents') then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
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
require('nvim-ts-autotag').setup()
