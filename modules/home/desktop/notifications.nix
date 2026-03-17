{
    flake.modules.homeManager.desktop = {
        stylix.targets.mako.enable = true;
        services.mako = {
            enable = true;
            settings = {
                border-radius = 0;
                height = 100;
                default-timeout = 5000;
                ignore-timeout = false;
                layer = "top";
                margin = 10;
                markup = true;
                padding = 8;
                width = 500;

                "app-name=wp-vol" = {
                    layer = "overlay";
                    history = 0;
                    anchor = "top-center";
                    # Group all volume notifications together
                    group-by = "app-name";
                    # Hide the group-index
                    format = "<b>%s</b>\\n%b";
                };
                "app-name=volume group-index=0" = {
                    # Only show last notification
                    invisible = 0;
                };
                "app-name=volume grouped=false" = {
                    # Force initial volume notification to be visible
                    invisible = 0;
                };

                "app-name=bctl-notif" = {
                    layer = "overlay";
                    history = 0;
                    anchor = "top-center";
                    # Group all brightness notifications together
                    group-by = "app-name";
                    # Hide the group-index
                    format = "<b>%s</b>\\n%b";
                };
                "app-name=brightness group-index=0" = {
                    # Only show last notification
                    invisible = 0;
                };
                "app-name=brightness grouped=false" = {
                    # Force initial brightness notification to be visible
                    invisible = 0;
                };

                "category=email.arrived" = {
                    default-timeout = 0;
                    on-button-left = "invoke-action mail-reply-sender";
                };
            };
        };
    };
}
