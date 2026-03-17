local statusline = require('mini.statusline')

statusline.section_fileinfo = function() return vim.bo.filetype end
statusline.section_location = function() return '%p%% %L' end
statusline.section_filename = function()
    vim.api.nvim_set_hl(0, 'MiniStatuslineSeparator', {
        fg = '#4B4F52',
    })

    local parts = vim.split(vim.fn.expand('%'), '/', { plain = true })
    if #parts == 1 then return parts[1] end

    local result = {}
    for i, part in ipairs(parts) do
        if i == #parts then
            table.insert(result, '%#Bold#' .. part .. '%')
        else
            table.insert(result, part)
        end
        if i < #parts then table.insert(result, ' %#MiniStatuslineSeparator#%#Normal# ') end
    end
    return '   ' .. table.concat(result, '')
end

statusline.setup({
    content = {

        active = function()
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local filename = statusline.section_filename()
            local fileinfo = statusline.section_fileinfo()
            local branch = vim.g.git_branch ~= '' and ('󰊢  ' .. vim.g.git_branch) or ''
            local location = statusline.section_location()
            local search = statusline.section_searchcount({ trunc_width = 75 })
            return statusline.combine_groups({
                { hl = 'Normal', strings = { branch } },
                { hl = 'Normal', strings = { filename } },
                '%=', -- End left alignment
                { hl = 'Normal', strings = { diagnostics } },
                { hl = 'Normal', strings = { search, location } },
                { hl = 'Normal', strings = { fileinfo } },
            })
        end,
        inactive = function()
            local filename = statusline.section_filename()
            return statusline.combine_groups({
                { strings = { filename } },
            })
        end,
    },
})
