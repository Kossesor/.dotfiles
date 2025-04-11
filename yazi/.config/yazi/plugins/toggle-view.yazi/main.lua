--- @sync entry
-- Toggle different views on/off: parent, current, preview
local function entry(st, job)
  local args = job.args or job
  local action = args[1]
  if not action then
    return
  end

  if st.view == nil then
    st.old_parent = MANAGER.ratio.parent
    st.old_current = MANAGER.ratio.current
    st.old_preview = MANAGER.ratio.preview

    -- Get current tab ratios
    local all_old = st.old_parent + st.old_current + st.old_preview
    local area = ui.Rect { x= 0, y = 0, w = all_old, h = 10 }
    local tab = Tab:new(area, cx.active)
    st.parent = tab._chunks[1].w
    st.current = tab._chunks[2].w
    st.preview = tab._chunks[3].w
    st.layout = Tab.layout
    st.view = true -- initialized
  end

  if action == "parent" then
    st.parent = st.parent > 0 and 0 or st.old_parent
  elseif action == "current" then
    st.current = st.current > 0 and 0 or st.old_current
  elseif action == "preview" then
    st.preview = st.preview > 0 and 0 or st.old_preview
  elseif action == "all" then
    st.parent = st.parent > 0 and 0 or st.old_parent
    st.current = st.current > 0 and 0 or st.old_current
    st.preview = st.preview > 0 and 0 or st.old_preview
  elseif action == "image" then
    st.parent = st.parent > 0 and 0 or st.old_parent
    st.current = st.current > 0 and 0 or st.old_current
    st.preview = st.preview > 0 and st.old_preview or 0
  else
    return
  end
  Tab.layout = function(self)
    local all = st.parent + st.current + st.preview
    self._chunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
        ui.Constraint.Ratio(st.parent, all),
        ui.Constraint.Ratio(st.current, all),
        ui.Constraint.Ratio(st.preview, all),
      })
      :split(self._area)
  end
	ya.app_emit("resize", {})
end

local function enabled(st) return st.view ~= nil end

return { entry = entry, enabled = enabled }
