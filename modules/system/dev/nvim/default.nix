# Dev layer over the core nvim (../../core/nvim): nightly neovim, plugins,
# LSP/format tools and the dev Lua config in ./lua (hjem.dev).
{ inputs, ... }:
{
    flake.modules.nixos.dev =
        { pkgs, ... }:
        {
            nvim = {
                package = inputs.nvim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
                waylandSupport = true;
                # LSP servers and formatters on nvim's PATH.
                tools = with pkgs; [
                    # lsp
                    emmylua-ls
                    nixd
                    taplo
                    bash-language-server
                    marksman
                    docker-compose-language-service
                    dockerfile-language-server
                    vscode-langservers-extracted
                    typescript
                    # typescript-language-server
                    oxlint
                    sqls
                    stylelint-language-server
                    yaml-language-server
                    phpantom-lsp
                    # formatter
                    nixfmt
                    stylua
                    sqruff
                    vtsls
                ];
                plugins = with pkgs.vimPlugins; [
                    kanso-nvim
                    # main for mini.statuscolumn (not in nixpkgs' 0.18.0). Drop once a release has it.
                    (mini-nvim.overrideAttrs {
                        version = "0.18.0-unstable-2026-10-27";
                        src = pkgs.fetchFromGitHub {
                            owner = "nvim-mini";
                            repo = "mini.nvim";
                            rev = "a03ad899bda446b5a81cfa99d8aeeb92241522f3";
                            hash = "sha256-u65r8ajnJ69wcaU9HpGXAk4FqQ4hLuIn4L/rhR24Cfk=";
                        };
                    })
                    nvim-lspconfig
                    (nvim-treesitter.withPlugins (p: [
                        p.bash
                        p.blade
                        p.css
                        p.fish
                        p.go
                        p.html
                        p.javascript
                        p.json
                        p.lua
                        p.markdown
                        p.markdown_inline
                        p.nix
                        p.nu
                        p.php
                        p.rust
                        p.scss
                        p.toml
                        p.tsx
                        p.typescript
                        p.yaml
                        p.zig
                        p.zsh
                    ]))
                    nvim-treesitter-context
                    nvim-treesitter-textobjects
                    ts-comments-nvim
                    nvim-ts-autotag
                    pkgs.timber-nvim
                    aerial-nvim
                    conform-nvim
                    quicker-nvim
                    vim-test
                    diffs-nvim
                    neogit
                    blame-nvim
                    conflict-nvim
                    guh-nvim
                ];
                optionalPlugins = [ pkgs.vimPlugins.render-markdown-nvim ];
            };
        };

    flake.modules.hjem.dev =
        { lib, ... }:
        {
            files = import ../../core/nvim/_link.nix { inherit lib; } ./lua;
        };
}
