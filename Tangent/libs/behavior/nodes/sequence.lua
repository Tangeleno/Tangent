local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

---@type SequenceNode
local SequenceNode = {}
function SequenceNode.new(name)
    ---@class SequenceNode:CompositeNode
    local self = CompositeNode.new(name)
    self.NodeType = "SequenceNode"
    self.CurrentChildIndex = 1

    function self._OnInitialize(blackboard)
        self.CurrentChildIndex = 1
    end

    ---@return NodeState
    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in SequenceNode: %s", name)
            return NodeState.Invalid
        end

        if self.CurrentChildIndex > #self.Children then
            return NodeState.Success
        end

        local child = self.Children[self.CurrentChildIndex]
        local status = child.Tick(blackboard)
        if status == NodeState.Success then
            self.CurrentChildIndex = self.CurrentChildIndex + 1
            if self.CurrentChildIndex > #self.Children then
                return NodeState.Success
            else
                return NodeState.Running
            end
        end

        return status
    end

    return self
end
return SequenceNode