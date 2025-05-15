{
  # NOTE: need to run `sudo smbpasswd -a <username>` to be able to log in
  services.samba = {
    enable = true;
    settings = {
      "audiobooks" = {
        "path" = "/home/audiobooks";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "movies" = {
        "path" = "/home/movies";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "tv" = {
        "path" = "/home/tv";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };
}