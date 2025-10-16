local C = {
    background = '#121212',
    alt_background = '#1A1A1A',
    primary = '#ff0088',
    secondary = '#d5d5d5',
    diagnostic_error = '#9B0837',
    diagnostic_warning = '#FFC857',
    diagnostic_info = '#FFC857',
    diagnostic_hint = '#576CA8',
    diff_add = '#586935',
    diff_change = '#51657B',
    diff_delete = '#984936',
    diff_add_bg = '#0C4531',
    diff_change_bg = '#10666A',
    diff_delete_bg = '#5C0A14',
    dull_0 = '#ffffff',
    dull_1 = '#f5f5f5',
    dull_2 = '#d5d5d5',
    dull_3 = '#b4b4b4',
    dull_4 = '#a7a7a7',
    dull_5 = '#949494',
    dull_6 = '#737373',
    dull_7 = '#535353',
    dull_8 = '#323232',
    dull_9 = '#212121',
    black = '#000000',
    white = '#FFFFFF',
}

vim.g.colors_name = 'llanura'

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end

local function highlight(group, opts) vim.api.nvim_set_hl(0, group, opts) end

-- Base highlights
highlight('Normal', { fg = C.dull_3, bg = C.background })
highlight('Search', { bg = C.dull_8 })
highlight('IncSearch', { fg = C.dull_0, bg = C.dull_7 })
highlight('Substitute', { bg = C.dull_8 })
highlight('CurSearch', { fg = C.dull_9, bg = C.dull_2 })
highlight('Visual', { bg = C.dull_8 })
highlight('SignColumn', { bg = C.background })
highlight('LineNr', { fg = C.dull_8, bg = C.background })
highlight('EndOfBuffer', { fg = C.dull_8 })

-- Syntax highlighting
highlight('Comment', { fg = C.dull_6 })
highlight('Constant', { fg = C.primary })
highlight('Character', { fg = C.dull_5 })
highlight('Identifier', { fg = C.dull_0 })
highlight('Statement', { fg = C.dull_1 })
highlight('PreProc', { fg = C.primary })
highlight('Type', { fg = C.secondary })
highlight('Special', { fg = C.dull_5 })
highlight('Error', { fg = C.primary })
highlight('Todo', { fg = C.primary, bg = C.dull_8 })
highlight('Function', { fg = C.dull_0 })

-- UI elements
highlight('ColorColumn', { bg = C.dull_8 })
highlight('Conceal', { fg = C.dull_7 })
highlight('Cursor', {})
highlight('CursorColumn', { bg = C.dull_9 })
highlight('CursorLine', { bg = C.dull_9 })
highlight('CursorLineNr', { fg = C.dull_6, bg = C.dull_9 })
highlight('Directory', { fg = C.dull_3 })
highlight('DiffAdd', { bg = C.diff_add_bg })
highlight('DiffChange', { bg = C.diff_change_bg })
highlight('DiffDelete', { bg = C.diff_delete_bg })
highlight('DiffText', { bg = C.diff_change_bg })
highlight('ErrorMsg', { fg = C.diagnostic_error })
highlight('VertSplit', { fg = C.dull_8, bg = C.dull_9 })
highlight('WinSeparator', { fg = C.dull_8, bg = C.dull_9 })

-- Additional UI elements
highlight('Folded', { fg = C.dull_5, bg = C.dull_8 })
highlight('FoldColumn', { fg = C.dull_7 })
highlight('MatchParen', { bg = C.dull_7 })
highlight('MoreMsg', { bg = C.background })
highlight('NonText', { fg = C.dull_8 })
highlight('Pmenu', { fg = C.dull_2, bg = C.dull_8 })
highlight('PmenuSel', { fg = C.dull_0, bg = C.dull_7 })
highlight('PmenuSbar', { bg = C.dull_8 })
highlight('PmenuThumb', { bg = C.dull_7 })
highlight('Question', { fg = C.dull_1, bg = C.dull_8 })
highlight('SpecialKey', { fg = C.dull_6 })
highlight('SpellBad', { fg = C.primary })
highlight('SpellCap', { fg = C.dull_0 })
highlight('SpellLocal', { fg = C.dull_5 })
highlight('SpellRare', { fg = C.primary })
highlight('StatusLine', { fg = C.dull_5, bg = C.dull_8 })
highlight('TabLine', { fg = C.dull_3, bg = C.dull_8 })
highlight('TabLineFill', { bg = C.dull_8 })
highlight('TabLineSel', { fg = C.dull_2 })
highlight('Title', { fg = C.dull_3 })
highlight('VisualNOS', { fg = C.primary, bg = C.dull_8 })
highlight('WarningMsg', { fg = C.primary })
highlight('WildMenu', { fg = C.dull_5, bg = C.dull_8 })

-- Float window elements
highlight('FloatBorder', { fg = C.dull_7 })
highlight('FloatTitle', { fg = C.dull_0 })
highlight('NormalFloat', { fg = C.dull_4, bg = C.alt_background })

-- Winbar
highlight('WinBar', { bg = C.background })
highlight('HanzelFile', { fg = C.dull_1 })
highlight('HanzelDirectory', { fg = C.dull_7 })
highlight('HanzelSeparator', { fg = C.dull_9 })
highlight('HanzelFileIcon', { fg = C.dull_2 })

