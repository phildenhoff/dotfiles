local wezterm = require 'wezterm';

local config = wezterm.config_builder()

local function is_appearance_dark()
  local apperance = (wezterm.gui and wezterm.gui.get_appearance()) or 'Light'
  return apperance:find("Dark")
end

if is_appearance_dark() then
  config.color_scheme = "Catppuccin Mocha"
else 
  config.color_scheme = "Catppuccin Latte"
end


return {
  color_scheme = config.color_scheme,
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
