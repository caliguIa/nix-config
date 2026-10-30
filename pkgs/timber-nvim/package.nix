{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
    pname = "timber-nvim";
    version = "0-unstable-2026-05-21";
    src = fetchFromGitHub {
        owner = "Goose97";
        repo = "timber.nvim";
        rev = "feb2a84a6806fa336f153a9f627d8da80f033555";
        hash = "sha256-HPUQwGAzYZfBcjKU99fMejjs5h5YgMvKaBuRrQUYqkM=";
    };
    # requires plenary.job, which isn't installed; only timber's (unused) log watcher needs it
    nvimSkipModules = [ "timber.watcher.sources.filesystem" ];
    meta.homepage = "https://github.com/Goose97/timber.nvim";
}
