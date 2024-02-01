local mq = require "libs.Helpers.MacroQuestHelpers"
local rapidjson = require("rapidjson")
local Action = require "libs.goap.action"
local doabilityBehavior =
'{"id":"node-000","type":"SequenceNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Has Ability","conditionKey":"hasAbility","paramKeys":["abilityName"]},"children":[]},{"id":"node-002","type":"AbilityNode","inputs":{"name":"Do Ability","abilityNameKey":"abilityName"},"children":[]}]}'

---@class HideAction:Action
---@field private hiddenState boolean
local HideAction = setmetatable({}, { __index = Action })

function HideAction:new()
    mq.Write.Trace("HideAction:new - Creating new HideAction")
    ---@class HideAction:Action
    local obj = Action:new("Hide", "Doability", doabilityBehavior)
    setmetatable(obj, { __index = HideAction })
    obj.hiddenState = false

    return obj
end

---@param state StateClass
function HideAction:startAction(state)
    state.abilityName = 'Hide'
    mq.Write.Debug("HideAction:startAction - Starting Hide action")
    Action.startAction(self, state)
end

---@param state StateClass
function HideAction:calculateCost(state)
    return Action.doCalculateCost(self, 0, 1, 0, 3, state)
end

---@param state StateClass
function HideAction:applyEffects(state)
    self.hiddenState = state.Hidden
    state.Hidden = true
end

---@param state StateClass
function HideAction:revertEffects(state)
    state.Hidden = self.hiddenState
end

---@param state StateClass
function HideAction:conditionMet(state)
    return not state.Hidden and mq.TLO.Me.Skill("Hide")() > 0
end

return HideAction
