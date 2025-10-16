local statusline = require('mini.statusline')

statusline.section_fileinfo = function() return vim.bo.filetype end
statusline.section_location = function() return '%p%% %L' end
statusline.section_filename = function()
    vim.api.nvim_set_hl(0, 'MiniStatuslineSeparator', {
        fg = '#4B4F52',
        bg = '#1f1f26',
    })

    local parts = vim.split(vim.fn.expand('%'), '/', { plain = true })
    if #parts == 1 then return parts[1] end

    local result = {}
    for i, part in ipairs(parts) do
        table.insert(result, part)
        if i < #parts then table.insert(result, ' %#MiniStatuslineSeparator#%#MiniStatuslineDevinfo# ') end
    end
    return table.concat(result, '')
end

statusline.setup({
    content = {

        active = function()
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 75 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 75, icon = '' })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            return MiniStatusline.combine_groups({
                { hl = 'MiniStatuslineDevinfo', strings = { git } },
                { hl = 'MiniStatuslineDevinfo', strings = { filename } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineDevinfo', strings = { diagnostics } },
                { hl = 'MiniStatuslineDevinfo', strings = { search, location } },
                { hl = 'MiniStatuslineDevinfo', strings = { fileinfo } },
            })
        end,
        inactive = function()
            local filename = MiniStatusline.section_filename({ trunc_width = 80 })
            return MiniStatusline.combine_groups({
                { strings = { filename } },
            })
        end,
    },
})
