let
    users = {
        caligula = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex";
        caligula_george = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcCe1WprfC6Ubn/svqx2xaw3WdGnLiesEcuGfQSbpHd";
    };
    systems = {
        karla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjJuY81Rz/0IiKRMTcrD49wEedXtyUVqh63Xpv1Wj2z";
        george = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJUX/lSF4W+/sLzmAOS6c1eyNmshv2IyhjQmcrBW8nu";
    };
    allUsers = builtins.attrValues users;
    allSystems = builtins.attrValues systems;
in {
    "passwordfile-caligula.age".publicKeys = allUsers ++ allSystems;
    "token-fastmail-vdirsyncer-carddav.age".publicKeys = allUsers ++ allSystems;
    "token-fastmail-vdirsyncer-caldav.age".publicKeys = allUsers ++ allSystems;
    "token-fastmail-aerc.age".publicKeys = allUsers ++ allSystems;
    "token-fastmail-mbsync.age".publicKeys = allUsers ++ allSystems;
    "intelephense.age".publicKeys = allUsers ++ allSystems;
}
