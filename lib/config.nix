{
  inputs,
  username,
}: {
  systems = {
    george = {
      system = "x86_64-linux";
      hostname = "george";
    };
    westerby = {
      system = "aarch64-linux";
      hostname = "westerby";
    };
    polyakov = {
      system = "aarch64-darwin";
      hostname = "polyakov";
    };
  };

  platformConfigs = {
    darwin = {
      builder = inputs.darwin.lib.darwinSystem;
      homeManagerModule = inputs.home-manager.darwinModules.home-manager;
      extraModules = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        (import ../modules/homebrew.nix {inherit inputs username;})
      ];
    };
    nixos = {
      builder = inputs.nixpkgs.lib.nixosSystem;
      homeManagerModule = inputs.home-manager.nixosModules.home-manager;
      extraModules = [];
    };
  };
}
