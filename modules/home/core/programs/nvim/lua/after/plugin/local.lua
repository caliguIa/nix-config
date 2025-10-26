local dev_path = string.format('%s/dev/nvim-plugins/', vim.env.HOME)
local function add_local_plugin(name) vim.opt.runtimepath:prepend(string.format('%s%s', dev_path, name)) end

add_local_plugin('timber.nvim')
-- add_local_plugin('zendiagram.nvim')
