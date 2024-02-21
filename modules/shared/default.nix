{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = true;
      allowUnsupportedSystem = true;
    };
  };
}
