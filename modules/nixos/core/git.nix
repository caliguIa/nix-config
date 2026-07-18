{
    flake.modules.nixos.core = {
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.meta) getExe;
        ghBin = getExe pkgs.gh;
    in {
        programs.git = {
            enable = true;
            config = {
                user = {
                    name = "Cal";
                    email = "acc@calrichards.io";
                };
                advice = {
                    addEmptyPathspec = false;
                    pushNonFastForward = false;
                    statusHints = false;
                };
                core = {
                    editor = "nvim";
                    compression = 9;
                    whitespace = "error";
                    preloadindex = true;
                    symlinks = true;
                    autocrlf = "input";
                };
                "credential \"https://github.com\"" = {
                    helper = ["" "${ghBin} auth git-credential"];
                };
                "credential \"https://gist.github.com\"" = {
                    helper = ["" "${ghBin} auth git-credential"];
                };
                pager.diff = "diffnav";
                fetch.prune = true;
                gc.auto = 200;
                init.defaultBranch = "main";
                push = {
                    autoSetupRemote = true;
                    default = "current";
                };
                remote.pushDefault = "origin";
                pull.default = "current";
                interactive = {
                    singlekey = true;
                    diffFilter = "diffnav";
                };
                status = {
                    branch = true;
                    showStash = true;
                    showUntrackedFiles = "all";
                };
                delta = {
                    "syntax-theme" = "kanso-zen";
                    "dark" = "true";
                    "tabs" = "2";
                    "file-style" = "omit";
                    "file-decoration-style" = "none";
                    "line-numbers-left-format" = "{nm:>4} ";
                    "line-numbers-right-format" = "│ {np:>4} ";
                    "line-numbers-left-style" = "white dim";
                    "line-numbers-right-style" = "#1f2335 dim";
                    "line-numbers-zero-style" = "white dim";
                    "line-numbers-plus-style" = "white dim ";
                    "line-numbers-minus-style" = "white dim";
                    "wrap-left-symbol" = " ";
                    "wrap-right-symbol" = " ";
                    "wrap-right-prefix-symbol" = " ";
                    "plus-style" = "syntax #0e250e";
                    "plus-emph-style" = "syntax #103610";
                    "minus-style" = "syntax #402a26";
                    "minus-emph-style" = "syntax #45221c";
                    "hunk-label" = "  󰡏 ";
                    "hunk-header-line-number-style" = "#10233A";
                    "hunk-header-style" = "#868E99";
                    "hunk-header-file-style" = "#868E99 dim";
                    "hunk-header-decoration-style" = "#163050 ol ul";
                };
                "url \"git@github.com:\"".insteadOf = [
                    "https://github.com/"
                    "gh:"
                ];
                "url \"git@github.com:caliguIa/\"".insteadOf = [
                    "https://github.com/caliguIa/"
                    "cal:"
                ];
            };
        };

        programs.lazygit = {
            enable = true;
            settings = {
                git.pagers = [
                    {useExternalDiffGitConfig = true;}
                ];
                gui = {
                    border = "single";
                    nerdFontsVersion = "3";
                    theme.selectedLineBgColor = ["default"];
                };
                keybinding.universal = {
                    quitWithoutChangingDirectory = ["q" "<ctrl+c>"];
                    quit = ["Q"];
                };
            };
        };
    };
}
