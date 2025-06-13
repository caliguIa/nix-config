local snippets = require('mini.snippets')
snippets.setup({
    snippets = { snippets.gen_loader.from_lang() },
    expand = {
        prepare = nil,
        match = nil,
        select = nil,
        insert = function(snippet)
            return snippets.default_insert(snippet, { empty_tabstop = '', empty_tabstop_final = '' })
        end,
    },
})
local function highlight(group, opts) vim.api.nvim_set_hl(0, group, opts) end
highlight('MiniSnippetsCurrent', { force = true })
highlight('MiniSnippetsCurrentReplace', { force = true })
highlight('MiniSnippetsFinal', { force = true })
highlight('MiniSnippetsUnvisited', { force = true })
highlight('MiniSnippetsVisited', { force = true })
