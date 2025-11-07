{
    flake.modules.homeManager.desktop-linux = {
        lib,
        pkgs,
        ...
    }: {
        systemd.user.services.swayosd = {
            Unit = {
                StartLimitIntervalSec = lib.mkForce 1;
                After = ["graphical-session.target"];
                PartOf = ["graphical-session.target"];
                Requisite = ["graphical-session.target"];
            };
            Service.Slice = "background.slice";
            Install.WantedBy = ["graphical-session.target"];
        };
        services.swayosd = {
            enable = true;
            stylePath = pkgs.writeText "swayosd-style.css" ''
                window#osd {
                  border-radius: 10px;
                  border: none;

                  #container {
                    margin: 8px;
                  }

                  progressbar:disabled,
                  image:disabled {
                    opacity: 0.5;
                  }

                  progressbar {
                    min-height: 6px;
                    border-radius: 999px;
                    background: transparent;
                    border: none;
                  }
                  trough {
                    min-height: inherit;
                    border-radius: inherit;
                    border: none;
                  }
                  progress {
                    min-height: inherit;
                    border-radius: inherit;
                    border: none;
                  }
                }
            '';
        };
    };
}
