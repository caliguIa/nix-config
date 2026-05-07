# Minimal style configuration — fonts and theme colours.
# Pass this via extraSpecialArgs so home-manager modules can reference it:
#   { style, ... }: { programs.ghostty.settings.font-family = style.font.monospace.name; }
{inputs, pkgs}: let
    themes = import ./_themes;
    active  = themes.kanso.pearl;
in {
    font = {
        monospace = {
            name    = "Berkeley Mono";
            size    = 14;
            package = inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono;
        };
    };

    # Base16 colour palette (hex strings without leading #)
    # base00 = background, base05 = foreground, base08–0F = accent colours
    colors = active // {
        # Convenience aliases
        background = active.base00;
        foreground = active.base05;
    };
}
