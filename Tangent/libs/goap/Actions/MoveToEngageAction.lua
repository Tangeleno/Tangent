local mq = require "libs.Helpers.MacroQuestHelpers"
local Action = require "libs.goap.action"
local moveToEngageBehavior =
'{  "id": "node-006",  "type": "MoveToNode",  "inputs": { "name": "Move To Engage", "spawnIdKey": "EngageTargetId","positionKey":"EngagePosition","distanceKey":"EngageDistance"}}'
---@class MoveToEngageAction:Action
local MoveToEngageAction = setmetatable({}, { __index = Action })

function MoveToEngageAction:new()
    mq.Write.Trace("MoveToEngageAction:new - Creating new MoveToEngageAction")
    ---@class MoveToEngageAction:Action
    local obj = Action:new("Move To Engage", "moveToEngage", moveToEngageBehavior)
    obj.EngageDistance = 0
    setmetatable(obj, { __index = MoveToEngageAction })
    return obj
end

---@param state StateClass
function MoveToEngageAction:startAction(state)
    mq.Write.Debug("MoveToEngageAction:startAction - Starting Move To action")
    Action.startAction(self, state)
end

---@param state StateClass
function MoveToEngageAction:calculateCost(state)
    local distanceToTarget = mq.TLO.Spawn(state.EngageTargetId).Distance()
    return Action.doCalculateCost(self, 0, 1, distanceToTarget * 10, 0, state)
end

---@param state StateClass
function MoveToEngageAction:applyEffects(state)
    self.EngageDistance = state.EngageTargetDistance
    state.EngageTargetDistance = state.EngageTargetMaxRangeTo - 10
end

---@param state StateClass
function MoveToEngageAction:revertEffects(state)
    state.EngageTargetDistance = self.EngageDistance
end

---@param state StateClass
function MoveToEngageAction:conditionMet(state)
    return mq.IsValidTarget(state.EngageTargetId, "NPC") and state.EngageTargetDistance > state.EngageTargetMaxRangeTo
end

return MoveToEngageAction
