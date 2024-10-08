{ config, pkgs, ... }:
{
  enable = true;
  autocd = false;
  autosuggestion.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  defaultKeymap = "emacs";
  history = {
    path = "${config.xdg.dataHome}/zsh/zsh_history";
  };
  dotDir = ".config/zsh";
  shellAliases = {
    "~" = "cd ~";
    dl = "cd ~/Downloads";
    dt = "cd ~/Desktop";
    df = "cd ~/nix-config";
    nvcf = "cd ~/nix-config/modules/shared/config/neovim";
    cf = "cd ~/.config";
    dev = "cd ~/dev";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ls = "eza --color=always --long -a --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    cat = "bat";
    gaa = "git add --all";
    gst = "git status";
    gac = "git add .; git commit";
    gco = "git checkout";
    gs = "git switch";
    gfp = "git fetch && git pull";
    undocommit = "git reset --soft HEAD^";
    dc = "docker-compose";
    dcu = "docker-compose up";
    dcb = "docker-compose build";
    dps = "docker ps";
    ip = "curl ifconfig.io";
    localip = "ipconfig getifaddr en0";
    ous = "cd ~/oneupsales/platform";
    ousr = "cd ~/oneupsales; make down; make platform-up; cd -";
    update = "softwareupdate -ia";
    updatel = "softwareupdate -l";
    t = "tmux attach || tmux new";
    tks = "tmux kill-server";
    ":q" = "exit";
    fuck = "echo 'Running: e[32msudo e[35me[4m$(fc -ln -1)e[0m' && sudo $(fc -ln -1)";
    nixbs = "cd ~/nix-config; git add .; nix run .#build-switch";
  };

  initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    [[ ! -r /Users/caligula/.opam/opam-init/init.zsh ]] || source /Users/caligula/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/Users/caligula/.cargo/bin:$PATH"

    nixmv() {
      sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
      sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
      sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
    }

    source ~/.env
  '';
}
