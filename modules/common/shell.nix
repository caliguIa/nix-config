{
    config,
    lib,
    ...
}: {
    programs.fish = {
        enable = true;
        generateCompletions = true;
        interactiveShellInit = ''
            set -U fish_greeting
            if [ -e "~/.local/auth/fish_env.fish" ]
                source ~/.local/auth/fish_env.fish
            end
        '';
    };
    programs.zsh = {
        enable = true;
        autocd = false;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = false;
        defaultKeymap = "emacs";
        history.path = "${config.xdg.dataHome}/zsh/zsh_history";
        dotDir = "${config.xdg.configHome}/zsh";
        initContent = lib.mkBefore ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
              . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
              . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi
            echo "source <(COMPLETE=zsh tms)" >> ~/.zshrc
            source ~/.local/auth/.env
        '';
    };
    home.shell.enableFishIntegration = true;
    home.shell.enableZshIntegration = true;
    home.shellAliases = {
        dl = "cd ~/Downloads";
        dt = "cd ~/Desktop";
        df = "cd ~/nix-config";
        cf = "cd ~/.config";
        ous = "cd ~/ous/platform";
        dev = "cd ~/dev";
        nvp = "cd ~/dev/nvim-plugins";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        ls = "eza --color=always --long -a --git --icons=always";
        cat = "bat";
        ga = "git add";
        gaa = "git add .";
        gap = "git add --patch";
        gb = "git branch";
        gc = "git commit";
        gd = "git diff";
        gi = "git init";
        gs = "git status";
        gco = "git checkout";
        gp = "git push";
        gu = "git pull";
        gfp = "git fetch && git pull";
        gcl = "git clone";
        undocommit = "git reset --soft HEAD^";
        dc = "docker-compose";
        dcu = "docker-compose up";
        dcb = "docker-compose build";
        dps = "docker ps";
        ip = "curl ifconfig.io";
        localip = "ipconfig getifaddr en0";
        nix-gc = "nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc";
        t = "tmux attach-session";
        update = "softwareupdate -ia";
        updatel = "softwareupdate -l";
        ":q" = "exit";
    };
}
