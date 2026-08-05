local flake_dir = vim.uv.os_homedir() .. '/nix-config'
local host = vim.uv.os_gethostname()

local flake = '(builtins.getFlake "' .. flake_dir .. '")'
local host_options = flake .. '.nixosConfigurations.' .. host .. '.options'

---@type vim.lsp.Config
return {
    -- Package completion is global (uses <nixpkgs> from NIX_PATH) so it works
    -- on any nix file. Option completion is expensive (full eval of this flake)
    -- and only correct inside ~/nix-config, so it is enabled per-instance in
    -- before_init based on the resolved root_dir.
    settings = {
        nixd = {
            nixpkgs = { expr = 'import <nixpkgs> { }' },
        },
    },
    before_init = function(_, config)
        local root = config.root_dir and vim.fs.normalize(config.root_dir) or ''
        if root == flake_dir then
            config.settings.nixd.options = {
                nixos = { expr = host_options },
                hjem = {
                    expr = host_options .. '.hjem.users.type.getSubOptions []',
                },
            }
        end
    end,
}
