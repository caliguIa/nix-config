{
    flake.modules.hjem.core = {pkgs, ...}: let
        toml = pkgs.formats.toml {};
    in {
        packages = [pkgs.yazi];
        xdg.config.files = {
            "yazi/yazi.toml" = {
                generator = toml.generate "yazi.toml";
                value.mgr = {
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
            "yazi/keymap.toml" = {
                generator = toml.generate "keymap.toml";
                value.mgr.prepend_keymap = [
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
