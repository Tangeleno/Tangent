local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"
---@class SelectNode
local SelectNode = {}
---@param name string @Name of the Select node
---@return SelectNode @The created SelectNode instance
function SelectNode.new(name)
    ---@class SelectNode:CompositeNode @Returns the first successful child or failure if all children fail
    local self = CompositeNode.new(name)
    self.NodeType = "SelectNode"
    mq.Write.Trace("Creating %s: %s", self.NodeType, self.Name)
    function self._OnInitialize(blackboard)
        self.CurrentChildIndex = 1
    end

    ---@return NodeState
    function self._Update(blackboard)
        for _, child in ipairs(self.Children) do
            local status = child.Tick(blackboard)
            if child.IsSuccess() or child.IsRunning() then
                return status
            end
        end
        return NodeState.Failure
    end

    return self
end

return SelectNode