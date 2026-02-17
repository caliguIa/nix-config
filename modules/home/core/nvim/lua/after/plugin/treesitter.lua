--stylua: ignore
local ensure_languages = {
    'bash', 'c',          'cpp',  'css',   'diff', 'go', 'jsx',
    'html', 'javascript', 'json', 'julia', 'nu',   'php', 'python',
    'r',    'regex',      'rst',  'rust',  'toml', 'tsx', 'typescript', 'yaml',
}
local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_languages)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end
local filetypes = vim.iter(ensure_languages):map(vim.treesitter.language.get_filetypes):flatten():totable()
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
    pattern = filetypes,
    desc = 'Ensure enabled tree-sitter',
    callback = function(ev) vim.treesitter.start(ev.buf) end,
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
