vim.opt_local.commentstring = '-- %s'

local get_query = function()
    local ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()

    local last_statement = nil
    while current_node do
        if current_node:type() == 'statement' then last_statement = current_node end
        if current_node:type() == 'program' then break end
        current_node = current_node:parent()
    end

    if not last_statement then return '' end

    local srow, scol, erow, ecol = vim.treesitter.get_node_range(last_statement)
    local selection = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol, {})
    return table.concat(selection, '\n')
end

Util.map.nl(
    'dr',
    function() vim.api.nvim_command(string.format('Dbee execute %s', get_query())) end,
    'Run query under cursor',
    { buffer = true }
)
