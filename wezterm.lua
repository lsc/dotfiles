local wezterm = require("wezterm")

return {
    send_composed_key_when_left_alt_is_pressed = true,
    swap_backspace_and_delete = false,
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    show_update_window = false,
    font = wezterm.font({
        family = "Fira Code",
        weight = 450,
        harfbuzz_features = { "zero", "onum", "ss02", "ss03", "ss04", "ss05", "ss08" },
    }),
    font_size = 14,
    color_scheme = "nord",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
