require("e-ink").setup()

vim.cmd.colorscheme("e-ink")
vim.opt.background = "light"

local C = require("e-ink.palette").everforest()
local function highlight(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end
highlight("DiagnosticUnderlineError", { sp = C.red, undercurl = true })
highlight("DiagnosticUnderlineWarn", { sp = C.yellow, undercurl = true })
highlight("DiagnosticUnderlineInfo", { sp = C.blue, undercurl = true })
highlight("DiagnosticUnderlineHint", { sp = C.blue, undercurl = true })
-- highlight("DiffAdd", { bg = everforest.bg_green })
-- highlight("DiffChange", { bg = everforest.bg_blue })
-- highlight("DiffDelete", { bg = everforest.bg_red })
-- highlight("DiffText", { fg = mono[1], bg = everforest.blue })
highlight("diffAdded", { link = "DiffAdd" })
highlight("diffChanged", { link = "DiffChange" })
highlight("diffRemoved", { link = "DiffDelete" })
highlight("@diff.plus", { link = "DiffAdd" })
highlight("@diff.delta", { link = "DiffChange" })
highlight("@diff.minus", { link = "DiffDelete" })

-- vim.cmd.colorscheme("llanura")
