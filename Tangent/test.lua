local mq = require "libs.Helpers.MacroQuestHelpers"
local bt, States = require "libs.behavior.behaviorTree"
local NodeState = require "libs.behavior.NodeState"
local sitTree =
'{  "name": "Root Node",  "type": "SequenceNode",  "children": [    {      "name": "Am Standing",      "type": "ConditionNode",      "conditionName":"standing"    },    {      "name": "Sit down",      "type": "ActionNode",      "actionName":"sit"    }  ]}'
local targetTree =
'{"name":"Target","id":"node-000","type":"SelectNode","children":[{"name":"Have Target","id":"node-003","type":"ConditionNode","conditionName":"haveCorrectTarget","paramKeys":["targetId"],"children":[]},{"name":"Get Target","id":"node-001","type":"SequenceNode","children":[{"name":"Target Is Valid","id":"node-004","type":"ConditionNode","conditionName":"isValidTarget","paramKeys":["targetId","spawnType"],"children":[]},{"name":"Target","id":"node-005","type":"ActionNode","actionName":"target","paramKeys":["targetId","spawnType"],"children":[]}]}]}'
local memTree ='{"name":"Memspell","id":"node-000","type":"SelectNode","children":[{"name":"Is Spell Memmed","id":"node-001","type":"ConditionNode","conditionName":"spellMemorized","paramKeys":["spellId"],"children":[]},{"name":"Handle Memorizing","id":"node-002","type":"SequenceNode","children":[{"name":"Not","id":"node-003","type":"InvertNode","children":[{"name":"Spell Memorizing","id":"node-004","type":"ConditionNode","conditionName":"spellMemorizing","paramKeys":[],"children":[]}]},{"name":"Mem Spell","id":"node-006","type":"ActionNode","actionName":"memspell","paramKeys":["spellGem","spellId"],"children":[]},{"name":"Wait For Mem to start","id":"node-009","type":"WaitNode","time":0.5,"children":[]},{"name":"Wait For Mem","id":"node-005","type":"SelectNode","children":[{"name":"Is Spell Memmed","id":"node-007","type":"ConditionNode","conditionName":"spellMemorized","paramKeys":["spellId"],"children":[]},{"name":"Wait For Mem","id":"node-008","type":"WaitNode","time":30,"children":[]}]}]}]}'
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace

local tickSpeed = 500

local myTree = bt.new(memTree, { ["targetId"] = 7727, ["spellId"] = 202, ["spawnType"] = "npc", ["spellGem"] = 6,deltaTime = tickSpeed/1000})
while myTree.Tick() == NodeState.Running do

    mq.delay(tickSpeed)
end
