local mq = require "libs.Helpers.MacroQuestHelpers"
local Action = require "libs.goap.action"
local targetBehavior =
'{"id":"node-000","type":"SelectNode","inputs":{"name":"Target"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Have Target","conditionKey":"haveCorrectTarget","paramKeys":["targetId"]},"children":[]},{"id":"node-002","type":"SequenceNode","inputs":{"name":"Get Target"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Target Is Valid","conditionKey":"isValidTarget","paramKeys":["targetId","spawnType"]},"children":[]},{"id":"node-004","type":"TargetNode","inputs":{"name":"Target","targetIdKey":"targetId","targetTypeKey":"spawnType"},"children":[]}]}]}'

---@class TargetAction:Action
---@field private hiddenState boolean
local TargetAction = setmetatable({}, { __index = Action })

function TargetAction:new()
    mq.Write.Trace("TargetAction:new - Creating new TargetAction")
    ---@class TargetAction:Action
    local obj = Action:new("Target", "GetTarget", targetBehavior)
    setmetatable(obj, { __index = TargetAction })
    obj.hiddenState = false

    return obj
end

---@param state StateClass
function TargetAction:startAction(state)
    mq.Write.Debug("TargetAction:startAction - Starting Target action")
    state.targetId = state.EngageTargetId
    state.spawnType = "NPC"
    Action.startAction(self, state)
end

---@param state StateClass
function TargetAction:calculateCost(state)
    return Action.doCalculateCost(self, 0, 1, 0, 1, state)
end

---@param state StateClass
function TargetAction:applyEffects(state)
    self.targetState = state.TargetId
    state.TargetId = state.EngageTargetId
end

---@param state StateClass
function TargetAction:revertEffects(state)
    state.TargetId = self.targetState
end

---@param state StateClass
function TargetAction:conditionMet(state)
    return state.TargetId ~= state.EngageTargetId
end

return TargetAction
