local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local Conditions = require "libs.behavior.conditions"
---@class ConditionNode
local ConditionNode = {}
---@param name string @Name of the Condition node
---@param conditionKey string @Name of the condition to check
---@param paramKeys string[] @Keys to extract the parameters from the blackboard
---@return ConditionNode @The created ConditionNode instance
function ConditionNode.new(name, conditionKey, paramKeys)
    paramKeys = paramKeys or {}
    local function False()
        return false
    end
    ---@class ConditionNode:Node
    local self = Node.new(name)
    self.NodeType = "ConditionNode"
    mq.Write.Trace("Creating %s: %s with condition %s, paramKeys {%s}", self.NodeType, self.Name, conditionKey,table.concat(paramKeys, ","))

    -- Loading the condition function safely
    local status, condition = pcall(function() return Conditions[conditionKey] end)
    if not status then
        mq.Write.Error("Error: %s: Unknown condition '%s' Setting function to False", self.Name, conditionKey)
            condition = False
    end
    self.Condition = condition

    function self._Update(blackboard)
        -- Extract the parameters from the blackboard using the keys
        local params = {}
        for _, key in ipairs(paramKeys) do
            table.insert(params, blackboard[key])
        end

        -- Safely call the stored condition with the parameters and return its node state
        local success, result = pcall(function() return self.Condition(unpack(params)) end)
        if not success then
            mq.Write.Error("Error %s:  checking condition '%s': %s",self.Name, conditionKey, result)
            return NodeState.Failure
        end
        if result then
            return NodeState.Success
        end
        return NodeState.Failure
    end

    return self
end

return ConditionNode
