local imgui = require 'ImGui'
local gui = {
    Name = "Gui",
    Title = "Gui",
    OpenGui = false,
    Tabs = {},
    AddTab = function (self,renderable)
        table.insert(self.Tabs,renderable)
        return #self.Tabs
    end,
    RemoveTab = function (self,index)
        self.Tabs:remove(index)
    end,
    Draw = function (self)
        local shouldDrawGui = false
        self.OpenGui,shouldDrawGui = ImGui.Begin(self.Title,self.OpenGui)
        if shouldDrawGui then
            ImGui.BeginTabBar("#Tabs")
            for _, value in pairs(self.Tabs) do
                value:RenderTab(self)
            end
            ImGui.GetWindowPos()
        end
        ImGui.End()
    end,
    ToggleGui = function (self)
        self.OpenGui = not self.OpenGui
    end,
    Initialize = function (self,name,title,command)
        self.Name = name
        mq.imgui.init(name,function() self:Draw() end)
        if title then
            self.Title = title
        end
        if command then
            if command:sub(1,1) ~= "/" then
                command = "/"..command
            end
            mq.bind(command,function()self:ToggleGui() end)
        else
            mq.bind("gui",function()self:ToggleGui() end)
        end
    end
}

return gui