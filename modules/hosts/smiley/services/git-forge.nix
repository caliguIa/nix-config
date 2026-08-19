{
    flake.modules.nixos.host_smiley =
        {
            pkgs,
            config,
            lib,
            ...
        }:
        let
            httpPort = 3000;
            sshPort = 2222;
            domain = "git.calrichards.io";
            turnstileSitekey = "0x4AAAAAAEViLSOyW9m3xbic";
            cfg = config.services.forgejo;
            forgejo = lib.getExe cfg.package;
            ensureUser =
                {
                    username,
                    email,
                    admin ? false,
                    passwordCredential,
                }:
                ''
                    if ! ${forgejo} admin user list \
                        | ${lib.getExe' pkgs.gawk "awk"} 'NR > 1 {print $2}' \
                        | ${lib.getExe' pkgs.gnugrep "grep"} -qx '${username}'; then
                        ${forgejo} admin user create \
                            --username '${username}' \
                            --email '${email}' \
                            --password "$(cat "$CREDENTIALS_DIRECTORY/${passwordCredential}")" \
                            --must-change-password=false \
                            ${lib.optionalString admin "--admin"} \
                            || echo "forgejo-ensure-users: failed to create '${username}' (non-fatal)" >&2
                    fi
                '';
        in
        {
            services.forgejo = {
                enable = true;
                package = pkgs.forgejo;
                database.type = "sqlite3";
                secrets.service.CF_TURNSTILE_SECRET = config.age.secrets.forgejo-turnstile-secret.path;
                settings = {
                    server = {
                        DOMAIN = domain;
                        ROOT_URL = "https://${domain}";
                        HTTP_ADDR = "127.0.0.1";
                        HTTP_PORT = httpPort;
                        START_SSH_SERVER = true;
                        SSH_LISTEN_HOST = "0.0.0.0";
                        SSH_LISTEN_PORT = sshPort;
                        SSH_PORT = sshPort;
                        SSH_DOMAIN = "smiley";
                        LANDING_PAGE = "explore";
                    };
                    service = {
                        DISABLE_REGISTRATION = true;
                        SHOW_REGISTRATION_BUTTON = false;
                        DISABLE_REGULAR_ORG_CREATION = true;
                        ENABLE_CAPTCHA = true;
                        REQUIRE_CAPTCHA_FOR_LOGIN = true;
                        CAPTCHA_TYPE = "cfturnstile";
                        CF_TURNSTILE_SITEKEY = turnstileSitekey;
                    };
                    repository = {
                        DEFAULT_PRIVATE = "public";
                        DEFAULT_PUSH_CREATE_PRIVATE = true;
                        DISABLE_STARS = true;
                        DISABLE_FORKS = true;
                    };
                    ui = {
                        DEFAULT_SHOW_FULL_NAME = false;
                        SHOW_USER_EMAIL = false;
                    };
                    "service.explore".REQUIRE_SIGNIN_VIEW = false;
                    session.COOKIE_SECURE = true;
                    other.SHOW_FOOTER_VERSION = false;

                    # Free in-application hardening (Cloudflare WAF is a paid
                    # add-on). Forgejo has no built-in failed-login lockout, so
                    # mandatory 2FA plus the Turnstile login challenge are the
                    # primary defenses against credential stuffing on the public
                    # login form.
                    security = {
                        GLOBAL_TWO_FACTOR_REQUIREMENT = "all";
                        PASSWORD_CHECK_PWN = true;
                        PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
                        MIN_PASSWORD_LENGTH = 12;
                    };
                };
            };
            systemd.services.forgejo.serviceConfig = {
                LoadCredential = [
                    "caligula-password:${config.age.secrets.forgejo-caligula-password.path}"
                ];
                ExecStartPost = [
                    (lib.getExe (
                        pkgs.writeShellApplication {
                            name = "forgejo-ensure-users";
                            runtimeInputs = [
                                cfg.package
                                pkgs.gawk
                                pkgs.gnugrep
                            ];
                            text = ensureUser {
                                username = "caligula";
                                email = "acc@calrichards.io";
                                admin = true;
                                passwordCredential = "caligula-password";
                            };
                        }
                    ))
                ];
            };
        };
}
