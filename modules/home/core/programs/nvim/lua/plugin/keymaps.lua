local cmd = vim.cmd
vim.keymap.set({ 'i', 'v', 'x' }, '<C-[>', '<Esc>', { desc = 'Exit mode', silent = true })
vim.keymap.set('n', '<leader>X', function() cmd('!chmod +x %') end, { desc = 'Make file executable', silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Down half-page and center', silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Up half-page and center', silent = true })
vim.keymap.set('n', '<esc>', cmd.noh, { desc = 'Escape and clear hlsearch', silent = true })
vim.keymap.set('x', '/', '<Esc>/\\%V', { silent = true })
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { desc = 'Next Search Result', silent = true, expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { desc = 'Prev Search Result', silent = true, expr = true })
vim.keymap.set('i', ',', ',<c-g>u', { desc = 'Comma add undo break-point', silent = true })
vim.keymap.set('i', '.', '.<c-g>u', { desc = 'Period add undo break-point', silent = true })
vim.keymap.set('i', ';', ';<c-g>u', { desc = 'Semi-colon add undo break-point', silent = true })
vim.keymap.set('v', '<', '<gv', { desc = 'Dedent reselect', silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent reselect', silent = true })
vim.keymap.set('n', '<leader>fn', cmd.enew, { desc = 'New File', silent = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', silent = true, remap = true })
vim.keymap.set('n', '<leader>w', '<c-w>', { desc = 'Windows', silent = true, remap = true })
vim.keymap.set('n', '<leader>co', function()
    local cur_tabnr = vim.fn.tabpagenr()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then return cmd('cclose') end
    end
    cmd('copen')
end, { desc = 'Quickfix List', silent = true })
vim.keymap.set('n', '<leader><tab>]', cmd.tabnext, { desc = 'Next', silent = true })
vim.keymap.set('n', '<leader><tab>[', cmd.tabprevious, { desc = 'Previous', silent = true })
vim.keymap.set('n', '<leader><tab>d', cmd.tabclose, { desc = 'Close current', silent = true })
vim.keymap.set('n', '<leader><tab>o', cmd.tabonly, { desc = 'Close other', silent = true })
vim.keymap.set('n', '<leader>ba', function() cmd.b('#') end, { desc = 'Alternate', silent = true })
vim.keymap.set('n', 'j', 'gj', { desc = 'Navigate through wrapped lines', silent = true })
vim.keymap.set('n', 'k', 'gk', { desc = 'Navigate through wrapped lines', silent = true })

function _G.FuzzyFindFunc(cmdarg, cmdcomplete)
    return vim.fn.systemlist("fd --hidden . | fzf --filter='" .. cmdarg .. "'")
end
if vim.fn.executable('fd') == 1 and vim.fn.executable('fzf') == 1 then vim.o.findfunc = 'v:lua.FuzzyFindFunc' end
vim.keymap.set('n', '<leader>ff', ':find ', { desc = 'Find files', silent = true })
