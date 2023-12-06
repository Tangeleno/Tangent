local mq = require "libs.Helpers.MacroQuestHelpers"
local socket = require("socket")
local bt, States = require "libs.behavior.behaviorTree"
local NodeState = require "libs.behavior.NodeState"

local trees = {}
trees["sit"] =
'{ "inputs":{"name": "Root Node"}, "type": "SelectNode", "children": [ { "inputs":{"name": "Am sitting","conditionKey": "standing"}, "type": "ConditionNode" }, { "inputs":{"name": "Sit down"}, "type": "SitNode" } ] }'
trees["target"] =
'{"id":"node-000","type":"SelectNode","inputs":{"name":"Target"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Have Target","conditionKey":"haveCorrectTarget","paramKeys":["targetId"]},"children":[]},{"id":"node-002","type":"SequenceNode","inputs":{"name":"Get Target"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Target Is Valid","conditionKey":"isValidTarget","paramKeys":["targetId","spawnType"]},"children":[]},{"id":"node-004","type":"TargetNode","inputs":{"name":"Target","targetIdKey":"targetId","targetTypeKey":"spawnType"},"children":[]}]}]}'
trees["mem"] =
'{"id":"node-000","type":"SelectNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"SequenceNode","inputs":{"name":"Start Mem"},"children":[{"id":"node-002","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]}]},{"id":"node-004","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-005","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-006","type":"MemorizeSpellNode","inputs":{"name":"Memorize Spell","spellGemKey":"spellGem","spellIdKey":"spellId"},"children":[]},{"id":"node-007","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]},{"id":"node-008","type":"SequenceNode","inputs":{"name":"WaitingForMem"},"children":[{"id":"node-009","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]},{"id":"node-010","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-011","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-012","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]}]}'
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace

local spawn = mq.TLO.Spawn
local theSpawn = spawn(8770)
print(theSpawn.ID())

local tickSpeed = 100
local args = { ... }
local treeName = args[1] or "sit"

local blackboard = { ["targetId"] = 8770, ["spellId"] = 202, ["spawnType"] = "npc", ["spellGem"] = 6, deltaTime = 0 }
local myTree = bt.new(trees[treeName], blackboard)
local startTime = socket.gettime()
local status = NodeState.Running
while status == NodeState.Running do
    status = myTree.Tick()
    mq.delay(tickSpeed)
    local currentTime = socket.gettime()
    blackboard.deltaTime = (currentTime - startTime) * 1000
    startTime = currentTime
end
printf("Finished with %s", NodeState[status])
