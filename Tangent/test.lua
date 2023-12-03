local mq = require "libs.Helpers.MacroQuestHelpers"
local bt, States = require "libs.behavior.behaviorTree"
local NodeState = require "libs.behavior.NodeState"

local trees = {}
trees["sit"] =
'{  "name": "Root Node",  "type": "SelectNode",  "children": [    {      "name": "Am sitting",      "type": "ConditionNode",      "conditionName":"sitting"    },    {      "name": "Sit down",      "type": "ActionNode",      "actionName":"sit"    }  ]}'
trees["target"] =
'{"name":"Target","id":"node-010","type":"SequenceNode","children":[{"name":"Not","id":"node-016","type":"InvertNode","children":[{"name":"Have Target","id":"node-011","type":"ConditionNode","conditionName":"haveCorrectTarget","paramKeys":["targetId"],"children":[]}]},{"name":"Target Is Valid","id":"node-013","type":"ConditionNode","conditionName":"isValidTarget","paramKeys":["targetId","spawnType"],"children":[]},{"name":"Target","id":"node-014","type":"ActionNode","actionName":"target","paramKeys":["targetId","spawnType"],"children":[]}]}'
trees["mem"] =
'{"name":"Memspell","id":"node-000","type":"SelectNode","children":[{"name":"Is Spell Memmed","id":"node-001","type":"ConditionNode","conditionName":"spellMemorized","paramKeys":["spellId"],"children":[]},{"name":"Handle Memorizing","id":"node-002","type":"SequenceNode","children":[{"name":"Not","id":"node-003","type":"InvertNode","children":[{"name":"Spell Memorizing","id":"node-004","type":"ConditionNode","conditionName":"spellMemorizing","paramKeys":[],"children":[]}]},{"name":"Mem Spell","id":"node-006","type":"ActionNode","actionName":"memspell","paramKeys":["spellGem","spellId"],"children":[]},{"name":"Wait For Mem to start","id":"node-009","type":"WaitNode","time":0.5,"children":[]},{"name":"Wait For Mem","id":"node-005","type":"SelectNode","children":[{"name":"Is Spell Memmed","id":"node-007","type":"ConditionNode","conditionName":"spellMemorized","paramKeys":["spellId"],"children":[]},{"name":"Wait For Mem","id":"node-008","type":"WaitNode","time":30,"children":[]}]}]}]}'
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace

print("hello")
local tickSpeed = 500
local args = { ... }
local treeName = args[1] or "sit"
local myTree = bt.new(trees[treeName],
    { ["targetId"] = 7727, ["spellId"] = 202, ["spawnType"] = "npc", ["spellGem"] = 6, deltaTime = tickSpeed / 1000 })
local status = myTree.Tick()
while status == NodeState.Running do
    mq.delay(tickSpeed)
    status = myTree.Tick()
end