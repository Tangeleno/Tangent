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
            node:AddChild(childNode)
        end
    end

    return node
end

---@class BehaviorTree
local BehaviorTree = {}
BehaviorTree.__index = BehaviorTree

--- Constructor for creating a new BehaviorTree
---@param jsonString string JSON string defining the behavior tree
---@return BehaviorTree
function BehaviorTree.new(jsonString)
    ---@class BehaviorTree
    local self = setmetatable({}, BehaviorTree)
    self.rootNode = buildNode(rapidjson.decode(jsonString))
    return self
end

--- Ticks the behavior tree with the given blackboard
---@param blackboard StateClass The blackboard data for the behavior tree
---@return NodeState
function BehaviorTree:Tick(blackboard)

    mq.Write.Debug("Ticking the tree with blackboard %s", blackboard.encode and blackboard:encode() or "can't encode" )
    return self.rootNode:Tick(blackboard)
end

---comment
---@param blackboard table
function BehaviorTree:Abort(blackboard)
    self.rootNode:Abort(blackboard)
end

---comment
---@return boolean
function BehaviorTree:IsTerminated()
    return self.rootNode:IsTerminated()
end


return BehaviorTree
