local mq = require "libs.Helpers.MacroQuestHelpers"
local bt, States = require "libs.behavior.behaviorTree"
local NodeState = require "libs.behavior.NodeState"
local sitTree =
'{  "name": "Root Node",  "type": "SequenceNode",  "children": [    {      "name": "Am Standing",      "type": "ConditionNode",      "conditionName":"standing"    },    {      "name": "Sit down",      "type": "ActionNode",      "actionName":"sit"    }  ]}'
local targetTree =
'{    "name": "Root Node",    "type": "SequenceNode",    "children": [      {        "name": "TargetInverter",        "type": "InvertNode",        "children": [{ "name": "Have Target", "type": "ConditionNode", "conditionName": "haveCorrectTarget", "paramKeys": ["targetId"] }]      },      { "name": "Target Is Valid", "type": "ConditionNode", "conditionName": "isValidTarget", "paramKeys": ["targetId", "spawnType"] },      { "name": "Target", "type": "ActionNode", "actionName": "target","paramKeys": ["targetId", "spawnType"]}    ]  }  '
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace
local myTree = bt.new(targetTree, { ["targetId"] = 7674, ["spawnType"] = "npc" })
while myTree.Tick() == NodeState.Running do
    mq.delay(10)
end
