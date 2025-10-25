local dev_path = vim.fn.expand('~/dev/nvim-plugins')

local function use_local_plugin(name)
    local plugin_path = dev_path .. '/' .. name
    vim.opt.runtimepath:prepend(plugin_path)

    local plugin_file = plugin_path .. '/plugin/' .. name:gsub('%.nvim$', '') .. '.lua'
    if vim.fn.filereadable(plugin_file) == 1 then vim.cmd('source ' .. plugin_file) end
end

use_local_plugin('timber.nvim')
-- use_local_plugin('zendiagram.nvim')

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
require('zendiagram').setup()
vim.diagnostic.open_float = Zendiagram.open
