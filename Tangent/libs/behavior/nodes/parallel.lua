local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

--- Evaluates if the node is still running or has completed.
---@param successCount number The current number of successful nodes.
---@param failCount number The current number of failed nodes.
---@param totalNodes number The total number of nodes.
---@param percentage number The threshold percentage.
---@return NodeState
local function evaluateState(successCount, failCount, totalNodes, percentage)
    if successCount / totalNodes >= percentage then
        return NodeState.Success
    end
    if failCount / totalNodes >= percentage then
        return NodeState.Failure
    end
    return NodeState.Running
end

---@class ParallelNodeArgs : NodeArgs
---@field percentage number @Percentage of nodes that need to have succeeded for this node to succeed.
---@field breakOnThreshold string @(Optional) Determines the condition under which to terminate early. Can be "No", "SuccessOnly", "FailureOnly", or "Any".

---@class ParallelNode : CompositeNode
---@field percentage number @Percentage of child nodes that need to succeed for this node to succeed.
---@field Args ParallelNodeArgs
local ParallelNode = {}
setmetatable(ParallelNode, { __index = CompositeNode }) -- Inherit from Node
--- Constructor for ParallelNode.
---@param args ParallelNodeArgs @Table containing the arguments for the node.
---@return ParallelNode @The created ParallelNode instance
function ParallelNode.new(args)
    ---@class ParallelNode : CompositeNode
    local self = setmetatable(CompositeNode.new(args), { __index = ParallelNode }) -- Set SitNode as its metatable
    self.NodeType = "ParallelNode"
    self.percentage = args.percentage and args.percentage * 0.01 or 0.5            -- Default to 50% if not specified

    if self.percentage <= 0 or self.percentage > 1 then
        mq.Write.Warn("%s: Percentage not between 1 and 100, defaulting to 50%%", self.Name)
        self.percentage = 0.5
    end

    mq.Write.Trace("%s: Creating ParallelNode named '%s' with percentage %.2f", self.NodeType, self.Name,
        self.percentage * 100)
    return self
end

function ParallelNode:_OnInitialize(blackboard)
    -- Initialization logic specific to ParallelNode.
end

function ParallelNode:_Update(blackboard)
    if not self.Children or #self.Children == 0 then
        mq.Write.Warn("%s: No children found in ParallelNode '%s'", self.NodeType, self.Name)
        return NodeState.Failure
    end

    local successCount = 0
    local failCount = 0
    local isAnyRunning = false

    -- Tick all the children
    for _, child in ipairs(self.Children) do
        local childState = child:Tick(blackboard)
        if childState == NodeState.Success then
            successCount = successCount + 1
        elseif childState == NodeState.Failure then
            failCount = failCount + 1
        elseif childState == NodeState.Running then
            isAnyRunning = true
        end

        local state = evaluateState(successCount, failCount, #self.Children, self.percentage)
        if self.Args.breakOnThreshold:equals("Any") and state ~= NodeState.Running then
            mq.Write.Debug("%s: Early break on 'Any' threshold reached in ParallelNode '%s'", self.NodeType, self.Name)
            return state
        elseif self.Args.breakOnThreshold:equals("SuccessOnly") and state == NodeState.Success then
            mq.Write.Debug("%s: Early break on 'SuccessOnly' threshold reached in ParallelNode '%s'", self.NodeType,
                self.Name)
            return state
        elseif self.Args.breakOnThreshold:equals("FailureOnly") and state == NodeState.Failure then
            mq.Write.Debug("%s: Early break on 'FailureOnly' threshold reached in ParallelNode '%s'", self.NodeType,
                self.Name)
            return state
        end
    end

    if isAnyRunning then
        return NodeState.Running
    end
    return evaluateState(successCount, failCount, #self.Children, self.percentage)
end

return ParallelNode
