return {
    settings = {
        nixd = {
            nixpkgs = { expr = "import <nixpkgs> { }" },
            formatting = { command = {} },
            options = {
                nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.george.options',
                },
                home_manager = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."caligula@polyakov".options',
                },
                nix_darwin = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations.polyakov.options',
                },
            },
        },
    },
}
