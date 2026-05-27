{
    flake.modules.nixos.desktop = {pkgs, ...}: let
        arcmenu = pkgs.stdenv.mkDerivation rec {
            pname = "gnome-shell-extension-arcmenu";
            version = "69.0";

            src = pkgs.fetchFromGitLab {
                owner = "arcmenu";
                repo = "ArcMenu";
                rev = "v${version}";
                hash = "sha256-TOPTF4S8lVTttGWI4FGZ2VuqGg8OG5kUAhKIuCJD84U=";
            };

            patches = [
                (pkgs.replaceVars ./fix_gmenu.patch {
                    gmenu_path = "${pkgs.gnome-menus}/lib/girepository-1.0";
                })
            ];

            buildInputs = with pkgs; [
                glib
                gettext
            ];

            makeFlags = ["INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions"];

            passthru = {
                extensionUuid = "arcmenu@arcmenu.com";
                extensionPortalSlug = "arcmenu";
            };

            meta = with pkgs.lib; {
                description = "Application menu for GNOME Shell, designed to provide a more traditional user experience and workflow";
                license = licenses.gpl2Plus;
                homepage = "https://gitlab.com/arcmenu/ArcMenu";
            };
        };
    in {
        environment.systemPackages = [arcmenu];
    };
}
