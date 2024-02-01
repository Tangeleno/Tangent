
local ImGui = require("ImGui")

---@class Window
Window = {}
Window.__index = Window

-- Singleton instance
---@class Window
local instance = setmetatable({tabs = {}, isOpen = true, initialized = false}, Window)

-- Public Initialize function
function Window.initialize(title)
    instance.title = title
    instance.initialized = true
    instance.isOpen = true -- You can manage other states like collapsed, etc.

    -- Register the window with ImGui
    ImGui.Register(instance.title, Window.render)
end

-- Add a tab to the window
function Window.AddTab(name, renderable)
    instance.tabs[name] = renderable
end

function Window.IsOpen()
    return instance.isOpen
end

-- Remove a tab from the window
function Window.RemoveTab(name)
    instance.tabs[name] = nil
end

-- Render the window
function Window.render()
    if not instance.initialized or not instance.isOpen then return end
    local shouldDraw
    instance.isOpen, shouldDraw = ImGui.Begin(instance.title, instance.isOpen)

    -- Generate the tab control
    if shouldDraw then
        if ImGui.BeginTabBar("##Tabs") then
            for name, renderable in pairs(instance.tabs) do
                if ImGui.BeginTabItem(name) then
                    -- Call render on each tab
                    renderable:render()
                    ImGui.EndTabItem()
                end
            end
            ImGui.EndTabBar()
        end
    end
    ImGui.End()
end