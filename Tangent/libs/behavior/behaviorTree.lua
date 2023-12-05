-- behaviortree.lua

local mq = require "libs.Helpers.MacroQuestHelpers"
local rapidjson = require "rapidjson"
local Nodes = require "libs.behavior.behavior" -- Adjust the path to your module
local NodeState = require "libs.behavior.NodeState"

---@param jsonNode table
---@return Node
local function buildNode(jsonNode)
    local nodeType = jsonNode.type
    local args = jsonNode.inputs or {}

    ---@type Node
    local node
    if Nodes[nodeType] and Nodes[nodeType].new then
        node = Nodes[nodeType].new(args)
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

---@class BehaviorTree
local BehaviorTree = {}

---@param jsonString string
---@param blackboard table
---@return BehaviorTree
function BehaviorTree.new(jsonString, blackboard)
    ---@class BehaviorTree
    local self = {}
    local rootNode = buildNode(rapidjson.decode(jsonString))

    function self.Tick()
        mq.Write.Debug("Ticking the tree with blackboard %s", rapidjson.encode(blackboard))
        return rootNode.Tick(blackboard)
    end

    return self
end

return BehaviorTree