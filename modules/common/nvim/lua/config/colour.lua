require("e-ink").setup()

vim.cmd.colorscheme("e-ink")
vim.opt.background = "dark"

local C = require("e-ink.palette").everforest()
local P = require("e-ink.palette").mono()
local function highlight(group, opts) vim.api.nvim_set_hl(0, group, opts) end
highlight("WinBar", { bg = P[0] })
highlight("WinBarNC", { bg = P[0] })
highlight("DiagnosticUnderlineError", { sp = C.red, undercurl = true })
highlight("DiagnosticUnderlineWarn", { sp = C.yellow, undercurl = true })
highlight("DiagnosticUnderlineInfo", { sp = C.blue, undercurl = true })
highlight("DiagnosticUnderlineHint", { sp = C.blue, undercurl = true })
highlight("diffAdded", { link = "DiffAdd" })
highlight("diffChanged", { link = "DiffChange" })
highlight("diffRemoved", { link = "DiffDelete" })
highlight("@diff.plus", { link = "DiffAdd" })
highlight("@diff.delta", { link = "DiffChange" })
highlight("@diff.minus", { link = "DiffDelete" })

-- vim.cmd.colorscheme("llanura")
