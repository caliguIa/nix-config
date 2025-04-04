{ config, ... }:
{
  enable = true;
  autocd = false;
  autosuggestion.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = false;
  defaultKeymap = "emacs";
  history.path = "${config.xdg.dataHome}/zsh/zsh_history";
  dotDir = ".config/zsh";
  shellAliases = {
    "~" = "cd ~";
    dl = "cd ~/Downloads";
    dt = "cd ~/Desktop";
    df = "cd ~/nix-config";
    cf = "cd ~/.config";
    cfg = "cd ~/nix-config/modules/shared/config";
    nixcfg = "cd ~/nix-config/";
    ous = "cd ~/ous";
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
    kanata-reload = "sudo launchctl unload /Library/LaunchDaemons/com.jtroo.kanata.plist; sudo launchctl load  /Library/LaunchDaemons/com.jtroo.kanata.plist";
    nix-rebuild = "cd $HOME/nix-config; just build; cd -";
    nix-gc = "nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc";
    t = "tmux attach-session";
    update = "softwareupdate -ia";
    updatel = "softwareupdate -l";
    ":q" = "exit";
    vpn-up = "aws ec2 start-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
    vpn-down = "aws ec2 stop-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
  };

  initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    [[ ! -r /Users/caligula/.opam/opam-init/init.zsh ]] || source /Users/caligula/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

    source ~/.local/auth/.env
  '';
}
