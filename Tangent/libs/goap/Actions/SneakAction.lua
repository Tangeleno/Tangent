local mq = require "libs.Helpers.MacroQuestHelpers"
local Action = require "libs.goap.action"
local doabilityBehavior =
'{"id":"node-000","type":"SequenceNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Has Ability","conditionKey":"hasAbility","paramKeys":["abilityName"]},"children":[]},{"id":"node-002","type":"AbilityNode","inputs":{"name":"Do Ability","abilityNameKey":"abilityName"},"children":[]}]}'

---@class SneakAction:Action
---@field private Sneaking boolean
local SneakAction = setmetatable({}, { __index = Action })

function SneakAction:new()
    mq.Write.Trace("SneakAction:new - Creating new SneakAction")
    local obj = Action:new("Sneak", "Doability", doabilityBehavior)
    setmetatable(obj, { __index = SneakAction })
    return obj
end

---@param state StateClass
function SneakAction:startAction(state)
    state.abilityName = 'Sneak'
    mq.Write.Debug("SneakAction:startAction - Starting %s action.", self.name)
    Action.startAction(self, state)
end

---@param state StateClass
function SneakAction:calculateCost(state)
    return Action.doCalculateCost(self, 0, 1, 0, 3, state)
end

---@param state StateClass
function SneakAction:applyEffects(state)
    self.Sneaking = state.Sneaking
    state.Sneaking = true
end

---@param state StateClass
function SneakAction:revertEffects(state)
    state.Sneaking = self.Sneaking
end

---@param state StateClass
function SneakAction:conditionMet(state)
    return not state.Sneaking and mq.TLO.Me.Skill("Sneak")() > 0
end

return SneakAction
