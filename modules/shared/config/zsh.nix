{ config, ... }:
{
  enable = true;
  autocd = false;
  autosuggestion.enable = true;
  enableCompletion = true;
  oh-my-zsh = {
    enable = true;
    plugins = [
      "gh"
      "git"
      "ripgrep"
      "fzf"
    ];
  };
  syntaxHighlighting.enable = true;
  defaultKeymap = "emacs";
  history = {
    path = "${config.xdg.dataHome}/zsh/zsh_history";
  };
  dotDir = ".config/zsh";
  localVariables = {
    ZSH_TMUX_AUTOSTART = true;
  };
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
    ousr = "cd ~/oneupsales";
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

    export PATH="/opt/homebrew/bin:$PATH"

    nixmv() {
      sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
      sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
      sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
    }

  '';
}
