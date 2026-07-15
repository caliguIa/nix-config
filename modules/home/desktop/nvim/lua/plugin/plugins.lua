local add = vim.pack.add

add({
	"gh:windwp/nvim-ts-autotag",
	"gh:stevearc/aerial.nvim",
	"gh:vim-test/vim-test",
	"gh:niekdomi/conflict.nvim",
	"gh:justinmk/guh.nvim",
})

-- On-demand plugins, not loaded until ":packadd …".
add({
	"gh:MeanderingProgrammer/render-markdown.nvim",
}, {
	load = function() end,
})

local dev_path = string.format("%s/dev/nvim-plugins/", vim.env.HOME)
local function add_local_plugin(name)
	vim.opt.runtimepath:prepend(string.format("%s%s", dev_path, name))
end
