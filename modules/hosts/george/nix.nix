{
    flake.modules.nixos.host_george = {
        system.stateVersion = "24.11";
        nixpkgs.config = {
            permittedInsecurePackages = [
                "broadcom-sta-6.30.223.271-57-6.12.53"
            ];
        };
    };
}
