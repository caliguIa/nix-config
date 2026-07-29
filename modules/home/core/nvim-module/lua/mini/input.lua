require('mini.input').setup()

-- Construct reusable `MiniInput.get()` options
local cmdline_opts = { prompt = 'Command', scope = 'editor' }
-- - Highlight using bundled Vim tree-sitter parser and default handler
local highlight_vim = MiniInput.gen_highlight.treesitter('vim')
local highlight_cmdline = function(state)
    state = highlight_vim(state) or state
    return MiniInput.default_highlight(state) or state
end
cmdline_opts.handlers = { highlight = highlight_cmdline }
-- - Complete as if it is Command line input
cmdline_opts.completion = 'cmdline'

-- Create a mapping for `:`
local input_cmdline = function()
    local cmd = MiniInput.get(cmdline_opts)
    if cmd ~= nil then vim.cmd(cmd) end
end
vim.keymap.set('n', ':', input_cmdline)
