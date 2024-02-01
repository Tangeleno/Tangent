local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class AttackNodeArgs : NodeArgs
---@field name string @Name of the Attack node.
---@field desiredStateKey string @Key to string value for the /attack command ('on' or 'off').
---@field attackTypeKey string @Key to boolean value to determine if we should use /attack or /autofire

---@class AttackNode:Node
---@field Args AttackNodeArgs
local AttackNode = {}
setmetatable(AttackNode, { __index = Node }) -- Inherit from Node

--- Constructor for Attack.
---@param args AttackNodeArgs @Table containing the arguments for the node.
---@return AttackNode @The created Sit instance
function AttackNode.new(args)
    ---@class AttackNode:Node
    local self = setmetatable(Node.new(args), { __index = AttackNode }) -- Set AttackNode as its metatable
    self.NodeType = "Attack"
    mq.Write.Trace("%s: Creating AttackNode", args.name)
    return self
end

function AttackNode:_OnInitialize(blackboard)
    mq.Write.Debug("%s: Initializing AttackNode", self.Name)
end

function AttackNode:_Update(blackboard)
    local attackType = blackboard[self.Args.attackTypeKey] or "attack"
    local desiredState = blackboard[self.Args.desiredStateKey] or "off"
    mq.Write.Debug("/%s %s", attackType, desiredState)
    mq.cmdf("/%s %s", attackType, desiredState)
    return NodeState.Success
end

return AttackNode
