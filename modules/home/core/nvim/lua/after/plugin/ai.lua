require('copilot').setup()
require('avante').setup({
    provider = 'copilot', -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
    mode = 'agentic',
    auto_suggestions_provider = 'copilot',
    providers = {
        copilot = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-sonnet-4-20250514',
            timeout = 30000, -- Timeout in milliseconds
            extra_request_body = {
                temperature = 0.75,
                max_tokens = 20480,
            },
        },
    },
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'avante' and (kind == 'install' or kind == 'update') then
            vim.system({ 'make' }, { cwd = ev.data.path })
        end
    end,
})
