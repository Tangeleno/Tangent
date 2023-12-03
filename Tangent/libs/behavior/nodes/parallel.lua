local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"


---evaluates if the node is still running or has completed
---@param successCount number the current number of successful nodes
---@param failCount number the current number of failed nodes
---@param totalNodes number the total number of nodes
---@param percentage number the threshold percentage
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

---@class ParallelNode
local ParallelNode = {}
---@param name string @Name of the Parallel node
---@param percentage number @Percentage of nodes that need to have succeeded for this node to succeed
---@return ParallelNode @The created ParallelNode instance
function ParallelNode.new(name, percentage, breakOnThreshold)
    ---This node will run all children 'simultaneously', returning 'Running' until all nodes have finished.
    ---@class ParallelNode:CompositeNode
    local self = CompositeNode.new(name)
    self.NodeType = "ParallelNode"
    ---@type Node[]
    local activeNodes = {}
    local totalNodes = 0
    mq.Write.Trace("Creating %s: %s, percentage: %f", self.NodeType, self.Name, percentage)

    function self._OnInitialize(blackboard)
        totalNodes = #self.Children
        percentage = percentage * 0.01;
    end

    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in ParallelNode: %s", name)
            return NodeState.Failure
        end
        local successCount = 0
        local failCount = 0

        --Tick all the
        for _, child in ipairs(self.Children) do
            child.Tick(blackboard)
            if child.IsSuccess() then
                successCount = successCount + 1;
            elseif child.IsFailure() then
                failCount = failCount + 1
            end
            if breakOnThreshold then
                local state = evaluateState(successCount, failCount, totalNodes, percentage)
                if state ~= NodeState.Running then
                    return state
                end
            end
        end

        return evaluateState(successCount, failCount, totalNodes, percentage)
    end

    return self
end

return ParallelNode
