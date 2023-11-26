--[[ Json Sample
{
  "name": "Root Node",
  "type": "RepeatNode",
  "repeatCount": 1,
  "children": [
    {
      "name": "My Selector",
      "type": "SelectNode",
      "children": [
        {
          "type": "SequenceNode",
          "name": "My Sequence Node",
          "children": [
            {
              "type": "ActionNode",
              "name": "Print From Sequence",
              "actionName": "Print",
              "paramKeys": ["message", "append"]
            }
          ]
        },
        {
          "type": "InvertNode",
          "name": "My Inverter",
          "children": [
            {
              "type": "ActionNode",
              "name": "Print From Sequence",
              "actionName": "Print",
              "paramKeys": ["message", "append"]
            }
          ]
        },
        {
            "type":"RetryNode",
            "name":"My Retryer",
            "repeatCount":2,
            "children":[
                {
                    "type":"ParallelNode",
                    "name":"All the things",
                    "children":[
                        {
                            "type":"ActionNode",
                            "name":"Attack Enemy",
                            "actionName":"Attack",
                            "ParamKeys":[
                                "targetId",
                                "melee"
                            ]
                        }
                    ]
                }
            ]
        }
      ]
    }
  ]
}

]]
local mq = require "libs.Helpers.MacroQuestHelpers"
local rapidjson = require "rapidjson"
local Nodes = require "libs.behavior.behavior" -- Adjust the path to your module
local NodeState = require "libs.behavior.NodeState"

---@param jsonNode table
---@return Node
local function buildNode(jsonNode)
    local nodeType = jsonNode.type
    local name = jsonNode.name
    ---@type Node
    local node
    if nodeType == "SelectNode" then
        node = Nodes.CompositeNodes.SelectNode.new(name)
    elseif nodeType == "SequenceNode" then
        node = Nodes.CompositeNodes.SequenceNode.new(name)
    elseif nodeType == "ParallelNode" then
        node = Nodes.CompositeNodes.ParallelNode.new(name, jsonNode.percentage)
    elseif nodeType == "InvertNode" then
        node = Nodes.DecoratorNodes.InvertNode.new(name)
    elseif nodeType == "RepeatNode" then
        node = Nodes.DecoratorNodes.RepeatNode.new(name, jsonNode.repeatCount)
    elseif nodeType == "RetryNode" then
        node = Nodes.DecoratorNodes.RetryNode.new(name, jsonNode.repeatCount)
    elseif nodeType == "ActionNode" then
        node = Nodes.ActionNode.new(name, jsonNode.actionName, jsonNode.paramKeys)
    elseif nodeType == "WaitNode" then
        node = Nodes.WaitNode.new(name, jsonNode.time)
    elseif nodeType == "RandomSelector" then
        node = Nodes.CompositeNodes.RandomSelector.new(name)
    elseif nodeType == "FailerNode" then
        node = Nodes.FailerNode.new(name)
    elseif nodeType == "SucceederNode" then
        node = Nodes.SucceederNode.new(name)
    elseif nodeType == "LoopNode" then
        node = Nodes.DecoratorNodes.LoopNode.new(name, jsonNode.loopCount, jsonNode.conditionName)
    elseif nodeType == "ConditionNode" then
        node = Nodes.ConditionNode.new(name, jsonNode.conditionName, jsonNode.paramKeys)
    else
        error("Unknown node type: " .. nodeType)
    end

    -- If the node has children, recursively build them
    if jsonNode.children then
        for _, childJson in ipairs(jsonNode.children) do
            local childNode = buildNode(childJson)
            node.AddChild(childNode)
        end
    end

    return node
end

---@param node Node|CompositeNode|DecoratorNode
---@return Node|nil
local function findRunningNode(node)
    if node.State == NodeState.Running then
        return node
    end
    if node.Children then
        for _, child in ipairs(node.Children) do
            local runningNode = findRunningNode(child)
            if runningNode then
                return runningNode
            end
        end
    end
    return nil
end

---@class BehaviorTree
local BehaviorTree = {}

---@param jsonString string
---@param blackboard table
---@return BehaviorTree
function BehaviorTree.new(jsonString, blackboard)
    ---@class BehaviorTree
    local self = {}
    local rootNode = buildNode(rapidjson.decode(jsonString))
    local currentRunningNode = nil

    function self.Tick()
        local state = nil
        mq.Write.Debug("Ticking the tree with blackboard %s",rapidjson.encode(blackboard))
        if currentRunningNode then
            -- Resume the running node
            state = currentRunningNode.Tick(blackboard)
            if state ~= NodeState.Running then
                -- If the node is no longer running, reset it
                currentRunningNode = nil
            end
        else
            
            -- Start the tree from the root
            state = rootNode.Tick(blackboard)
            if state == NodeState.Running then
                -- Find the running node to resume next tick
                currentRunningNode = findRunningNode(rootNode)
            end
        end
        return state
    end

    return self
end

return BehaviorTree
