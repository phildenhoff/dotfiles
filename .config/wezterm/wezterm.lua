local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
    { key = 'v', mods = 'CTRL|ALT|CMD|SHIFT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = 'h', mods = 'CTRL|ALT|CMD|SHIFT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  },
  font = wezterm.font_with_fallback {
    'Zed Mono',
    -- 'Fira Code',
    'Apple Color Emoji'
  },
  font_size = 13,
  -- Light mode
  -- color_scheme = 'Catppuccin Latte',
  -- Dark mode
  color_scheme = 'Catppuccin Mocha',
  harfbuzz_features = { 'zero' },
}
