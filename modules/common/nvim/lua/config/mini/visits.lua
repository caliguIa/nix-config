require('mini.visits').setup()

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = 'core',
        sort = function(paths) return paths end,
    })
    if marked[index] then vim.cmd.edit(marked[index]) end
end

Util.map.n('ma', function() MiniVisits.add_label('core') end, 'Add mark')
Util.map.n('md', function() MiniVisits.remove_label('core') end, 'Delete mark')
Util.map.n('mq', function() goto_marked_file(1) end, 'Goto mark 1')
Util.map.n('mw', function() goto_marked_file(2) end, 'Goto mark 2')
Util.map.n('me', function() goto_marked_file(3) end, 'Goto mark 3')
Util.map.n('mr', function() goto_marked_file(4) end, 'Goto mark 4')
