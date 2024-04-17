return {
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        picker = "fzf-lua",
        picker_config = {
            use_emojis = true,
        },
    },
}
