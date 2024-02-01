local mq = require "libs.Helpers.MacroQuestHelpers"
local Action = require "libs.goap.action"
local sitBehavior =
'{ "inputs":{"name": "Root Node"}, "type": "SelectNode", "children": [ { "inputs":{"name": "Am sitting","conditionKey": "standing"}, "type": "ConditionNode" }, { "inputs":{"name": "Sit down"}, "type": "SitNode" } ] }'
---@class SitAction:Action
---@field private Standing boolean
local SitAction = setmetatable({}, { __index = Action })

function SitAction:new()
    mq.Write.Trace("SitAction:new - Creating new SitAction")
    local obj = Action:new("Sit", "Sit", sitBehavior)
    setmetatable(obj, { __index = SitAction })
    return obj
end

---@param state StateClass
function SitAction:startAction(state)
    state.abilityName = 'Sit'
    mq.Write.Debug("SitAction:startAction - Starting %s action with state", self.name)
    Action.startAction(self, state)
end

---@param state StateClass
function SitAction:calculateCost(state)
    return Action.doCalculateCost(self, 0, 1, 100, 3, state)
end

---@param state StateClass
function SitAction:applyEffects(state)
    self.Standing = state.Standing
    state.Standing = false
end

---@param state StateClass
function SitAction:revertEffects(state)
    state.Standing = self.Standing
end

---@param state StateClass
function SitAction:conditionMet(state)
    return state.Standing and not state.Mounted
end

return SitAction
