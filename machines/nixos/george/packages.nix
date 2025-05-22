{
    pkgs,
    inputs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        inputs.self.outputs.nixCats.packages.${pkgs.system}.nvim
    ];
}
