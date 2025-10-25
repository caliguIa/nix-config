local uname = vim.loop.os_uname()
local is_darwin = uname.sysname == 'Darwin'
local options = {
    flake = { expr = nixCats.extra('nixdExtras.flake') },
    flake_parts = { expr = nixCats.extra('nixdExtras.flake_part_options') },
    flake_parts2 = { expr = nixCats.extra('nixdExtras.flake_part_options2') },
    ['home-manager'] = { expr = nixCats.extra('nixdExtras.home_manager_options') },
}

if is_darwin then
    options.nix_darwin = { expr = nixCats.extra('nixdExtras.nix_darwin_options') }
else
    options.nixos = { expr = nixCats.extra('nixdExtras.nixos_options') }
end

---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            nixpkgs = {
                expr = nixCats.extra('nixdExtras.nixpkgs') or 'import <nixpkgs> {}',
            },
            formatting = { command = {} },
            options = options,
        },
    },
}
