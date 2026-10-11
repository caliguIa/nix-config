{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
            bw = pkgs.bitwarden-desktop;
            # Bitwarden marks its main process non-dumpable ("process isolation"),
            # which leaves xdg-desktop-portal unable to identify the caller, so every
            # file dialog (adding/saving attachments, exports) returns cancelled with
            # nothing shown. Upstream only skips it for snaps
            # (flatpak/xdg-desktop-portal#785). Blank out the call in the asar with
            # spaces: same length, so the archive's offsets stay valid, and no
            # rebuild of bitwarden itself. Delete this once upstream stops isolating
            # (or skips it when the portal is in use). Yama ptrace_scope=1 still blocks other
            # processes from attaching, and the wrapper already disables core dumps.
            bitwarden-desktop =
                pkgs.runCommandLocal "bitwarden-desktop-${bw.version}"
                    {
                        nativeBuildInputs = [ pkgs.perl ];
                        inherit (bw) meta;
                    }
                    ''
                        cp -rs ${bw} $out
                        chmod -R u+w $out
                        asar=opt/Bitwarden/resources/app.asar
                        rm $out/$asar $out/bin/bitwarden
                        # The asar also hardcodes its own store path (app.setPath("exe"), which
                        # the autostart entry is written from); same length, so swap it too or
                        # login would start the unpatched build.
                        orig=${bw} out=$out perl -0777 -pe '
                            $n = s/yield desktop_napi_1\.processisolations\.isolateProcess\(\);/" " x length($&)/ge;
                            $p = s/\Q$ENV{orig}\E/$ENV{out}/g;
                            END {
                                die "bitwarden: process isolation call not found\n" unless $n == 1;
                                die "bitwarden: own store path not found\n" unless $p >= 1;
                            }
                        ' ${bw}/$asar > $out/$asar
                        substitute ${bw}/bin/bitwarden $out/bin/bitwarden --replace-fail ${bw}/$asar $out/$asar
                        chmod +x $out/bin/bitwarden
                    '';
        in
        {
            environment.systemPackages = [ bitwarden-desktop ];
        };
}
