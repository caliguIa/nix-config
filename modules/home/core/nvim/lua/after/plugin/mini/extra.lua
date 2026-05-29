local misc = require('mini.misc')
require('mini.surround').setup()

misc.setup()
misc.setup_restore_cursor()
misc.setup_auto_root()

vim.api.nvim_create_user_command('Maximise', function() misc.zoom() end, { desc = 'Maximise window' })
