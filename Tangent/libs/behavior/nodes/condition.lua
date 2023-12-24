local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local Conditions = require "libs.behavior.conditions"

---@class ConditionNodeArgs : NodeArgs
---@field name string @Name of the Condition node.
---@field conditionKey string @Name of the condition to check.
---@field paramKeys string[] @Keys to extract the parameters from the blackboard (optional).

---@class ConditionNode : Node
---@field Condition function @The condition function to evaluate.
local ConditionNode = {}

--- Constructor for ConditionNode.
---@param args ConditionNodeArgs @Table containing the arguments for the node.
---@return ConditionNode @The created ConditionNode instance
function ConditionNode.new(args)
    args.paramKeys = args.paramKeys or {}
    local function False()
        return false
    end
    ---@class ConditionNode : Node
    local self = Node.new(args)
    self.NodeType = "ConditionNode"
    mq.Write.Trace("%s: Creating ConditionNode with condition '%s', paramKeys {%s}", self.Name, args.conditionKey,
        table.concat(args.paramKeys, ", "))

    -- Loading the condition function safely
    local condition = Conditions[args.conditionKey] or False
    if condition == False then
        mq.Write.Error("%s: Unknown condition '%s'. Setting function to False", self.Name, args.conditionKey)
    end

    self.Condition = condition

    function self._Update(blackboard)
        -- Extract the parameters from the blackboard using the keys
        local params = {}
        for _, key in ipairs(args.paramKeys) do
            table.insert(params, blackboard[key])
        end

        -- Safely call the stored condition with the parameters and return its node state
        local success, result = pcall(function() return self.Condition(unpack(params)) end)
        if not success then
            mq.Write.Error("%s: Error checking condition '%s': %s", self.Name, args.conditionKey, result)
            return NodeState.Failure
        end
        if result then
            return NodeState.Success
        else
            return NodeState.Failure
        end
    end

    return self
end

return ConditionNode
