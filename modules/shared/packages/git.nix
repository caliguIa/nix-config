{ ... }:
let
  name = "Cal";
  email = "acc@calrichards.io";
in
{
  enable = true;
  userName = name;
  userEmail = email;
  maintenance = {
    enable = true;
    repositories = [
      "/Users/caligula/ous"
    ];
  };
  extraConfig = {
    init.defaultBranch = "main";
    core = {
      editor = "nvim";
      symlinks = true;
      autocrlf = "input";
    };
    push.autoSetupRemote = true;
  };
  ignores = [
    "env-vars.private.zsh"
    "*.pyc"
    ".DS_Store"
    "Desktop.ini"
    "._*"
    "Thumbs.db"
    ".Spotlight-V100"
    ".Trashes"
    ".vscode"
    "luac.out"
    "*.src.rock"
    "*.zip"
    "*.tar.gz"
    "*.o"
    "*.os"
    "*.ko"
    "*.obj"
    "*.elf"
    "*.gch"
    "*.pch"
    "*.lib"
    "*.a"
    "*.la"
    "*.lo"
    "*.def"
    "*.exp"
    "*.dll"
    "*.so"
    "*.so.*"
    "*.dylib"
    "*.exe"
    "*.out"
    "*.app"
    "*.i*86"
    "*.x86_64"
    "*.hex"
    ".zsh_history"
    "zsh/.config/zsh/plugins/"
    "zsh/.config/zsh/env-vars.local.zsh"
    "nu/Library/Application Support/nu/envars-local.nu"
  ];
}
