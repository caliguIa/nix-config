{
    flake.modules.nixos.core =
        { lib, pkgs, ... }:
        let
            # By store path: root's git (sudo, smiley) has no delta on PATH.
            delta = lib.getExe pkgs.delta;
        in
        {
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
                        pager = delta;
                        compression = 9;
                        preloadindex = true;
                        symlinks = true;
                        autocrlf = "input";
                    };
                    include.path = "~/.config/git/gh-credentials";
                    pager.diff = delta;
                    fetch.prune = true;
                    gc.auto = 200;
                    init.defaultBranch = "main";
                    push = {
                        autoSetupRemote = true;
                        default = "current";
                    };
                    remote.pushDefault = "origin";
                    interactive = {
                        singlekey = true;
                        diffFilter = "${delta} --color-only";
                    };
                    status = {
                        branch = true;
                        showStash = true;
                        showUntrackedFiles = "all";
                    };
                    delta = {
                        "dark" = "true";
                        "navigate" = "true";
                        "tabs" = "2";
                        "file-style" = "omit";
                        "file-decoration-style" = "none";
                        "wrap-left-symbol" = " ";
                        "wrap-right-symbol" = " ";
                        "wrap-right-prefix-symbol" = " ";
                        "hunk-label" = "  󰡏 ";
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
                    git.diffRenderers = [
                        { command = "delta --dark --paging=never"; }
                    ];
                    gui = {
                        border = "single";
                        nerdFontsVersion = "3";
                        theme.selectedLineBgColor = [ "default" ];
                    };
                    keybinding.universal = {
                        quitWithoutChangingDirectory = [
                            "q"
                            "<ctrl+c>"
                        ];
                        quit = [ "Q" ];
                    };
                };
            };
        };

    flake.modules.hjem.core =
        { pkgs, ... }:
        {
            packages = [ pkgs.delta ];
        };
}
