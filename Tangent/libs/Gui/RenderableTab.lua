local RenderableTab = {}
RenderableTab.__index = RenderableTab

-- Constructor for the RenderableTab
function RenderableTab:new(name)
    local self = setmetatable({}, {__index = self})
    self.name = name or "Tab"
    return self
end

-- Render method for the tab
function RenderableTab:render()
    -- Here you can add the ImGui calls to render the content of the tab
    -- For demonstration, we'll just display the content as text
    ImGui.Text("This tab hasn't been created yet")
end
return RenderableTab