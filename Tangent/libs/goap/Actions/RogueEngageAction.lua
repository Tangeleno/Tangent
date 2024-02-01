local mq = require "libs.Helpers.MacroQuestHelpers"
local Action = require "libs.goap.action"
local engageBehavior =
'{"id":"node-000","type":"SequenceNode","inputs":{"name":"Root"},"children":[{"id":"node-005","type":"TargetNode","inputs":{"name":"Target","targetIdKey":"EngageTargetId","targetTypeKey":"spawnType"},"children":[]},{"id":"node-009","type":"SelectNode","inputs":{"name":"Hide"},"children":[{"id":"node-010","type":"ConditionNode","inputs":{"name":"Is Hiding","conditionKey":"isHiding","paramKeys":[]},"children":[]},{"id":"node-011","type":"AbilityNode","inputs":{"name":"Activate Hide","abilityNameKey":"","abilityName":"Hide"},"children":[]}]},{"id":"node-006","type":"SelectNode","inputs":{"name":"Sneak"},"children":[{"id":"node-007","type":"ConditionNode","inputs":{"name":"Is Sneaking","conditionKey":"isSneaking","paramKeys":[]},"children":[]},{"id":"node-008","type":"AbilityNode","inputs":{"name":"Activate Sneak","abilityNameKey":"","abilityName":"Sneak"},"children":[]}]},{"id":"node-012","type":"ParallelNode","inputs":{"name":"Wait For Sneak","percentage":1,"breakOnThreshold":"SuccessOnly"},"children":[{"id":"node-013","type":"WaitNode","inputs":{"name":"Wait For Sneak","time":1},"children":[]},{"id":"node-014","type":"ConditionNode","inputs":{"name":"Is Sneaking","conditionKey":"isSneaking","paramKeys":[]},"children":[]}]},{"id":"node-018","type":"MoveToNode","inputs":{"name":"Move To Position","spawnIdKey":"EngageTargetId","positionKey":"EngagePosition","distanceKey":"engageDistance"},"children":[]},{"id":"node-019","type":"FaceNode","inputs":{"name":"Face","faceIdKey":"EngageTargetId"},"children":[]},{"id":"node-015","type":"SelectNode","inputs":{"name":"Sneak Attack"},"children":[{"id":"node-016","type":"CastSpellNode","inputs":{"name":"Use Sneak Attack","spellIdKey":"","spellKey":"AssassinStrike","spellType":"disc","spellResultKey":"AssassinStrikeResult"},"children":[]},{"id":"node-017","type":"SucceederNode","inputs":{"name":"Always Success"},"children":[]}]},{"id":"node-020","type":"AbilityNode","inputs":{"name":"Backstab","abilityName":"Backstab"},"children":[]},{"id":"node-021","type":"AttackNode","inputs":{"name":"Toggle Attack","desiredStateKey":"attackState","attackTypeKey":"attackType"},"children":[]}]}'

---@class RogueEngageAction:Action
local RogueEngageAction = setmetatable({}, { __index = Action })

function RogueEngageAction:new()
    mq.Write.Trace("RogueEngageAction:new - Creating new RogueEngageAction")
    local obj = Action:new("Rogue Engage", "RogueEngage", engageBehavior)
    setmetatable(obj, { __index = RogueEngageAction })
    return obj
end

---@param state StateClass
function RogueEngageAction:startAction(state)
    state.spawnType = 'NPC'
    state.engageDistance = { Min = state.EngageTargetMaxRangeTo * 0.1, Max = state.EngageTargetMaxRangeTo }
    state.attackState = 'on'
    state.attackType = 'attack'
    mq.Write.Debug("RogueEngageAction:startAction - Starting %s action with state", self.name)
    Action.startAction(self, state)
end

function RogueEngageAction:onActionComplete(state)
    state.EngagedWith = state.EngageTargetId
end

---@param state StateClass
function RogueEngageAction:calculateCost(state)
    return Action.doCalculateCost(self, 0, 1, 100, 3, state)
end

---@param state StateClass
function RogueEngageAction:applyEffects(state)
    self.EngagedWith = state.EngagedWith
    state.EngagedWith = state.EngageTargetId
end

---@param state StateClass
function RogueEngageAction:revertEffects(state)
    state.EngagedWith = self.EngagedWith
end

---@param state StateClass
function RogueEngageAction:conditionMet(state)
    mq.Write.Debug("Rogue Engage action condition %s ~= %s",state.EngagedWith,state.EngageTargetId)
    return state.EngagedWith ~= state.EngageTargetId
end

return RogueEngageAction
