require('mini.jump').setup()
require('mini.jump2d').setup({
    view = { dim = true },
    allowed_windows = { not_current = false },
    allowed_lines = {
        blank = false,
        fold = false,
    },
    silent = true,
})
