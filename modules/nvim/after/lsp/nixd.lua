local get_nixd_opts = nixCats.extra('nixdExtras.get_configs')
return {
    settings = {
        nixd = {
            expr = nixCats.extra('nixdExtras.nixpkgs') or 'import <nixpkgs> {}',
            formatting = { command = {} },
            options = {
                nixos = { expr = nixCats.extra('nixdExtras.nixos_options') },
                ['home-manager'] = { expr = nixCats.extra('nixdExtras.home_manager_options') },
                nix_darwin = {
                    -- expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations.polyakov.options',
                    expr = nixCats.extra('nixdExtras.nix_darwin_options'),
                },
            },
        },
    },
}
