local wezterm = require("wezterm")
local sessionizer = wezterm.plugin.require("https://github.com/ElCapitanSponge/sessionizer.wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

local home = os.getenv("HOME")

--- maximize on creation
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.launch_menu = {
	{
		label = "WezTerm Config",
		args = { home .. "/.nix-profile/bin/nvim", home .. "/nix-config/modules/shared/files/wezterm.lua" },
		cwd = home .. "/nix-config",
	},
	{
		label = "OUS merge in main",
		args = { "zsh", "-c", "git fetch && git pull && git merge origin/main" },
		cwd = home .. "/oneupsales",
	},
	{
		label = "OUS bounce",
		args = { "zsh", "-c", "make down && make platform-up" },
		cwd = home .. "/oneupsales",
	},
	{
		label = "Nix build switch",
		args = { "zsh", "-c", "git add . && nix run .#build-switch" },
		cwd = home .. "/nix-config",
	},
	{
		label = "OUS work",
		args = { "zsh", "-c", "wezterm cli split-pane --right -- cd platform && vim" },
		cwd = home .. "/oneupsales",
	},
}
-- Define your workspace layouts
local workspaces = {
	ous = {
		name = "OUS",
		setup = function()
			local project_root = wezterm.home_dir .. "/oneupsales"
			local tab, _, _ = mux.spawn_window({
				workspace = "ous",
				cwd = project_root .. "/platform",
				-- args = { "nvim" },
			})
			local startup_split = tab:split({
				direction = "Right",
				size = 0.2,
				cwd = project_root,
			})
			startup_split:send_text("make platform-up\n")
		end,
	},
}

-- font
config.font = wezterm.font("BerkeleyMono Nerd Font")
config.font_size = 13
config.line_height = 1.6
-- window
config.color_scheme = "Catppuccin Mocha"
config.default_cursor_style = "BlinkingBar"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0
-- config.initial_cols = 500
-- config.initial_rows = 500
-- render
config.term = "wezterm"
config.animation_fps = 120
config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
-- keymaps
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "workspace_launcher",
			one_shot = true,
		}),
	},
	{
		mods = "LEADER",
		key = "r",
		action = act.ShowLauncherArgs({
			title = "RUN...",
			flags = "FUZZY|LAUNCH_MENU_ITEMS",
		}),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "v",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "m",
		action = act.TogglePaneZoomState,
	},
	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "h",
		mods = "CMD|CTRL|SHIFT|OPT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CMD|CTRL|SHIFT|OPT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CMD|CTRL|SHIFT|OPT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CMD|CTRL|SHIFT|OPT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "H",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Left", 15 }),
	},
	{
		key = "J",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Down", 15 }),
	},
	{
		key = "K",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Up", 15 }),
	},
	{
		key = "L",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Right", 15 }),
	},
}
config.key_tables = {
	workspace_launcher = {
		{ key = "c", action = act.EmitEvent("create-coding-workspace") },
	},
}
-- Handle workspace creation events
wezterm.on("create-coding-workspace", function(window, pane)
	workspaces.ous.setup()
end)
-- session persistence
-- config.unix_domains = {
-- 	{
-- 		name = "unix",
-- 	},
-- }
-- config.default_gui_startup_args = { "connect", "unix" }
-- sessionizer
local projects = {
	"~/oneupsales",
	"~/.config",
	"~",
	"~/dev",
}
sessionizer.set_projects(projects)
sessionizer.configure(config)

return config
