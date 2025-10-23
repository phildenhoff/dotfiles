local wezterm = require 'wezterm'
local segments = require 'segments'

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

wezterm.on('update-status',
  function(window, pane)
    -- collect all the required segments
    local segs = segments.get_right_status_segments(window, pane)
    -- fetch the current color scheme at runtime
    local color_scheme = window:effective_config().resolved_palette

    -- wezterm.color.parse returns a Color object, which we can
    -- lighten or darken (amongst other things).
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg, bg
    if is_appearance_dark() then
      gradient_from = gradient_to:lighten(0.15)
    else
      gradient_from = gradient_to:darken(0.15)
    end
    local gradient = wezterm.color.gradient(
      {
        orientation = 'Horizontal',
        colors = { gradient_from, gradient_to },
      },
      #segs -- as many colours as no. of segments
    )

    -- Build up the elements to send to wezterm.format
    local elements = {}

    for i, seg in ipairs(segs) do
      local is_first = i == 1

      if is_first then
        table.insert(elements, { Background = { Color = 'none' } })
      end
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = '' })

      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end
    window:set_right_status(wezterm.format(elements))

    window:set_left_status('')
  end
)

return {
  color_scheme = config.color_scheme,
  enable_tab_bar = true,
  show_tabs_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
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
