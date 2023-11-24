local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"
---@type SelectNode
local SelectNode = {}
---@param name string @Name of the Select node
---@return SelectNode @The created SelectNode instance
function SelectNode.new(name)
    ---@class SelectNode:CompositeNode
    local self = CompositeNode.new(name)
    self.NodeType = "SelectNode"
    self.CurrentChildIndex = 1

    function self._OnInitialize(blackboard)
        self.CurrentChildIndex = 1
    end

    ---@return NodeState
    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in SelectNode: %s", name)
            return NodeState.Invalid
        end

        if self.CurrentChildIndex > #self.Children then
            return NodeState.Failure
        end

        local child = self.Children[self.CurrentChildIndex]
        local status = child.Tick(blackboard)
        if status == NodeState.Running then
            return NodeState.Running
        elseif status == NodeState.Failure then
            self.CurrentChildIndex = self.CurrentChildIndex + 1
            return NodeState.Running
        else
            return status
        end
    end

    return self
end

return SelectNode
