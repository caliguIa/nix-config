# Firefox driven by Tridactyl, with as little browser chrome as possible.
# The Zen pins become bookmarks, one folder per space, that open in the
# space's container.
{ lib, ... }:
let
    inherit (import ../_pins.nix) containers spaces;

    containerOf =
        space: lib.findFirst (c: c.userContextId == space.container) null (lib.attrValues containers);

    # Tridactyl splits ex command arguments on whitespace.
    spaceNames = map (space: space.name) spaces;
    checkedSpaces = lib.throwIf (lib.any (lib.hasInfix " ") spaceNames)
        "firefox: space names become container names and cannot contain spaces (${toString spaceNames})"
        spaces;
in
{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
            # Extension id to its slug on addons.mozilla.org. Only these are forced,
            # anything else stays installable by hand.
            extensions = {
                "tridactyl.vim@cmcaine.co.uk" = "tridactyl-vim";
                # Handles the ext+container: links the bookmarks use.
                "{f069aec0-43c5-4bbf-b6b4-df95c4326b98}" = "open-url-in-container";
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
                "uBlock0@raymondhill.net" = "ublock-origin";
            };

            # Firefox keys policy bookmarks by URL, so a plain URL pinned in two
            # spaces would only be bookmarked once. Carrying the container in the
            # URL keeps them apart and opens the page in that container, which the
            # extension creates if it is missing.
            containerUrl =
                space: url:
                let
                    c = containerOf space;
                in
                "ext+container:name=${lib.escapeURL space.name}&color=${c.color}&icon=${c.icon}&url=${lib.escapeURL url}";

            # Titles name the space too, since Tridactyl's completion does not show
            # folders.
            bookmarks = lib.concatMap (
                space:
                map (pin: {
                    Title = "${pin.name or pin.url} (${space.name})";
                    URL = containerUrl space pin.url;
                    Folder = space.name;
                    Placement = "menu";
                }) (space.essentials ++ space.pins)
            ) checkedSpaces;

            # Enterprise policies, see https://mozilla.github.io/policy-templates
            policies = {
                DisableTelemetry = true;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableProfileImport = true;
                DisableSetDesktopBackground = true;
                DontCheckDefaultBrowser = true;
                NoDefaultBookmarks = true;
                OverrideFirstRunPage = "";
                OverridePostUpdatePage = "";
                DisplayBookmarksToolbar = "never";
                DisplayMenuBar = "never";
                FirefoxHome = {
                    Search = false;
                    TopSites = false;
                    SponsoredTopSites = false;
                    Highlights = false;
                    Pocket = false;
                    SponsoredPocket = false;
                    Locked = true;
                };
                FirefoxSuggest = {
                    WebSuggestions = false;
                    SponsoredSuggestions = false;
                    ImproveSuggest = false;
                    Locked = true;
                };
                UserMessaging = {
                    ExtensionRecommendations = false;
                    FeatureRecommendations = false;
                    UrlbarInterventions = false;
                    SkipOnboarding = true;
                    MoreFromMozilla = false;
                    Locked = true;
                };

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

                Bookmarks = bookmarks;

                # Extension buttons go to the overflow panel, the toolbar stays empty.
                ExtensionSettings = lib.mapAttrs (_: slug: {
                    installation_mode = "force_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
                    default_area = "menupanel";
                }) extensions;
            };

            # Registered as a user sheet from autoconfig, so it reaches every
            # profile without $HOME state. User sheets also apply to web pages,
            # hence the @-moz-document guard and the windowtype prefix.
            minimalChrome = pkgs.writeText "firefox-minimal-chrome.css" ''
                @-moz-document url("chrome://browser/content/browser.xhtml") {
                    /* Tabs are driven from Tridactyl (b, gt, gT), so no tab strip
                       and no sidebar launcher. */
                    :root[windowtype="navigator:browser"] #TabsToolbar:not([customizing]),
                    :root[windowtype="navigator:browser"] sidebar-main,
                    :root[windowtype="navigator:browser"] #sidebar-launcher-splitter {
                        visibility: collapse !important;
                    }

                    /* The toolbox floats over the page and only shows while
                       something in it has focus (C-l) or one of its panels is
                       open. It stays focusable, unlike a collapsed toolbar. */
                    :root[windowtype="navigator:browser"]:not([customizing], [inDOMFullscreen]) #navigator-toolbox {
                        position: fixed !important;
                        top: 0;
                        left: 0;
                        right: 0;
                        z-index: 10 !important;
                        border-bottom: none !important;
                        opacity: 0;
                        pointer-events: none;
                        transform: rotateX(89.9deg);
                        transform-origin: top;
                    }
                    :root[windowtype="navigator:browser"]:not([customizing]) #navigator-toolbox:is(:focus-within, :has([open])) {
                        opacity: 1;
                        pointer-events: auto;
                        transform: none;
                    }

                    :root[windowtype="navigator:browser"] :is(
                        #sidebar-header,
                        #sidebar-panel-header,
                        #PersonalToolbar,
                        .titlebar-buttonbox-container,
                        .titlebar-spacer
                    ) {
                        display: none !important;
                    }
                }
            '';

            # about:config prefs the UI can still change
            prefs = {
                "browser.startup.page" = 3;
                "browser.startup.homepage" = "about:blank";
                "browser.newtabpage.enabled" = false;
                "browser.aboutConfig.showWarning" = false;
                "browser.download.alwaysOpenPanel" = false;
                "browser.translations.automaticallyPopup" = false;
            };

            # about:config prefs the UI cannot change
            lockedPrefs = {
                "browser.tabs.inTitlebar" = 0;
                "browser.uidensity" = 1;
                "browser.toolbars.bookmarks.visibility" = "never";
                "browser.ctrlTab.sortByRecentlyUsed" = true;
                "sidebar.verticalTabs" = false;
                "sidebar.visibility" = "hide-launcher";
                "ui.key.menuAccessKeyFocuses" = false;
                "full-screen-api.warning.timeout" = 0;
                "privacy.userContext.enabled" = true;
                "privacy.userContext.ui.enabled" = true;
                # Bookmark menu clicks and Tridactyl would otherwise ask before
                # every ext+container: link, see open-url-in-container#121.
                "network.protocol-handler.external.ext+container" = true;
                "browser.ml.enable" = false;
                "browser.ml.chat.enabled" = false;
                "browser.ml.linkPreview.enabled" = false;
                "browser.tabs.groups.smart.enabled" = false;
                "extensions.ml.enabled" = false;
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
        in
        {
            programs.firefox = {
                enable = true;
                # Registering the style sheet needs privileged autoconfig JS.
                package = pkgs.firefox-devedition.override {
                    extraAutoConfig = ''pref("general.config.sandbox_enabled", false);'';
                };
                nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
                inherit policies;
                # A throw here makes Firefox refuse to start, so the sheet is
                # best effort.
                autoConfig = ''
                    ${renderPrefs "defaultPref" prefs}
                    ${renderPrefs "lockPref" lockedPrefs}

                    try {
                        const sss = Components.classes["@mozilla.org/content/style-sheet-service;1"]
                            .getService(Components.interfaces.nsIStyleSheetService);
                        const uri = Components.classes["@mozilla.org/network/io-service;1"]
                            .getService(Components.interfaces.nsIIOService)
                            .newURI("file://${minimalChrome}");
                        if (!sss.sheetRegistered(uri, sss.USER_SHEET)) {
                            sss.loadAndRegisterSheet(uri, sss.USER_SHEET);
                        }
                    } catch (e) {
                        try { console.error("minimal chrome:", e); } catch (_) {}
                    }
                '';
            };
        };

    # Read through the native messenger and sourced by Tridactyl on every start.
    # `sanitise` first drops anything set by hand, so this file is the whole
    # config.
    flake.modules.hjem.gui.xdg.config.files."tridactyl/tridactylrc".text = ''
        sanitise tridactyllocal tridactylsync

        " Tridactyl updates would otherwise install their own messenger over the
        " nix one in ~/.mozilla/native-messaging-hosts.
        set nativeinstallcmd true

        set newtab about:blank
        set update.nag false
        set theme dark
        set searchengine duckduckgo
        set editorcmd ghostty -e nvim
        " New tabs stay in the container of the tab they were opened from.
        set tabopencontaineraware true

        " Bookmarks open through ext+container:, whose extension closes the tab the
        " link was opened in, so always open them in a new tab.
        bind gb fillcmdline bmarks -t

        " The bookmark containers, so `tabopen -c <space>` works before a bookmark
        " has created them.
        ${lib.concatMapStringsSep "\n" (
            space:
            let
                c = containerOf space;
            in
            "containercreate --or-update ${space.name} ${c.color} ${c.icon}"
        ) checkedSpaces}
    '';
}
