local wezterm = require 'wezterm';

return {
  color_scheme = "Catppuccin Mocha",
  -- color_scheme = "Catppuccin Mocha",
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  window_background_opacity = 1,
  window_decorations = "RESIZE",
  front_end = "WebGpu",
  keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = "LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"} },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = "RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"} },
    -- Command+Left goes to start of line
    { key = "LeftArrow", mods = 'CMD', action = wezterm.action { SendString = "\x1bOH" } },
    -- Command+Right goes to end of line
    { key = "RightArrow", mods = 'CMD', action = wezterm.action { SendString = "\x1bOF" } }
  }
}
