local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"


---@class InvertNode : DecoratorNode
local InvertNode = {}
setmetatable(InvertNode, { __index = DecoratorNode }) -- Inherit from Node
--- Constructor for InvertNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return InvertNode @The created InvertNode instance
function InvertNode.new(args)
    ---@class InvertNode : DecoratorNode
    local self = setmetatable(DecoratorNode.new(args), { __index = InvertNode }) -- Set SitNode as its metatable
    self.NodeType = "InvertNode"
    mq.Write.Trace("%s: Creating InvertNode named '%s'", self.NodeType, args.name)

    return self
end

--- Update function called each tick.
---@param blackboard table @The blackboard being used by the behavior tree.
---@return NodeState @The state of the node after processing.
function InvertNode:_Update(blackboard)
    if not self.Child then
        mq.Write.Warn("%s '%s': No child node is assigned", self.NodeType, self.Name)
        return NodeState.Failure
    end

    local result = self.Child:Tick(blackboard)

    -- Invert the success and failure states
    if result == NodeState.Success then
        mq.Write.Debug("%s '%s': Child succeeded, inverting to Failure", self.NodeType, self.Name)
        return NodeState.Failure
    elseif result == NodeState.Failure then
        mq.Write.Debug("%s '%s': Child failed, inverting to Success", self.NodeType, self.Name)
        return NodeState.Success
    end

    -- If the child is still running or invalid, return the same state
    mq.Write.Debug("%s '%s': Child state is %s, returning as is", self.NodeType, self.Name, NodeState[result])
    return result
end

return InvertNode
