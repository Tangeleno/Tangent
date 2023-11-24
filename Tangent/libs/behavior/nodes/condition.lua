local Conditions = require "libs.behavior.conditions"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@type ConditionNode
local ConditionNode = {}
---@param name string @Name of the Condition node.
---@param conditionKey string @A key that references a condition function in the blackboard. This function should return a boolean.
function ConditionNode.new(name, conditionKey)
    ---@class ConditionNode:Node
    local self = Node.new(name)
    self.NodeType = "ConditionNode"
    local condition = Conditions[conditionKey] or function() return false end
    
    function self._Update(blackboard)
        if condition(blackboard) then
            return NodeState.Success
        end
        return NodeState.Failure
    end

    return self
end
return ConditionNode