local flake_dir = vim.uv.os_homedir() .. '/nix-config'
local host = vim.uv.os_gethostname()

local flake = '(builtins.getFlake "' .. flake_dir .. '")'
local host_options = flake .. '.nixosConfigurations.' .. host .. '.options'

---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            nixpkgs = { expr = 'import ' .. flake .. '.inputs.nixpkgs { }' },
            options = {
                nixos = { expr = host_options },
                hjem = {
                    expr = host_options .. '.hjem.users.type.getSubOptions []',
                },
            },
        },
    },
}
