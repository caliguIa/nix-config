{pkgs, ...}: {
    programs.newsboat = {
        enable = false;
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
                    "reddit"
                ];
            }
            {
                title = "r/NixOS";
                url = "https://www.reddit.com/r/NixOS.rss";
                tags = [
                    "tech"
                    "reddit"
                ];
            }
            {
                title = "r/LeCarre";
                url = "https://www.reddit.com/r/LeCarre.rss";
                tags = [
                    "literature"
                    "reddit"
                ];
            }
            {
                title = "hacker news";
                url = "https://hnrss.org/frontpage";
                tags = [
                    "tech"
                    "developer"
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
                    "developer"
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
                    "developer"
                    "neovim"
                    "youtube"
                ];
            }
            {
                title = "Dreams of Autonomy";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCEEVcDuBRDiwxfXAgQjLGug";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Fireship";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsBjURrPoezykLs9EqgamOA";
                tags = [
                    "tech"
                    "developer"
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
                title = "CaspianReport";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCwnKziETDbHJtx78nIkfYug";
                tags = [
                    "news"
                    "geopolitics"
                    "youtube"
                ];
            }
            {
                title = "Simple History";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC510QYlOlKNyhy_zdQxnGYw";
                tags = [
                    "history"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "Veritasium";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCHnyfMqiRRG1u-2MsSQLbXA";
                tags = [
                    "science"
                    "youtube"
                ];
            }
            {
                title = "Sam Morril";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCTrOYaMDI7QiPnRzwWdYK6Q";
                tags = [
                    "comedy"
                    "youtube"
                ];
            }
            {
                title = "bashbunni";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9H0HzpKf5JlazkADWnW1Jw";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "KRAZAM";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCgBVkKoOAr3ajSdFFLp13_A";
                tags = [
                    "comedy"
                    "youtube"
                ];
            }
            {
                title = "TechLinked";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCeeFfhMcJa1kjtfZAGskOCA";
                tags = [
                    "news"
                    "tech"
                    "youtube"
                ];
            }
            {
                title = "Ableton";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCgWZYUZjiidjWgfs95pJrWg";
                tags = [
                    "music_production"
                    "youtube"
                ];
            }
            {
                title = "Sylvan Franklin";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC04nROIJrY22Gl2aFqKcdqQ";
                tags = [
                    "developer"
                    "neovim"
                    "youtube"
                ];
            }
            {
                title = "CinemaStix";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCzjbia0NqUsSL1_-loJihMg";
                tags = [
                    "film"
                    "review"
                    "youtube"
                ];
            }
            {
                title = "Matt Pocock";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCswG6FSbgZjbWtdf_hMLaow";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Xiaomanyc 小马在纽约";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCLNoXf8gq6vhwsrYp-l0J-Q";
                tags = [
                    "language"
                    "youtube"
                ];
            }
            {
                title = "optimum";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCRYOj4DmyxhBVrdvbsUwmAA";
                tags = [
                    "tech"
                    "youtube"
                ];
            }
            {
                title = "Kay Lack";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7UukP_hxrOsrwHrcHxOxxg";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "DevOps Toolbox";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYeiozh-4QwuC1sjgCmB92w";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Jago Hazzard";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCcHuNKYzVMc06FXqsBEAV3A";
                tags = [
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "bigboxSWE";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5--wS0Ljbin1TjWQX6eafA";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "videogamedunkey";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg";
                tags = [
                    "comedy"
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "Dorian Concept";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCIUVjpgIx2vKOhDw53mqn6w";
                tags = [
                    "music"
                    "youtube"
                ];
            }
            {
                title = "Boylei Hobby Time";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCLLHnS6pKU4GdGEZjysogqQ";
                tags = [
                    "creator"
                    "design"
                    "youtube"
                ];
            }
            {
                title = "Mitchell Hashimoto";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC0gjVbm7HY5GzDTo5NbQruA";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "Kurzgesagt – In a Nutshell";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q";
                tags = [
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "Boot.dev";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9HOZ53gnHP3f_b-wixS74g";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "cs615asa";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCK9UCt1zAQ9JvTG0o6Z8zpg";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "History in Bits";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCPhQgj1dPafIvkj7Viy6cGQ";
                tags = [
                    "history"
                    "youtube"
                ];
            }
            {
                title = "The Intel Report";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7Ay_bxnYWSS9ZDPpqAE1RQ";
                tags = [
                    "history"
                    "military"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "Let's Get Rusty";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCSp-OaMpsO8K0KkOqyBl7_w";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "The Present Past";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5Axef4J11DIu17y2RKVqNQ";
                tags = [
                    "history"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "DIY Perks";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUQo7nzH1sXVpzL92VesANw";
                tags = [
                    "creator"
                    "design"
                    "youtube"
                ];
            }
            {
                title = "Highlight History";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCnb-VTwBHEV3gtiB9di9DZQ";
                tags = [
                    "history"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "The Operations Room";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCnZJt7yQw5IztVwe-Dscd-Q";
                tags = [
                    "military"
                    "history"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "Practical Engineering";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCMOqf8ab-42UUQIdVoKwjlQ";
                tags = [
                    "science"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "TJ DeVries";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCd3dNckv1Za2coSaHGHl5aA";
                tags = [
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "RealLifeLore";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCP5tjEmvPItGyLhmjdwP7Ww";
                tags = [
                    "documentary"
                    "history"
                    "geopolitics"
                    "youtube"
                ];
            }
            {
                title = "OverSimplified";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNIuvl7V8zACPpTmmNIqP2A";
                tags = [
                    "documentary"
                    "history"
                    "youtube"
                ];
            }
            {
                title = "Historia Civilis";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCv_vLHiWVBh_FR9vbeuiY-A";
                tags = [
                    "documentary"
                    "history"
                    "youtube"
                ];
            }
            {
                title = "History Matters";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC22BdTgxefuvUivrjesETjg";
                tags = [
                    "documentary"
                    "history"
                    "youtube"
                ];
            }
            {
                title = "Jay Foreman";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCbbQalJ4OaC0oQ0AqRaOJ9g";
                tags = [
                    "documentary"
                    "history"
                    "geopolitics"
                    "youtube"
                ];
            }
            {
                title = "Johnny Harris";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCmGSJVG3mCRXVOP4yZrU1Dw";
                tags = [
                    "documentary"
                    "history"
                    "geopolitics"
                    "youtube"
                ];
            }
            {
                title = "3Blue1Brown";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw";
                tags = [
                    "maths"
                    "science"
                    "youtube"
                ];
            }
            {
                title = "BobbyBroccoli";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCSPLhwvj0gBufjDRzSQb3GQ";
                tags = [
                    "science"
                    "documentary"
                    "youtube"
                ];
            }
            {
                title = "David Bruce Composer";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCh-PyMficPzVAihCJkFJVAA";
                tags = [
                    "music_production"
                    "youtube"
                ];
            }
            {
                title = "Nahre Sol";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8R8FRt1KcPiR-rtAflXmeg";
                tags = [
                    "music_production"
                    "youtube"
                ];
            }
            {
                title = "Dr Geoff Lindsey";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCtFuCBKQTItHCwfHRP9LIjQ";
                tags = [
                    "language"
                    "youtube"
                ];
            }
            {
                title = "Ben Vallack";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC4NNPgQ9sOkBjw6GlkgCylg";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
            {
                title = "NorthernLion";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC3tNpTOHsTnkmbwztCs30sA";
                tags = [
                    "gaming"
                    "youtube"
                ];
            }
            {
                title = "Sam O'Nella Crosswords";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJtMAxpDiq9Goxj9F_GSE6g";
                tags = [
                    "puzzles"
                    "youtube"
                ];
            }
            {
                title = "Minute Cryptic";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5MqhxfGwksL2ze71gNSCAw";
                tags = [
                    "puzzles"
                    "youtube"
                ];
            }
            {
                title = "ThePrimeTime";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUyeluBRhGPCW4rPe_UvBZQ";
                tags = [
                    "tech"
                    "developer"
                    "youtube"
                ];
            }
        ];
    };
}
