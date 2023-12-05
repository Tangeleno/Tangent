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

---@class ParallelNode
local ParallelNode = {}

--- Constructor for ParallelNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Parallel node.
---   - percentage: number @Percentage of nodes that need to have succeeded for this node to succeed.
---   - breakOnThreshold: boolean @Whether to break early if the success or failure threshold is reached (optional).
---@return ParallelNode @The created ParallelNode instance
function ParallelNode.new(args)
    ---This node will run all children 'simultaneously', returning 'Running' until all nodes have finished.
    ---@class ParallelNode:CompositeNode
    local self = CompositeNode.new(args.name)
    self.NodeType = "ParallelNode"
    ---@type Node[]
    local activeNodes = {}
    local totalNodes = 0

    if args.percentage <= 0 or args.percentage > 100 then
        mq.Write.Warn("Percentage not between 0 and 100, defaulting to 50%")
        args.percentage = 50
    end
    args.percentage = args.percentage * 0.01
    totalNodes = #self.Children
    mq.Write.Trace("Creating %s: %s, percentage: %f", self.NodeType, self.Name, args.percentage)

    function self._OnInitialize(blackboard)
    end

    function self._Update(blackboard)
        if not self.Children or #self.Children == 0 then
            mq.Write.Warn("No children found in ParallelNode: %s", args.name)
            return NodeState.Failure
        end

        local successCount = 0
        local failCount = 0

        -- Tick all the children
        for _, child in ipairs(self.Children) do
            child.Tick(blackboard)
            if child.IsSuccess() then
                successCount = successCount + 1
            elseif child.IsFailure() then
                failCount = failCount + 1
            end
            if args.breakOnThreshold then
                local state = evaluateState(successCount, failCount, totalNodes, args.percentage)
                if state ~= NodeState.Running then
                    return state
                end
            end
        end

        return evaluateState(successCount, failCount, totalNodes, args.percentage)
    end

    return self
end

return ParallelNode
