local wezterm = require 'wezterm'

local M = {}

-- Cache for right status segments
local cache = {
  kube = '',
  memory = '',
  day = '',
  last_update_ms = 0,
}

local function get_current_kube_context()
  -- the below command will give us the following output:
  -- saas-qa01-aks\n
  local pcall_ok, success, output, _ = pcall(wezterm.run_child_process, {
    'kubectl',
    'config',
    'current-context'
  })

  if not pcall_ok then
    return ''
  end

  if not success or not output or output == "" then
    return ""
  end

  -- Trim whitespace from both ends
  return '󱃾 ' .. output:match("^%s*(.-)%s*$")
end

-- Returns true if we should refresh based on the effective status update interval
local function is_stale(window)
  local now_ms = os.time() * 1000
  local interval_ms = window:effective_config().status_update_interval
  return (now_ms - cache.last_update_ms) >= interval_ms
end

local function refresh_cache()
  -- Update synchronously; this runs at most as often as status_update_interval
  cache.kube = get_current_kube_context() or ''
  cache.day = wezterm.strftime(' %a, %b %-d')
  cache.last_update_ms = os.time() * 1000
  cache.minute = wezterm.strftime('%R %p')
end

function M.get_right_status_segments(window, pane)
  local items = {}
  -- we can use `cols` to do conditional rendering of segments
  -- local cols = window:mux_window():active_tab():get_size().cols

  if is_stale(window) then
    refresh_cache()
  end

  items = {
    cache.kube,
    cache.memory,
    cache.minute,
    cache.day,
  }

  -- Build segments and filter out empty values to avoid duplicate checks
  local result = {}
  for _, v in ipairs(items) do
    if v and v ~= '' then
      table.insert(result, v)
    end
  end
  return result
end

return M

