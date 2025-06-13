require('mini.diff').setup({
    view = {
        style = 'sign',
        signs = { add = '▎', change = '▎', delete = '' },
    },
})
Util.map.nl('go', function() MiniDiff.toggle_overlay(0) end, 'Diff overlay')
