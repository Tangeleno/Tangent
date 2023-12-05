local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

--- Creates a node that always succeeds.
---@class SucceederNode
local SucceederNode = {}

--- Constructor for SucceederNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Succeeder node.
---@return SucceederNode @The created SucceederNode instance
function SucceederNode.new(args)
    ---@class SucceederNode:Node
    local self = Node.new(args.name)
    self.NodeType = "SucceederNode"
    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    function self._Update(blackboard)
        return NodeState.Success
    end

    return self
end

return SucceederNode
