{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    curl
    git
    tmux
    vnstat
    cloudflared
  ];
}