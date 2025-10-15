{
    pkgs,
    inputs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
    ];
}
