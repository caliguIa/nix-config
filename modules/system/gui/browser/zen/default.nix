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

            # Extension id to its slug on addons.mozilla.org. Only these are forced,
            # anything else stays installable by hand. Pinned ones sit in the
            # toolbar, the rest in the extensions panel.
            extensions = {
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    slug = "bitwarden-password-manager";
                    pinned = true;
                };
                "uBlock0@raymondhill.net" = {
                    slug = "ublock-origin";
                    pinned = false;
                };
                "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
                    slug = "vimium-ff";
                    pinned = false;
                };
            };

            # The id Firefox gives an extension's toolbar button.
            widgetId =
                id:
                lib.stringAsChars (c: if builtins.match "[a-z0-9_-]" c != null then c else "_") (lib.toLower id)
                + "-browser-action";
            pinnedWidgets = lib.mapAttrsToList (id: _: widgetId id) (
                lib.filterAttrs (_: ext: ext.pinned) extensions
            );

            # Container identities, upserted by userContextId on launch.
            containers = {
                personal = {
                    userContextId = 1;
                    icon = "fingerprint";
                    color = "blue";
                };
                work = {
                    userContextId = 2;
                    icon = "briefcase";
                    color = "orange";
                };
            };

            # Spaces and their pins, in order. A pin's name is optional, without one
            # the page title shows. The uuids are the ones already in the
            # session so nothing is duplicated. Spaces or pins made by hand are kept.
            spaces = [
                {
                    name = "Personal";
                    uuid = "{2b56123b-1a7b-4ae1-86d0-772550400b79}";
                    icon = "chrome://browser/skin/zen-icons/selectable/star.svg";
                    container = containers.personal.userContextId;
                    essentials = [ ];
                    pins = [
                        {
                            name = "Fastmail";
                            url = "https://app.fastmail.com/";
                        }
                        {
                            name = "GitHub";
                            url = "https://github.com/";
                        }
                        {
                            name = "Claude";
                            url = "https://claude.ai/new";
                        }
                        {
                            name = "NixOS Search";
                            url = "https://search.nixos.org/packages?channel=unstable";
                        }
                    ];
                }
                {
                    name = "Work";
                    uuid = "{1b61faf2-584f-47b5-ba3c-bb25d28841b0}";
                    icon = "chrome://browser/skin/zen-icons/selectable/briefcase.svg";
                    container = containers.work.userContextId;
                    essentials = [ ];
                    pins = [
                        {
                            name = "GitHub";
                            url = "https://github.com/";
                        }
                        {
                            name = "Claude";
                            url = "https://claude.ai/new";
                        }
                        {
                            name = "Gmail";
                            url = "https://mail.google.com";
                        }
                        {
                            name = "Calendar";
                            url = "https://calendar.google.com";
                        }
                    ];
                }
            ];

            # Enterprise policies, see https://mozilla.github.io/policy-templates
            policies = {
                DisableAppUpdate = true;
                DisableTelemetry = true;
                DisableFirefoxStudies = true;
                DontCheckDefaultBrowser = true;

                # Passwords and autofill live in Bitwarden.
                PasswordManagerEnabled = false;
                OfferToSaveLogins = false;
                AutofillAddressEnabled = false;
                AutofillCreditCardEnabled = false;
                PictureInPicture = {
                    Enabled = false;
                    Locked = true;
                };
                # Engines that do not exist are skipped, so the list can be generous.
                SearchEngines = {
                    Default = "DuckDuckGo";
                    Remove = [
                        "Google"
                        "Bing"
                        "Perplexity"
                        "Wikipedia (en)"
                        "Wikipedia"
                        "eBay"
                        "Amazon.co.uk"
                        "Amazon.com"
                        "Amazon"
                        "Ecosia"
                        "Qwant"
                        "Startpage"
                        "Yahoo"
                    ];
                };

                ExtensionSettings = lib.mapAttrs (_: ext: {
                    installation_mode = "force_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext.slug}/latest.xpi";
                    default_area = if ext.pinned then "navbar" else "menupanel";
                }) extensions;
            };

            # about:config prefs the UI can still change
            prefs = {
                "zen.welcome-screen.seen" = true;
                "zen.workspaces.continue-where-left-off" = true;
            };

            # about:config prefs the UI cannot change
            lockedPrefs = {
                "zen.tabs.vertical.right-side" = true;
                "browser.ctrlTab.sortByRecentlyUsed" = true;
                # What the password and picture-in-picture policies do not cover
                "signon.autofillForms" = false;
                "signon.generation.enabled" = false;
                "signon.firefoxRelay.feature" = "disabled";
                "signon.management.page.breach-alerts.enabled" = false;
                "signon.formlessCapture.enabled" = false;
                "media.videocontrols.picture-in-picture.enabled" = false;
            };

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
            wrapped = wrapZen unwrapped { };

            declarative = import ./_declarative.nix {
                inherit
                    pkgs
                    lib
                    containers
                    spaces
                    pinnedWidgets
                    ;
            };

            # Every launch, including the .desktop entry, goes through this first so
            # the profile matches the declared state before Zen reads it. It never
            # blocks the launch: failures are logged and Zen starts regardless.
            launcher = pkgs.writeShellScript "zen-twilight" ''
                ${lib.getExe declarative} "$@" || true
                exec ${wrapped}/bin/zen-twilight "$@"
            '';
            zen = pkgs.symlinkJoin {
                inherit (wrapped) name meta;
                paths = [ wrapped ];
                postBuild = ''
                    ln -sf ${launcher} "$out/bin/zen-twilight"
                '';
            };
        in
        {
            environment.systemPackages = [ zen ];
        };
}
