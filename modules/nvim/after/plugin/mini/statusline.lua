local statusline = require('mini.statusline')

statusline.section_fileinfo = function() return vim.bo.filetype end
statusline.section_location = function() return '%p%% %L' end
statusline.section_filename = function() return '%f' end

statusline.setup({
    content = {

        active = function()
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 75 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            return MiniStatusline.combine_groups({
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
                { hl = 'MiniStatuslineDevinfo', strings = { filename } },
            })
        end,
    },
})
