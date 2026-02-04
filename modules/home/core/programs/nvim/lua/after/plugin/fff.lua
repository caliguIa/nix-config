vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
        if event.data.updated then require('fff.download').download_or_build_binary() end
    end,
})

vim.g.fff = {
    lazy_sync = true, -- start syncing only when the picker is open
    debug = {
        enabled = true,
        show_scores = false,
    },
}

vim.keymap.set('n', '<leader>sf', require('fff').find_files, { desc = 'Search files', silent = true })
