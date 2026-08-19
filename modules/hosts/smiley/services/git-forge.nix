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
                        SSH_DOMAIN = domain;
                    };
                    service = {
                        DISABLE_REGISTRATION = true;
                    };
                    # Public instance: don't leak repo listings to the world.
                    "service.explore".REQUIRE_SIGNIN_VIEW = false;
                    session.COOKIE_SECURE = true;
                    other.SHOW_FOOTER_VERSION = false;
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
