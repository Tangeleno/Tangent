local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class FailerNode
local FailerNode = {}

--- Constructor for FailerNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Failer node.
---@return FailerNode @The created FailerNode instance
function FailerNode.new(args)
    ---@class FailerNode:Node
    local self = Node.new(args.name)
    self.NodeType = "FailerNode"
    mq.Write.Trace("Creating %s: %s", self.NodeType, self.Name)

    function self._Update(blackboard)
        return NodeState.Failure
    end

    return self
end

return FailerNode
