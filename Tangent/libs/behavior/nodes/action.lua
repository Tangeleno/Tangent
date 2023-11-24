local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local Actions = require "libs.behavior.actions"
---@type ActionNode
local ActionNode = {}
---@param name string @Name of the Action node
---@param actionName string @Name of the action to perform
---@param paramKeys string[] @Keys to extract the parameters from the blackboard
---@return ActionNode @The created ActionNode instance
function ActionNode.new(name, actionName, paramKeys)
    local function NoOp()
    end
    ---@class ActionNode:Node
    local self = Node.new(name)
    self.NodeType = "ActionNode"

    mq.Write.Debug("Creating ActionNode: %s, with action: %s", name, actionName)

    -- Loading the action function safely
    local status, action = pcall(function() return Actions[actionName] end)
    if not status then
        mq.Write.Error("Error: Unknown action '%s' Setting function to NoOp", actionName)
        action = NoOp
    end
    self.Action = action

    function self._Update(blackboard)
        -- Extract the parameters from the blackboard using the keys
        local params = {}
        for _, key in ipairs(paramKeys) do
            table.insert(params, blackboard[key])
        end

        -- Safely call the stored action with the parameters and return its node state
        local success, result = pcall(function() return self.Action(unpack(params)) end)
        if not success then
            mq.Write.Error("Error executing action '%s': %s", actionName, result)
            return NodeState.Failure
        end
        return result
    end

    return self
end
return ActionNode