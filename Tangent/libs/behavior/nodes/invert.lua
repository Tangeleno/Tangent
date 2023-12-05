local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"

---@class InvertNode
local InvertNode = {}

--- Constructor for InvertNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Invert node.
---@return InvertNode @The created InvertNode instance
function InvertNode.new(args)
    ---@class InvertNode:DecoratorNode
    local self = DecoratorNode.new(args.name)
    self.NodeType = "InvertNode"
    mq.Write.Trace("Creating %s: %s", self.NodeType, self.Name)

    function self._Update(blackboard)
        if not self.Child then
            mq.Write.Warn("No child found in InvertNode: %s", args.name)
            return NodeState.Failure
        end
        local result = self.Child.Tick(blackboard)
        if result == NodeState.Success then
            return NodeState.Failure
        end
        if result == NodeState.Failure then
            return NodeState.Success
        end
        return result
    end

    return self
end

return InvertNode
