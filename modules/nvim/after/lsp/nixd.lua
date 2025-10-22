local uname = vim.loop.os_uname()
local is_darwin = uname.sysname == 'Darwin'
local options = {
    flake = { expr = nixCats.extra('nixdExtras.flake') },
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
