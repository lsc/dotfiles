local wezterm = require("wezterm")
local act = wezterm.action

return {
	send_composed_key_when_left_alt_is_pressed = true,
	swap_backspace_and_delete = false,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	show_update_window = false,
	font = wezterm.font({
		family = "Jetbrains Mono NL",
		weight = "DemiLight",
		harfbuzz_features = { "zero", "onum", "ss02", "ss03", "ss04", "ss05", "ss08" },
	}),
	-- keys = {
	-- 	{ key = "t", mods = "SUPER", action = act.SpawnTab("DefaultDomain") },
	-- },
	font_size = 18,
	color_scheme = "kanagawabones",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
