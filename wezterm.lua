local wezterm = require("wezterm")

return {
	send_composed_key_when_left_alt_is_pressed = true,
	swap_backspace_and_delete = false,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = true,
	show_update_window = false,
	font = wezterm.font({
		family = "Berkeley Mono",
		weight = "Regular",
		harfbuzz_features = { "zero", "onum", "ss02", "ss03", "ss04", "ss05", "ss08" },
	}),
	font_size = 17,
	color_scheme = "Catppuccin Frappe",
	window_padding = {
		left = 20,
		right = 20,
		top = 10,
		bottom = 10,
	},
	mouse_bindings = {
		-- Ctrl Click will open the link in the default browser
		{
			event = { Up = { streak = 1, button = "Left", mods = "Ctrl" } },
			mods = "CTRL",
			action = "OpenLinkAtMouseCursor",
		},
	},
}
