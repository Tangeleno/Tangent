local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"
---@type InvertNode
local InvertNode = {}
---@param name string @Name of the Invert node
---@return InvertNode @The created InvertNode instance
function InvertNode.new(name)
    ---@class InvertNode:DecoratorNode
    local self = DecoratorNode.new(name)
    self.NodeType = "InvertNode"
    function self._Update(blackboard)
        if not self.Child then
            mq.Write.Warn("No child found in InvertNode: %s", name)
            return NodeState.Failure
        end
        local result = self.Child.Tick(blackboard)
        if result == NodeState.Success then
            mq.Write.Debug("InvertNode flipping Success to Failure")
            return NodeState.Failure
        end
        if result == NodeState.Failure then
            mq.Write.Debug("InvertNode flipping Failure to Success")
        end
        mq.Write.Debug("InvertNode %s returning status: %s", name, NodeState[result])
        return result
    end

    return self
end

return InvertNode