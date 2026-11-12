-- Colours mirror modules/system/core/nvim/lua/colors/noir.lua
local c = {
	noir_3 = '#b2b2b2',
	noir_4 = '#9e9e9e',
	noir_5 = '#8a8a8a',
	noir_6 = '#767676',
	noir_7 = '#585858',
}

-- Greyscale icons, as MiniIcons is in nvim: directories bright, files dim.
function Entity:icon()
	local icon = th.icon:match(self._file, { hovered = self._file.is_hovered })
	if not icon then
		return ''
	elseif self._file.is_hovered then
		return icon.text .. ' '
	end
	return ui.Line(icon.text .. ' '):fg(self._file.cha.is_dir and c.noir_3 or c.noir_5)
end

-- Size and modified time beside every entry (mgr.linemode = "size_mtime").
function Linemode:size_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	local mtime
	if time == 0 then
		mtime = ''
	elseif os.date('%Y', time) == os.date('%Y') then
		mtime = os.date('%d %b %H:%M', time)
	else
		mtime = os.date('%d %b  %Y', time)
	end
	return ui.Line {
		ui.Span(string.format('%6s', self:size())):fg(c.noir_4),
		'  ',
		ui.Span(mtime):fg(c.noir_6),
	}
end

-- owner:group of the hovered file, left of the permissions in the status bar.
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or not ya.user_name then
		return ''
	end
	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg(c.noir_5),
		ui.Span(':'):fg(c.noir_7),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg(c.noir_5),
		' ',
	}
end, 500, Status.RIGHT)

-- Git status signs after the linemode (solo = 1000, padding = 2000).
require('git'):setup { order = 1500 }
