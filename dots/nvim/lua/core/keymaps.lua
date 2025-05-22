local cmd = vim.cmd
local del = vim.keymap.del
local try_del = function(mode, keys) pcall(del, mode, keys) end

try_del("n", "grr")
try_del("n", "gra")
try_del("n", "gri")
try_del("n", "grn")

Util.map.nl("q", "q", "Macros", { remap = true })
-- Util.map.n("q", "<Nop>", "Disable macros")
Util.map.n("m", "<Nop>", "Disable marks")

Util.map.c("<C-p>", "<Up>", "Previous command")
Util.map.c("<C-n>", "<Down>", "Next command")

Util.map.x('"_x', "Delete character without copying")
Util.map.n("ycc", "yygccp", "Duplicate line and comment", { remap = true })

Util.map.nl("X", function() cmd("!chmod +x %") end, "Make file executable")

Util.map.n("<C-d>", "<C-d>zz", "Down half-page and center")
Util.map.n("<C-u>", "<C-u>zz", "Up half-page and center")

Util.map.n("<esc>", cmd.noh, "Escape and clear hlsearch")

Util.map.x("/", "<Esc>/\\%V")
Util.map.n("n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
Util.map.n("N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })

Util.map.i(",", ",<c-g>u", "Comma add undo break-point")
Util.map.i(".", ".<c-g>u", "Period add undo break-point")
Util.map.i(";", ";<c-g>u", "Semi-colon add undo break-point")

Util.map.v("<", "<gv", "Dedent reselect")
Util.map.v(">", ">gv", "Indent reselect")

Util.map.nl("fn", cmd.enew, "New File")

Util.map.nl("wd", "<C-W>c", "Delete Window", { remap = true })
Util.map.nl("w", "<c-w>", "Windows", { remap = true })
Util.map.nl("<tab>d", cmd.tabclose, "Close Tab")

Util.map.nl("sq", function()
    local cur_tabnr = vim.fn.tabpagenr()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then return vim.cmd("cclose") end
    end
    vim.cmd("copen")
end, "Quickfix List")
Util.map.n("[q", cmd.cprev, "Previous Quickfix")
Util.map.n("]q", cmd.cnext, "Next Quickfix")

Util.map.nl("<tab>]", cmd.tabnext, "Next")
Util.map.nl("<tab>[", cmd.tabprevious, "Previous")
Util.map.nl("<tab>d", cmd.tabclose, "Close current")
Util.map.nl("<tab>o", cmd.tabonly, "Close other")

Util.map.nl("ba", function() cmd.b("#") end, "Alternate")

Util.map.nl("u", cmd.UndotreeToggle, "Toggle undotree")

Util.map.n("<M-h>", cmd.TmuxNavigateLeft, "Tmux Navigate Left")
Util.map.n("<M-j>", cmd.TmuxNavigateDown, "Tmux Navigate Down")
Util.map.n("<M-k>", cmd.TmuxNavigateUp, "Tmux Navigate Up")
Util.map.n("<M-l>", cmd.TmuxNavigateRight, "Tmux Navigate Right")
