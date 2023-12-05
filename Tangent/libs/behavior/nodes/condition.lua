local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local Conditions = require "libs.behavior.conditions"

---@class ConditionNode
local ConditionNode = {}

--- Constructor for ConditionNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Condition node.
---   - conditionKey: string @Name of the condition to check.
---   - paramKeys: string[] @Keys to extract the parameters from the blackboard (optional).
---@return ConditionNode @The created ConditionNode instance
function ConditionNode.new(args)
    args.paramKeys = args.paramKeys or {}
    local function False()
        return false
    end
    ---@class ConditionNode:Node
    local self = Node.new(args.name)
    self.NodeType = "ConditionNode"
    mq.Write.Trace("Creating %s: %s with condition %s, paramKeys {%s}", self.NodeType, self.Name, args.conditionKey, table.concat(args.paramKeys, ","))

    -- Loading the condition function safely
    local condition = Conditions[args.conditionKey]
    if not condition then
        mq.Write.Error("Error: %s: Unknown condition '%s' Setting function to False", self.Name, args.conditionKey)
        condition = False
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
            mq.Write.Error("Error %s:  checking condition '%s': %s", self.Name, args.conditionKey, result)
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
