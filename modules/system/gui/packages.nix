{ inputs, ... }: {
    flake.modules.nixos.gui = { pkgs, ... }: {
        services.dbus.enable = true;
        services.mullvad-vpn.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
            ];
        };
        programs.localsend.enable = true;
        programs.firefox = {
            enable = true;
            package = pkgs.firefox-devedition;
        };
        services.tlp.enable = false;
        services.power-profiles-daemon.enable = true;
        environment.sessionVariables = {
            OPENCODE_EXPERIMENTAL_OXFMT = "true";
            MOZ_DISABLE_RDD_SANDBOX = "1";
        };
        environment.systemPackages = with pkgs; [
            bitwarden-cli
            bitwarden-desktop
            bruno
            claude-code
            gelly
            glib.bin
            mullvad
            mullvad-vpn
            opencode
            poppler
            resvg
            slack
            spotify
            tableplus
            ungoogled-chromium
            (inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight.override {
                # memory: fewer content processes, no spare/bfcache pages, unload idle tabs, no local ML
                extraPrefs = ''
                    pref("dom.ipc.processCount", 4);
                    pref("dom.ipc.processPrelaunch.enabled", false);
                    pref("browser.sessionhistory.max_total_viewers", 0);
                    pref("browser.cache.memory.capacity", 65536);
                    pref("browser.tabs.unloadOnLowMemory", true);
                    pref("zen.tab-unloader.enabled", true);
                    pref("zen.tab-unloader.timeout-minutes", 15);
                    pref("network.prefetch-next", false);
                    pref("browser.ml.enable", false);
                    pref("browser.ml.chat.enabled", false);
                    pref("browser.ml.linkPreview.enabled", false);
                    pref("browser.tabs.groups.smart.enabled", false);
                    pref("extensions.ml.enabled", false);
                '';
            })
        ];
    };
}
