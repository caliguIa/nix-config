{pkgs, ...}: {
    programs.newsboat = {
        enable = true;
        autoReload = true;
        browser = toString (pkgs.writeShellScript "newsboat-url" ''
            url="$1"
            if echo "$url" | grep -q "youtube.com\|youtu.be"; then
                "${pkgs.iina}/bin/iina" "$url"
            else
                "${pkgs.xdg-utils}/bin/xdg-open" "$url"
            fi
        '');
        urls = [
            {
                title = "r/neovim";
                url = "https://www.reddit.com/r/neovim.rss";
                tags = [
                    "tech"
                    "neovim"
                ];
            }
            {
                title = "jackfrags";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCw7FkXsC00lH2v2yB5LQoYA";
                tags = [
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "DEEF";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCwwHaYBJ6UFpBgI6PFEtg-Q";
                tags = [
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "Fin Taylor";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCcQdXzWsosXv_e_wpfZHZlw";
                tags = [
                    "comedy"
                    "history"
                    "youtube"
                ];
            }
            {
                title = "Shortcat";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC62oK4gTQtOE4DvAFbFlt9Q";
                tags = [
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "Posy";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCmEmX_jw_pRp5UbAdzkZq-g";
                tags = [
                    "design"
                    "youtube"
                ];
            }
            {
                title = "Bread on Penguins";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCwHwDuNd9lCdA7chyyquDXw";
                tags = [
                    "tech"
                    "linux"
                    "youtube"
                ];
            }
            {
                title = "Wolfgang's Channel";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsnGwSIHyoYN0kiINAGUKxg";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Tomographic";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCOt5hVyS2-nbcJ3_FP41Ajg";
                tags = [
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "The Studio";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCG7J20LhUeLl6y_Emi7OJrA";
                tags = [
                    "tech"
                    "youtube"
                ];
            }
            {
                title = "Hoog";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCii9ezsUa_mBiSdw0PtSOaw";
                tags = [
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "No Boilerplate";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Theo";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCbRP3c757lWg9M-U7TyEkXA";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Snazzy Labs";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCO2x-p9gg9TLKneXlibGR7w";
                tags = [
                    "tech"
                    "youtube"
                ];
            }
            {
                title = "Rajiv Surendra";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCvnSyOfwtn7J14CYRbCaveQ";
                tags = [
                    "youtube"
                ];
            }
            {
                title = "fern";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCODHrzPMGbNv67e84WDZhQQ";
                tags = [
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "Vimjoyer";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_zBdZ0_H_jn41FDRG7q4Tw";
                tags = [
                    "tech"
                    "linux"
                    "neovim"
                    "youtube"
                ];
            }
            {
                title = "Dreams of Autonomy";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCEEVcDuBRDiwxfXAgQjLGug";
                tags = [
                    "tech"
                    "linux"
                    "youtube"
                ];
            }
            {
                title = "Fireship";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsBjURrPoezykLs9EqgamOA";
                tags = [
                    "tech"
                    "linux"
                    "youtube"
                ];
            }
            {
                title = "Linus Tech Tips";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw";
                tags = [
                    "tech"
                    "youtube"
                ];
            }
            {
                title = "Linus Tech Tips";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw";
                tags = [
                    "tech"
                    "youtube"
                ];
            }
        ];
    };
}