-- Mini
highlight('MiniFilesNormal', { bg = C.background })
highlight('MiniPickNormal', { bg = C.background })
highlight('MiniStatuslineDevinfo', { bg = C.dull_9 })
highlight('MiniStatuslineModeNormal', { bg = C.dull_9 })
highlight('MiniStatuslineModeInsert', { bg = C.dull_9 })
highlight('MiniStatuslineModeVisual', { bg = C.dull_9 })
highlight('MiniStatuslineModeReplace', { bg = C.dull_9 })
highlight('MiniStatuslineModeCommand', { bg = C.dull_9 })
highlight('MiniStatuslineModeOther', { bg = C.dull_9 })
highlight('MiniSnippetsCurrent', { force = true })
highlight('MiniSnippetsCurrentReplace', { force = true })
highlight('MiniSnippetsFinal', { force = true })
highlight('MiniSnippetsUnvisited', { force = true })
highlight('MiniSnippetsVisited', { force = true })
highlight('MiniIndentscopeSymbol', { fg = C.dull_6 })
highlight('IndentLine', { fg = C.dull_8 })
highlight('IndentLineCurrent', { fg = C.dull_5 })

-- Treesitter syntax highlighting
highlight('@boolean', { fg = C.primary })
highlight('@character', { fg = C.secondary })
highlight('@character.special', { fg = C.dull_2 })
highlight('@comment', { fg = C.dull_6 })
highlight('@conditional', { fg = C.dull_2 })
highlight('@constant', { fg = C.dull_2 })
highlight('@constant.builtin', { fg = C.dull_2 })
highlight('@constant.macro', { fg = C.primary })
highlight('@constructor', { fg = C.dull_1 })
highlight('@debug', { fg = C.dull_2 })
highlight('@define', { fg = C.dull_2 })
highlight('@exception', { fg = C.dull_2 })
highlight('@field', { fg = C.dull_2 })
highlight('@float', { fg = C.dull_2 })
highlight('@function', { fg = C.dull_0 })
highlight('@function.builtin', { fg = C.dull_2 })
highlight('@function.call', { fg = C.dull_2 })
highlight('@function.macro', { fg = C.primary })
highlight('@include', { fg = C.dull_6 })
highlight('@keyword', { fg = C.dull_5 })
highlight('@keyword.function', { fg = C.dull_5 })
highlight('@keyword.operator', { fg = C.dull_6 })
highlight('@keyword.return', { fg = C.dull_0 })
highlight('@label', { fg = C.dull_2 })
highlight('@macro', { fg = C.primary })
highlight('@method', { fg = C.dull_1 })
highlight('@method.call', { fg = C.dull_2 })
highlight('@namespace', { fg = C.dull_2 })
highlight('@none', { fg = C.dull_3 })
highlight('@number', { fg = C.primary })
highlight('@operator', { fg = C.dull_6 })
highlight('@parameter', { fg = C.dull_2 })
highlight('@preproc', { fg = C.dull_2 })
highlight('@property', { fg = C.dull_2 })
highlight('@punctuation', { fg = C.dull_2 })
highlight('@punctuation.bracket', { fg = C.dull_6 })
highlight('@punctuation.delimiter', { fg = C.dull_6 })
highlight('@punctuation.special', { fg = C.primary })
highlight('@repeat', { fg = C.dull_2 })
highlight('@storageclass', { fg = C.dull_2 })
highlight('@string', { fg = C.primary })
highlight('@string.escape', { fg = C.dull_2 })
highlight('@string.special', { fg = C.dull_2 })
highlight('@structure', { fg = C.dull_2 })
highlight('@tag', { fg = C.dull_6 })
highlight('@tag.attribute', { fg = C.dull_4 })
highlight('@tag.delimiter', { fg = C.dull_3 })
highlight('@text.literal', { fg = C.secondary })
highlight('@text.reference', { fg = C.secondary })
highlight('@text.title', { fg = C.dull_2 })
highlight('@text.todo', { fg = C.dull_2 })
highlight('@text.underline', { fg = C.dull_2 })
highlight('@text.uri', { fg = C.dull_2 })
highlight('@type', { fg = C.dull_2 })
highlight('@identifier', { fg = C.dull_0 })
highlight('@type.builtin', { fg = C.dull_6 })
highlight('@type.definition', { fg = C.dull_2 })
highlight('@variable', { fg = C.secondary })
highlight('@variable.builtin', { fg = C.dull_2 })
highlight('@lsp.type.function', { fg = C.dull_0 })
highlight('@lsp.type.macro', { fg = C.primary })
highlight('@lsp.type.method', { fg = C.dull_2 })

-- Diagnostics
highlight('DiagnosticError', { fg = C.diagnostic_error })
highlight('DiagnosticWarn', { fg = C.diagnostic_warning })
highlight('DiagnosticInfo', { fg = C.diagnostic_info })
highlight('DiagnosticHint', { fg = C.diagnostic_hint })
highlight('DiagnosticSignError', { fg = C.diagnostic_error })
highlight('DiagnosticSignWarn', { fg = C.diagnostic_warning })
highlight('DiagnosticSignInfo', { fg = C.diagnostic_info })
highlight('DiagnosticSignHint', { fg = C.diagnostic_hint })
-- Special handling for underline styles
highlight('DiagnosticUnderlineError', { sp = C.diagnostic_error, undercurl = true })
highlight('DiagnosticUnderlineWarn', { sp = C.diagnostic_warning, undercurl = true })
highlight('DiagnosticUnderlineInfo', { sp = C.diagnostic_info, undercurl = true })
highlight('DiagnosticUnderlineHint', { sp = C.diagnostic_hint, undercurl = true })

-- Git diffs
highlight('DiffAdd', { fg = C.diff_add })
highlight('DiffChange', { fg = C.diff_change })
highlight('DiffDelete', { fg = C.diff_delete })
