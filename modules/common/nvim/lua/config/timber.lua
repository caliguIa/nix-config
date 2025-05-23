require("timber").setup({
    log_templates = {
        default = {
            php = [[dump("%log_target", %log_target);]],
        },
    },
})
