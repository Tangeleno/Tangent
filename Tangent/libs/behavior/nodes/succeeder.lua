local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@class SucceederNode : Node
local SucceederNode = {}
setmetatable(SucceederNode, { __index = Node }) -- Inherit from Node

--- Constructor for SucceederNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return SucceederNode @The created SucceederNode instance
function SucceederNode.new(args)
    ---@class SucceederNode : Node
    local self = setmetatable(Node.new(args), { __index = SucceederNode }) -- Set SitNode as its metatable
    self.NodeType = "SucceederNode"
    mq.Write.Trace("%s: Creating SucceederNode named '%s'", self.NodeType, args.name)

    return self
end

--- Update function called each tick.
---@param blackboard table @The blackboard being used by the behavior tree.
---@return NodeState @The state of the node after processing.
function SucceederNode:_Update(blackboard)
    return NodeState.Success
end

return SucceederNode
