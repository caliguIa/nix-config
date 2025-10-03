require('mini.surround').setup()
require('mini.misc').setup()

MiniMisc.setup_restore_cursor()
Util.map.nl('wm', MiniMisc.zoom, 'Maximise window')

Util.au.cmd('BufEnter', {
    desc = 'Find root and change current directory',
    group = Util.au.group('MiniMiscAutoRoot', {}),
    nested = true,
    callback = vim.schedule_wrap(function(data)
        if data.buf ~= vim.api.nvim_get_current_buf() then return end
        if vim.bo[data.buf].filetype == 'NeogitStatus' then
            print('haha')
            print('hehe')
            return
        end

        vim.o.autochdir = false
        local root = MiniMisc.find_root(data.buf, { '.git', 'Makefile' })
        if root == nil then return end
        vim.fn.chdir(root)
    end),
})
