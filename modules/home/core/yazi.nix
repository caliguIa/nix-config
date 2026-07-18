{
    flake.modules.hjem.core = {pkgs, ...}: let
        toml = (pkgs.formats.toml {}).generate;
    in {
        packages = [pkgs.yazi];
        xdg.config.files = {
            "yazi/yazi.toml".source = toml "yazi.toml" {
                mgr = {
                    ratio = [1 4 3];
                    show_hidden = true;
                    sort_by = "natural";
                    sort_sensitive = false;
                    sort_dir_first = true;
                    sort_translit = true;
                    sort_reverse = false;
                    linemode = "size_and_mtime";
                    show_symlink = true;
                };
            };
            "yazi/keymap.toml".source = toml "keymap.toml" {
                mgr.prepend_keymap = [
                    {
                        run = ''shell -- qlmanage -p "$@"'';
                        on = ["<C-p>"];
                    }
                ];
            };
            "yazi/init.lua".text = ''
                function Linemode:size_and_mtime()
                local time = math.floor(self._file.cha.mtime or 0)
                if time == 0 then
                	time = ""
                elseif os.date("%Y", time) == os.date("%Y") then
                	time = os.date("%b %d %H:%M", time)
                else
                	time = os.date("%b %d  %Y", time)
                end

                local size = self._file:size()
                return string.format("%s %s", size and ya.readable_size(size) or "-", time)
                end
            '';
        };
    };
}
