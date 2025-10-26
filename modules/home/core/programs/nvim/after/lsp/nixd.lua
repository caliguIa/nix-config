local flake_expr = string.format('(builtins.getFlake "%s")', string.format('%s/nix-config', os.getenv('HOME')))
local get_option_expr = function(path) return string.format('%s%s', flake_expr, path) end
local darwin_opt_expr = get_option_expr('.darwinConfigurations.polyakov.options')
local nixos_opt_expr = get_option_expr('.nixosConfigurations.george.options')
local home_manager_opt_expr = string.format(
    '%s.home-manager.users.type.getSubOptions []',
    vim.uv.os_uname().sysname == 'Darwin' and darwin_opt_expr or nixos_opt_expr
)

---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            nixpkgs = { expr = string.format('import %s.inputs.nixpkgs { }', flake_expr) },
            options = {
                flake = { expr = get_option_expr('.outputs') },
                flake_parts = { expr = get_option_expr('.debug.options') },
                flake_parts2 = { expr = get_option_expr('.currentSystem.options') },
                nix_darwin = { expr = darwin_opt_expr },
                nixos = { expr = nixos_opt_expr },
                ['home-manager'] = { expr = home_manager_opt_expr },
            },
        },
    },
}
