local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"
local Conditions = require "libs.behavior.conditions"
---@type LoopNode
local LoopNode = {}
---@param name string @Name of the Loop node.
---@param loopCount number @Number of times to execute the child node.
---@param conditionKey string @A key that references a condition function in the conditions table. This function should return a boolean. If false, the loop will terminate early.
function LoopNode.new(name, loopCount, conditionKey)
    ---@class LoopNode:DecoratorNode
    local self = DecoratorNode.new(name)
    self.NodeType = "LoopNode"
    self.LoopCount = loopCount or 1
    self.CurrentLoop = 0
    self.ConditionKey = conditionKey
    local conditionFunc = Conditions[conditionKey]
    function self._OnInitialize(blackboard)
        self.CurrentLoop = 0
    end

    function self._Update(blackboard)
        if conditionFunc and not conditionFunc(blackboard) then
            return NodeState.Failure
        end

        local status = self.Child.Tick(blackboard)
        if status == NodeState.Success then
            self.CurrentLoop = self.CurrentLoop + 1
            if self.CurrentLoop < self.LoopCount then
                return NodeState.Running
            else
                return NodeState.Success
            end
        end
        return status
    end

    return self
end
return LoopNode