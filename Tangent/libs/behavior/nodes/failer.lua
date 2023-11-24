local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@type FailerNode
local FailerNode = {}
---@param name string @Name of the Failer node.
function FailerNode.new(name)
    ---@class FailerNode:Node
    local self = Node.new(name)
    self.NodeType = "FailerNode"

    function self._Update(blackboard)
        return NodeState.Failure
    end

    return self
end
return FailerNode