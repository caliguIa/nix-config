{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.packages = with pkgs; [
            firefoxpwa
        ];
        programs.firefox = {
            enable = true;
            nativeMessagingHosts = with pkgs; [firefoxpwa];
            package = pkgs.firefox.override (_: {
                extraPrefs = ''
                    pref("ui.systemUsesDarkTheme", 1);
                    pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
                    pref("privacy.webrtc.legacyGlobalIndicator", false);
                    pref("media.ffmpeg.vaapi.enabled", true);
                    pref("gfx.webrender.enabled", true);
                    pref("gfx.webrender.all", true);
                    pref("gfx.webrender.compositor", true);
                    pref("network.dns.echconfig.enabled", true);
                    pref("network.dns.http3_echconfig.enabled", true);
                    pref("geo.enabled", false);
                    pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
                    pref("browser.compactmode.show", true);
                    pref("identity.fxaccounts.toolbar.pxiToolbarEnabled.monitorEnabled", false);
                    pref("widget.gtk.rounded-bottom-corners.enabled", true);
                    pref("browser.uidensity", 1);
                    pref("network.proxy.type", 0);
                    pref("privacy.donottrackheader.enabled", true);
                    pref("security.OCSP.require", false);
                    pref("intl.regional_prefs.use_os_locales", true);
                '';
            });
            policies = {
                DefaultDownloadDirectory = "\${home}/Downloads";
                ExtensionSettings = {
                    "uBlock0@raymondhill.net" = {
                        default_area = "menupanel";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                        installation_mode = "force_installed";
                        private_browsing = true;
                    };
                    "pwas_for_firefox" = {
                        default_area = "menupanel";
                        install_url = "https://addons.mozilla.org/firefox/downloads/file/4577733/pwas_for_firefox-2.16.0.xpi";
                        installation_mode = "force_installed";
                        private_browsing = false;
                    };
                };
                BlockAboutConfig = false;
                DisableFirefoxStudies = true;
                DisableTelemetry = true;
                DNSOverHTTPS.Enabled = true;
                DontCheckDefaultBrowser = true;
                OfferToSaveLogins = false;
                PictureInPicture = false;
                PostQuantumKeyAgreementEnabled = true;
                SkipTermsOfUse = true;
            };
        };
    };
}
