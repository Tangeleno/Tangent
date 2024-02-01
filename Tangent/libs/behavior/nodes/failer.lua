local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@class FailerNode : Node
local FailerNode = {}
setmetatable(FailerNode, { __index = Node }) -- Inherit from Node

--- Constructor for FailerNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return FailerNode @The created FailerNode instance
function FailerNode.new(args)
    ---@class FailerNode : Node
    local self = setmetatable(Node.new(args), { __index = FailerNode }) -- Set SitNode as its metatable
    self.NodeType = "FailerNode"
    mq.Write.Trace("%s: Creating FailerNode named '%s'", self.NodeType, args.name)

    return self
end

--- Update function called each tick.
---@param blackboard table @The blackboard being used by the behavior tree.
---@return NodeState @The state of the node after processing.
function FailerNode:_Update(blackboard)
    return NodeState.Failure
end

return FailerNode
