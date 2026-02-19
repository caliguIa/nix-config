{
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        lib,
        ...
    }: {
        accounts.contact.basePath = "${config.xdg.dataHome}/contacts";
        accounts.contact.accounts.personal = {
            remote = {
                userName = "cal@calrichards.io";
                passwordCommand = ["sh" "-c" "${pkgs.coreutils}/bin/cat ${config.age.secrets.token-fastmail-vdirsyncer-carddav.path}"];
                url = "https://carddav.fastmail.com/";
                type = "carddav";
            };
            local = {
                type = "filesystem";
                fileExt = ".vcf";
            };
            vdirsyncer = {
                enable = true;
                collections = [["personal" "Default" "personal"]];
                conflictResolution = "remote wins";
                metadata = ["displayname"];
            };
            khard.enable = true;
        };
        programs.vdirsyncer.enable = true;
        services.vdirsyncer.enable = true;

        # Put this contacts account on vdirsyncer's radar
        systemd.user.services.vdirsyncer.Service.ExecStart = lib.mkBefore [
            (lib.getExe (pkgs.writeShellApplication {
                name = "vdirsyncer-discover-contacts";
                runtimeInputs = [pkgs.vdirsyncer];
                text = "yes | vdirsyncer discover contacts_personal || true";
            }))
        ];

        programs.khard.enable = true;
        xdg.configFile."khard/khard.conf".text = lib.mkForce ''
            [addressbooks]
            [[personal]]
            path = ${config.xdg.dataHome}/contacts/personal/personal

            [general]
            default_action=list
            editor=nvim, -i, NONE

            [contact table]
            display=formatted_name
            preferred_email_address_type=pref, work, home
            preferred_phone_number_type=pref, cell, home

            [vcard]
            private_objects=Jabber, Skype, Twitter
        '';
    };
}
