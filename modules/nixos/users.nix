{
  users = {
    users = {
      caligula = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "share"
        ];
      };
      share = {
        isSystemUser = true;
        group = "share";
        uid = 994;
      };
    };
    groups = {
      share = {
        gid = 993;
      };
    };
  };
}