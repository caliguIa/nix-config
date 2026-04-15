{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: let
        cssmodules-ls = pkgs.buildNpmPackage {
            pname = "cssmodules-language-server";
            version = "1.5.2";
            src = pkgs.fetchFromGitHub {
                owner = "antonk52";
                repo = "cssmodules-language-server";
                rev = "main";
                hash = "sha256-9RZNXdmBP4OK7k/0LuuvqxYGG2fESYTCFNCkAWZQapk=";
            };
            npmDepsHash = "sha256-1CnCgut0Knf97+YHVJGUZqnRId/BwHw+jH1YPIrDPCA=";
            dontNpmBuild = false;
        };
    in {
        programs.neovim.extraPackages = with pkgs; [
            emmylua-ls
            marksman
            nixd
            taplo
            just-lsp
            vscode-langservers-extracted
            bash-language-server
            alejandra
            lua-language-server
            typescript-go
            sleek
            cssmodules-ls
            stylua
            sqruff
            vtsls
        ];
        home.sessionVariables = {
            INTELEPHENSE_KEY_PATH = config.age.secrets.intelephense.path;
        };
    };
}
