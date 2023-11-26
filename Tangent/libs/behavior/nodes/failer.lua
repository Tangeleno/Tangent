local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@class FailerNode
local FailerNode = {}
---@param name string @Name of the Failer node.
function FailerNode.new(name)
    ---@class FailerNode:Node
    local self = Node.new(name)
    self.NodeType = "FailerNode"
    mq.Write.Trace("Creating %s: %s",self.NodeType, self.Name)
    function self._Update(blackboard)
        return NodeState.Failure
    end

    return self
end
return FailerNode