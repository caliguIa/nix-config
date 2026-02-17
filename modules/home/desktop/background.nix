{
    flake.modules.homeManager.desktop = {
        services.hyprpaper = {
            enable = true;
            settings = {
                splash = false;
                wallpaper = [
                    {
                        monitor = "";
                        path = "/share/wallpapers/shinchan.jpg";
                        fit_mode = "cover";
                    }
                ];
            };
        };
    };
}
