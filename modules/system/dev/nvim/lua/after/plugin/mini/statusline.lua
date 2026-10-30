local statusline = require('mini.statusline')

statusline.section_fileinfo = function() return vim.bo.filetype end
statusline.section_location = function() return '%p%% %L' end
statusline.section_filename = function()
    local parts = vim.split(vim.fn.expand('%'), '/', { plain = true })
    if #parts == 1 then return parts[1] end

    local result = {}
    for i, part in ipairs(parts) do
        if i == #parts then
            table.insert(result, '%#MiniStatuslineFilename#' .. part .. '%')
        else
            table.insert(result, part)
        end
        if i < #parts then table.insert(result, '%#MiniStatuslineSeparator#  %#MiniStatuslineFileinfo#') end
    end
    return '%#MiniStatuslineFilename#  %#MiniStatuslineFileinfo#' .. table.concat(result, '')
end

local diagnostic_icons = {
    { severities = { vim.diagnostic.severity.ERROR }, icon = '', hl = 'MiniStatuslineDiagnosticError' },
    { severities = { vim.diagnostic.severity.WARN }, icon = '', hl = 'MiniStatuslineDiagnosticWarn' },
    {
        severities = { vim.diagnostic.severity.INFO, vim.diagnostic.severity.HINT },
        icon = '',
        hl = 'MiniStatuslineDiagnosticInfo',
    },
}

statusline.section_diagnostics = function(args)
    if statusline.is_truncated(args.trunc_width) then return '' end

    local counts = vim.diagnostic.count(0)
    local result = {}
    for _, d in ipairs(diagnostic_icons) do
        for _, severity in ipairs(d.severities) do
            if (counts[severity] or 0) > 0 then
                table.insert(result, '%#' .. d.hl .. '#' .. d.icon)
                break
            end
        end
    end
    return table.concat(result, ' ')
end

statusline.setup({
    content = {

        active = function()
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local filename = statusline.section_filename()
            local fileinfo = statusline.section_fileinfo()
            local branch = vim.g.git_branch ~= ''
                    and ('%#MiniStatuslineGitIcon#󰊢  %#MiniStatuslineBold#' .. vim.g.git_branch)
                or ''
            local location = statusline.section_location()
            local search = statusline.section_searchcount({ trunc_width = 75 })
            return statusline.combine_groups({
                { strings = { branch } },
                { strings = { filename } },
                '%=', -- End left alignment
                { strings = { diagnostics } },
                { hl = 'MiniStatuslineNormal', strings = { search, location, fileinfo } },
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
