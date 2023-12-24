local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

--- Creates a node that always succeeds.
---@class SucceederNode
local SucceederNode = {}

--- Creates a node that always succeeds.
---@param args NodeArgs @Table containing the arguments for the node.
---@return SucceederNode @The created SucceederNode instancece
function SucceederNode.new(args)
    ---@class SucceederNode:Node
    local self = Node.new(args)
    self.NodeType = "SucceederNode"
    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    function self._Update(blackboard)
        return NodeState.Success
    end

    return self
end

return SucceederNode
