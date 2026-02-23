local flake = '(builtins.getFlake ("git+file://" + toString ./.))'

---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            extraOptions = '--impure',
            nixpkgs = { expr = 'import ' .. flake .. '.inputs.nixpkgs { }' },
            options = {
                nixos = { expr = flake .. '.nixosConfigurations.karla.options' },
                ['home-manager'] = {
                    expr = flake .. '.nixosConfigurations.karla.options.home-manager.users.type.getSubOptions []',
                },
                flake = { expr = flake .. '.outputs' },
            },
        },
    },
}
