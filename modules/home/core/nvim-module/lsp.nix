{
    flake.modules.hjem.nvim-module = {lib, ...}: let
        inherit (import ./_helpers.nix {inherit lib;}) mkRaw;
    in {
        programs.nvim-module.lsp = {
            cssls = {};
            docker_compose_language_service = {};
            dockerls = {};
            gopls = {};
            phpantom_lsp = {};
            marksman = {};
            sqls = {};
            oxlint = {};
            zls = {};
            jsonls = {};
            yamlls = {};
            taplo = {};

            stylelint_lsp.settings.settings.stylelint = {
                snippet = ["scss" "css" "postcss"];
                validate = ["scss" "css" "postcss"];
            };

            rust_analyzer.settings.settings = {
                diagnostics = {
                    enable = true;
                    experimental.enable = true;
                };
                assist = {
                    importEnforceGranularity = true;
                    importPrefix = "crate";
                };
                cargo.allFeatures = true;
                checkOnSave.command = "clippy";
            };

            tsgo.settings.settings = {
                complete_function_calls = true;
                typescript = {
                    updateImportsOnFileMove.enabled = "always";
                    suggest.completeFunctionCalls = true;
                    inlayHints = {
                        enumMemberValues.enabled = false;
                        functionLikeReturnTypes.enabled = false;
                        parameterNames.enabled = false;
                        parameterTypes.enabled = false;
                        propertyDeclarationTypes.enabled = false;
                        variableTypes.enabled = false;
                    };
                };
            };

            intelephense = {
                enable = false;
                settings = {
                    init_options = {
                        globalStoragePath = mkRaw "os.getenv('HOME') .. '/.cache/intelephense'";
                        licenceKey = mkRaw "os.getenv('INTELEPHENSE_KEY_PATH')";
                        "language_server_configuration.auto_config" = true;
                        "code_transform.import_globals" = true;
                    };
                    settings = {
                        intelephense = {
                            diagnostics.enable = true;
                            filetypes = ["php" "blade" "php_only"];
                            format.enable = false;
                            files = {
                                associations = ["*.php" "*.blade.php"];
                                maxSize = 5000000;
                            };
                            inlayHint = {
                                parameterNames = false;
                                parameterTypes = false;
                                returnTypes = false;
                            };
                            references.exclude = ["**/vendor/**" "**/_ide_helper*.php"];
                        };
                        php.completion.callSnippet = "Replace";
                    };
                };
            };

            laravel_ls = {
                enable = false;
                settings.init_options.inlayHints.routes.enabled = true;
            };

            nixd.settings = null;
            emmylua_ls.settings = null;
        };
    };
}
