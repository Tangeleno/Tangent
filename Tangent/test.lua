local mq = require "libs.Helpers.MacroQuestHelpers"
local socket = require("socket")
local bt, States = require "libs.behavior.behaviorTree"
local NodeState = require "libs.behavior.NodeState"
local rapidjson = require("rapidjson")
local trees = {}
trees["sit"] =
'{ "inputs":{"name": "Root Node"}, "type": "SelectNode", "children": [ { "inputs":{"name": "Am sitting","conditionKey": "standing"}, "type": "ConditionNode" }, { "inputs":{"name": "Sit down"}, "type": "SitNode" } ] }'
trees["target"] =
'{"id":"node-000","type":"SelectNode","inputs":{"name":"Target"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Have Target","conditionKey":"haveCorrectTarget","paramKeys":["targetId"]},"children":[]},{"id":"node-002","type":"SequenceNode","inputs":{"name":"Get Target"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Target Is Valid","conditionKey":"isValidTarget","paramKeys":["targetId","spawnType"]},"children":[]},{"id":"node-004","type":"TargetNode","inputs":{"name":"Target","targetIdKey":"targetId","targetTypeKey":"spawnType"},"children":[]}]}]}'
trees["mem"] =
'{"id":"node-000","type":"SelectNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"SequenceNode","inputs":{"name":"Start Mem"},"children":[{"id":"node-002","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]}]},{"id":"node-004","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-005","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-006","type":"MemorizeSpellNode","inputs":{"name":"Memorize Spell","spellGemKey":"spellGem","spellIdKey":"spellId"},"children":[]},{"id":"node-007","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]},{"id":"node-008","type":"SequenceNode","inputs":{"name":"WaitingForMem"},"children":[{"id":"node-009","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]},{"id":"node-010","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-011","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-012","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]}]}'
trees["navCoord"] =
'{  "id": "node-006",  "type": "MoveToNode",  "inputs": { "name": "Move", "coordinatesKey": "moveToLoc","distanceKey":"distance"}}'
trees["navSpawn"] =
'{  "id": "node-006",  "type": "MoveToNode",  "inputs": { "name": "Move", "spawnIdKey": "moveToId","positionKey":"moveToPosition","distanceKey":"distance"}}'
trees["cast"] =
'{ "id": "node-006", "type": "CastSpellNode", "inputs": { "name": "CastCourage", "targetIdKey":"targetId", "targetTypeKey":"spawnType", "spellIdKey":"spellId", "spellTypeKey":"spellType", "spellResultKey":"spellResult" }}'
trees["attackOn"] =
'{ "id": "node-006", "type": "AttackNode", "inputs": { "name": "AttackOn", "desiredStateKey": "on" } }'
trees["attackOff"] =
'{ "id": "node-006", "type": "AttackNode", "inputs": { "name": "AttackOff", "desiredStateKey": "off" } }'
trees["engage"] =
'{"id":"node-000","type":"SequenceNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"SelectNode","inputs":{"name":"Target"},"children":[{"id":"node-002","type":"ConditionNode","inputs":{"name":"Have Target","conditionKey":"haveCorrectTarget","paramKeys":["EngageTargetId"]},"children":[]},{"id":"node-003","type":"SequenceNode","inputs":{"name":"Get Target"},"children":[{"id":"node-004","type":"ConditionNode","inputs":{"name":"Target Is Valid","conditionKey":"isValidTarget","paramKeys":["EngageTargetId","spawnType"]},"children":[]},{"id":"node-005","type":"TargetNode","inputs":{"name":"Do Target","targetIdKey":"EngageTargetId","targetTypeKey":"spawnType"},"children":[]}]}]},{"id":"node-006","type":"SelectNode","inputs":{"name":"Sneak"},"children":[{"id":"node-007","type":"ConditionNode","inputs":{"name":"Is Sneaking","conditionKey":"isSneaking","paramKeys":[]},"children":[]},{"id":"node-008","type":"AbilityNode","inputs":{"name":"Activate Sneak","abilityNameKey":"","abilityName":"Sneak"},"children":[]}]},{"id":"node-009","type":"SelectNode","inputs":{"name":"Hide"},"children":[{"id":"node-010","type":"ConditionNode","inputs":{"name":"Is Hiding","conditionKey":"isHiding","paramKeys":[]},"children":[]},{"id":"node-011","type":"AbilityNode","inputs":{"name":"Activate Hide","abilityNameKey":"","abilityName":"Hide"},"children":[]}]},{"id":"node-012","type":"ParallelNode","inputs":{"name":"Wait For Sneak","percentage":1,"breakOnThreshold":"SuccessOnly"},"children":[{"id":"node-013","type":"WaitNode","inputs":{"name":"Wait For Sneak","time":1},"children":[]},{"id":"node-014","type":"ConditionNode","inputs":{"name":"Is Sneaking","conditionKey":"isSneaking","paramKeys":[]},"children":[]}]},{"id":"node-015","type":"SelectNode","inputs":{"name":"Sneak Attack"},"children":[{"id":"node-016","type":"CastSpellNode","inputs":{"name":"Use Sneak Attack","spellIdKey":"","spellKey":"AssassinStrike","spellType":"disc","spellResultKey":"AssassinStrikeResult"},"children":[]},{"id":"node-017","type":"SucceederNode","inputs":{"name":"Always Success"},"children":[]}]},{"id":"node-018","type":"MoveToNode","inputs":{"name":"Move To Position","spawnIdKey":"EngageTargetId","positionKey":"EngagePosition","distanceKey":"engageDistance"},"children":[]},{"id":"node-019","type":"FaceNode","inputs":{"name":"Face","faceIdKey":"EngageTargetId"},"children":[]},{"id":"node-020","type":"AbilityNode","inputs":{"name":"Backstab","abilityName":"Backstab"},"children":[]},{"id":"node-021","type":"AttackNode","inputs":{"name":"Toggle Attack","desiredStateKey":"attackState","attackTypeKey":"attackType"},"children":[]}]}'
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace

local tickSpeed = 100
local args = { ... }
local treeName = args[1] or "sit"

local blackboard = {
    spellId = "Courage",
    spawnType = "npc",
    spellType = "gem",
    spellResult = nil,
    spellGem = 6,
    EngageTargetId = 7107,
    deltaTime = 0,
    moveToLoc = { X = mq.TLO.Target.X(), Y = mq.TLO.Target.Y(), Z = mq.TLO.Target.Z() },
    distance = { Min = 10, Max = 20 },
    moveToId = mq.TLO.Target.ID(),
    moveToPosition = mq.Positioning.Any,
    EngagePosition = mq.Positioning.Behind,
    engageDistance = { Min = 5, Max = mq.TLO.Spawn(7107).MaxRangeTo()*0.75 },
    attackType = "attack",
    attackState = "on",
    on = "on",
    off = "off",
    Spells = {}
}
blackboard.Spells.AssassinStrike = mq.TLO.Me.CombatAbility(mq.TLO.Me.CombatAbility("Swiftblade")())
if mq.TLO.Target.ID() > 0 then
    blackboard.targetId = mq.TLO.Target.ID()
else
    blackboard.targetId = 19796
end
local myTree = bt.new(trees[treeName])
local startTime = socket.gettime()
local status = NodeState.Running
while status == NodeState.Running do
    status = myTree:Tick(blackboard)
    mq.delay(tickSpeed)
    local currentTime = socket.gettime()
    blackboard.deltaTime = (currentTime - startTime) * 1000
    startTime = currentTime
end