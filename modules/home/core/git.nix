{
    flake.modules.homeManager.core = {
        programs.git = {
            enable = true;
            signing.format = null;
            settings = {
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
                diff = {
                    context = 3;
                    renames = "copies";
                    interHunkContext = 10;
                };
                fetch.prune = true;
                gc.auto = 200;
                init.defaultBranch = "main";
                push = {
                    autoSetupRemote = true;
                    default = "current";
                };
                remote = {
                    pushDefault = "origin";
                };
                pull = {
                    default = "current";
                };
                interactive.singlekey = true;
                status = {
                    branch = true;
                    showStash = true;
                    showUntrackedFiles = "all";
                };
                url = {
                    "git@github.com:" = {
                        insteadOf = [
                            "https://github.com/"
                            "gh:"
                        ];
                    };
                    "git@github.com:caliguIa/" = {
                        insteadOf = [
                            "https://github.com/caliguIa/"
                            "cal:"
                        ];
                    };
                };
            };
        };
    };
}
