{
    inputs,
    self,
    ...
}: {
    flake.modules.darwin.system-desktop-theme = {
        imports = [
            inputs.stylix.darwinModules.stylix
            self.modules.generic.system-desktop-theme
        ];
        stylix.fonts.sizes = {
            applications = 11;
            desktop = 11;
            popups = 11;
            terminal = 11;
        };
    };

    flake.modules.nixos.system-desktop-theme = {
        imports = [
            inputs.stylix.nixosModules.stylix
            self.modules.generic.system-desktop-theme
        ];
        stylix.fonts.sizes = {
            applications = 11;
            desktop = 11;
            popups = 11;
            terminal = 11;
        };
    };

    flake.modules.generic.system-desktop-theme = {pkgs, ...}: {
        stylix = {
            enable = true;
            autoEnable = false;
            fonts = rec {
                monospace = {
                    name = "Berkeley Mono";
                    package = pkgs.berkeley-mono;
                };
                serif = monospace;
                sansSerif = monospace;
            };
            base16Scheme = {
                base00 = "#14171d"; # inkBg0 - Default Background
                base01 = "#1f1f26"; # inkBg1 - Lighter Background (Used for status bars)
                base02 = "#22262D"; # inkBg2 - Selection Background
                base03 = "#393B44"; # inkBg3 - Comments, Invisibles, Line Highlighting
                base04 = "#75797f"; # gray4 - Dark Foreground (Used for status bars)
                base05 = "#C5C9C7"; # fg - Default Foreground, Caret, Delimiters, Operators
                base06 = "#A4A7A4"; # gray2 - Light Foreground (Not often used)
                base07 = "#f2f1ef"; # fg2 - Light Background (Not often used)
                base08 = "#c4746e"; # red3 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
                base09 = "#b6927b"; # orange - Integers, Boolean, Constants, XML Attributes, Markup Link Url
                base0A = "#c4b28a"; # yellow3 - Classes, Markup Bold, Search Text Background
                base0B = "#8a9a7b"; # green3 - Strings, Inherited Class, Markup Code, Diff Inserted
                base0C = "#8ea4a2"; # aqua - Support, Regular Expressions, Escape Characters, Markup Quotes
                base0D = "#8ba4b0"; # blue3 - Functions, Methods, Attribute IDs, Headings
                base0E = "#8992a7"; # violet2 - Keywords, Storage, Selector, Markup Italic, Diff Changed
                base0F = "#a292a3"; # pink - Deprecated, Opening/Closing Embedded Language Tags
                scheme = "kanso";
                author = "webhooked";
            };
        };
    };
}
