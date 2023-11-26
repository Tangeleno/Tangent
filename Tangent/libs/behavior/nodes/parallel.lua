local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

---@class ParallelNode
local ParallelNode = {}
---@param name string @Name of the Parallel node
---@param percentage number @Percentage of nodes that need to have succeeded for this node to succeed
---@return ParallelNode @The created ParallelNode instance
function ParallelNode.new(name, percentage)
    ---This node will run all children 'simultaneously', returning 'Running' until all nodes have finished.
    ---@class ParallelNode:CompositeNode
    local self = CompositeNode.new(name)
    self.NodeType = "ParallelNode"
    ---@type Node[]
    local activeNodes = {}
    local successNodes = 0
    local totalNodes = 0
    mq.Write.Trace("Creating %s: %s, percentage: %f", self.NodeType, self.Name, percentage)

    function self._OnInitialize(blackboard)
        activeNodes = {}
        for _, child in ipairs(self.Children) do
            table.insert(activeNodes, child)
            totalNodes = totalNodes + 1
        end
        successNodes = 0
    end

    ---@return NodeState
    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in ParallelNode: %s", name)
            return NodeState.Failure
        end
        local nodesToRemoveFromActive = {}
        for index, activeNode in ipairs(activeNodes) do
            activeNode.Tick(blackboard)
            if activeNode.IsSuccess() then
                successNodes = successNodes + 1
                table.insert(nodesToRemoveFromActive, index)
            elseif activeNode.IsFailure() then
                table.insert(nodesToRemoveFromActive, index)
            end
        end
        if #nodesToRemoveFromActive > 0 then
            for _, value in ipairs(nodesToRemoveFromActive) do
                table.remove(activeNodes, value)
            end
        end
        if #activeNodes > 0 then
            return NodeState.Running
        end
        if successNodes / totalNodes > percentage then
            mq.Write.Trace("ParallelNode succeeded with success rate: %f", successNodes / totalNodes)
            return NodeState.Success
        end
        mq.Write.Trace("ParallelNode failed with success rate: %f", successNodes / totalNodes)
        return NodeState.Failure
    end

    return self
end

return ParallelNode
