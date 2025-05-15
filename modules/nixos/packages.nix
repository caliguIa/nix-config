{
  pkgs,
  ...
}:

let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
  nixos-specific = with pkgs; [
    vim
    neovim
    wget
    curl
    git
    vnstat
    cloudflared
  ];
in
{
  environment.systemPackages = shared-packages ++ nixos-specific;
}