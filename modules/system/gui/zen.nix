{ inputs, ... }:
{
    flake.modules.nixos.gui =
        {
            pkgs,
            lib,
            ...
        }:
        let
            zenPkgs = inputs.zen-browser.packages.${pkgs.stdenvNoCC.hostPlatform.system};
            wrapZen = import "${inputs.zen-browser}/wrap-zen.nix" pkgs.wrapFirefox;

            # Enterprise policies, see https://mozilla.github.io/policy-templates
            policies = {
                DisableAppUpdate = true;
                DisableTelemetry = true;
                DisableFirefoxStudies = true;
                DontCheckDefaultBrowser = true;
            };

            # about:config prefs the UI can still change
            prefs = {
                "zen.welcome-screen.seen" = true;
                "zen.workspaces.continue-where-left-off" = true;
            };

            # about:config prefs the UI cannot change
            lockedPrefs = { };

            renderPrefs =
                fn: lib.concatMapAttrsStringSep "\n" (name: value: ''${fn}("${name}", ${builtins.toJSON value});'');

            # Gecko autoconfig. Applies to every profile, so no $HOME state is
            # needed, and unlike policies.Preferences it accepts any pref name.
            autoconfig = pkgs.writeText "zen-nixos.cfg" ''
                // The first line of an autoconfig file is always ignored.
                ${renderPrefs "defaultPref" prefs}
                ${renderPrefs "lockPref" lockedPrefs}
            '';

            autoconfigPrefs = pkgs.writeText "zen-nixos-prefs.js" ''
                pref("general.config.filename", "zen-nixos.cfg");
                pref("general.config.obscure_value", 0);
                pref("general.config.sandbox_enabled", false);
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

            # Both files have to land in the unwrapped derivation: the wrapper's
            # launcher execs straight through to the real binary, and Gecko looks
            # for policies and autoconfig next to /proc/self/exe.
            unwrapped = (zenPkgs.twilight-unwrapped.override { inherit policies; }).overrideAttrs (finalAttrs: {
                postInstall = (finalAttrs.postInstall or "") + ''
                    for libdir in "$out"/lib/zen-bin-*; do
                        chmod -R u+w "$libdir/defaults"
                        install -Dm444 ${autoconfig} "$libdir/zen-nixos.cfg"
                        install -Dm444 ${autoconfigPrefs} "$libdir/defaults/pref/zen-nixos-prefs.js"
                    done
                '';
            });
        in
        {
            environment.systemPackages = [ (wrapZen unwrapped { }) ];
        };
}
