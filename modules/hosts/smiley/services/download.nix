{
    flake.modules.nixos.host_smiley =
        {
            pkgs,
            lib,
            config,
            mediaService,
            mediaDir,
            slskdImport,
            ntfyPublish,
            ...
        }:
        let
            mediaRoot = "/data/media";
            categories = [
                "movies"
                "tv"
                "audiobooks"
                "books"
                "comics"
            ];

            # Post-processing script run by SABnzbd (as the media user) after a job
            # completes. Moves the finished job's contents into the matching
            # /data/media/<category> library folder, leaving the files owned by
            # media:media. SABnzbd exports SAB_* env vars describing the job; we use
            # those rather than positional args for clarity.
            #   SAB_COMPLETE_DIR  final job directory (absolute)
            #   SAB_CAT           user-defined category
            #   SAB_FINAL_NAME    clean job name
            #   SAB_PP_STATUS     0 = OK, non-zero = failed verify/unpack/pp
            postprocess = pkgs.writeShellApplication {
                name = "sabnzbd-postprocess";
                runtimeInputs = [
                    pkgs.coreutils
                    ntfyPublish
                ];
                text = ''
                    root=${mediaRoot}
                    dir="''${SAB_COMPLETE_DIR:-}"
                    cat="''${SAB_CAT:-}"
                    name="''${SAB_FINAL_NAME:-''${dir##*/}}"
                    status="''${SAB_PP_STATUS:-0}"

                    fail() {
                        echo "sabnzbd-postprocess: $1" >&2
                        ntfy-publish smiley-downloads "Download failed" "x,warning" "$name: $1"
                        exit 1
                    }

                    # SABnzbd reports a non-zero status when verify/unpack/repair
                    # failed. Leave the (possibly partial) job in place for manual
                    # inspection rather than moving broken files into the library.
                    if [ "$status" != "0" ]; then
                        fail "post-processing status $status (verify/unpack failed); leaving in place"
                    fi

                    [ -n "$dir" ] || fail "SAB_COMPLETE_DIR is empty"
                    [ -d "$dir" ] || fail "job directory does not exist: $dir"
                    [ -n "$cat" ] || fail "no category set for job"

                    # Only handle known 1:1 categories. Anything else (including
                    # "music", handled by beets) is left untouched.
                    case "$cat" in
                    ${lib.concatMapStringsSep "\n                    " (c: "${c}) : ;;") categories}
                        *)
                            echo "sabnzbd-postprocess: category '$cat' not managed; leaving $dir in place"
                            exit 0
                            ;;
                    esac

                    dest="$root/$cat"
                    mkdir -p "$dest"

                    echo "==> Moving '$name' ($cat) -> $dest/"

                    target="$dest/$name"
                    if [ -e "$target" ]; then
                        fail "destination already exists: $target"
                    fi
                    if ! mv -- "$dir" "$target"; then
                        fail "move failed: $dir -> $target"
                    fi

                    ntfy-publish smiley-downloads "Download complete" "white_check_mark" \
                        "$name moved to $cat"
                    echo "==> Done"
                '';
            };

            scriptDir = pkgs.linkFarm "sabnzbd-scripts" [
                {
                    name = "sabnzbd-postprocess";
                    path = lib.getExe postprocess;
                }
            ];

            categoryConfig = lib.listToAttrs (
                map (c: {
                    name = c;
                    value = {
                        name = c;
                        script = "sabnzbd-postprocess";
                        dir = c;
                        pp = 3;
                        priority = 0;
                        newzbin = "";
                    };
                }) categories
            );
        in
        {
            systemd.tmpfiles.rules = map mediaDir [
                "/data/downloads"
                "/data/downloads/complete"
                "/data/downloads/complete/movies"
                "/data/downloads/complete/tv"
                "/data/downloads/complete/audiobooks"
                "/data/downloads/complete/books"
                "/data/downloads/complete/comics"
                "/data/downloads/complete/music"
                "/data/downloads/incomplete"
            ];
            services.sabnzbd = mediaService {
                configFile = null;
                settings = {
                    misc = {
                        host = "127.0.0.1";
                        port = 8085;
                        host_whitelist = "sabnzbd.smiley.calrichards.io";
                        # Where SABnzbd looks for post-processing scripts.
                        script_dir = toString scriptDir;
                        # Base folder for completed jobs; per-category `dir` values
                        # are resolved relative to this.
                        complete_dir = "/data/downloads/complete";
                        download_dir = "/data/downloads/incomplete";
                    };
                    categories = categoryConfig;
                };
            };
            services.slskd = mediaService {
                environmentFile = config.age.secrets.slskd-envars.path;
                domain = null;
                settings = {
                    directories.downloads = "/data/downloads/complete/music";
                    directories.incomplete = "/data/downloads/incomplete";
                    integration.scripts.beets-import = {
                        on = [ "DownloadDirectoryComplete" ];
                        run.executable = lib.getExe slskdImport;
                    };
                };
            };
            services.qbittorrent = mediaService {
                webuiPort = 8080;
                serverConfig = {
                    LegalNotice.Accepted = true;
                    Preferences = {
                        General.Locale = "en";
                        IPFilter.BannedIPs = "";
                        WebUI = {
                            Address = "127.0.0.1";
                            Username = "admin";
                            Password_PBKDF2 = "@ByteArray(+1ZSiSWMaiWPiLNWIHNcug==:usRLXuCrx/sxOTZ+SiM9qvT32DSVxGQWbu2pZZrOI4Fi2PXFjF6PjzoBridfI70z/CqPt9XS7ERMcould3DCMw==)";
                            AlternativeUIEnabled = true;
                            RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
                            BanDuration = 10;
                        };
                    };
                };
            };
        };
}
