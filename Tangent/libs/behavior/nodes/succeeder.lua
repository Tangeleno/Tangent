local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@type SucceederNode
local SucceederNode = {}
---@param name string @Name of the Succeeder node.
function SucceederNode.new(name)
    ---@class SucceederNode:Node
    local self = Node.new(name)
    self.NodeType = "SucceederNode"

    function self._Update(blackboard)
        return NodeState.Success
    end

    return self
end

return SucceederNode