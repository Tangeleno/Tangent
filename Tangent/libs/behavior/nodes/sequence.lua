local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

---@class SequenceNode
local SequenceNode = {}
function SequenceNode.new(name)
    ---@class SequenceNode:CompositeNode @Returns the first failed child or success if all children succeed
    local self = CompositeNode.new(name)
    self.NodeType = "SequenceNode"
    self.CurrentChildIndex = 1
    mq.Write.Trace("Creating %s: %s", self.NodeType, self.Name)
    function self._OnInitialize(blackboard)
        self.CurrentChildIndex = 1
    end

    ---@return NodeState
    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in SequenceNode: %s", name)
            return NodeState.Invalid
        end

        for _, child in ipairs(self.Children) do
            local status = child.Tick(blackboard)
            if child.IsFailure() or child.IsRunning() then
                return status
            end
        end
        return NodeState.Success
    end

    return self
end
return SequenceNode