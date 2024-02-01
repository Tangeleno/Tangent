local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"
local Conditions = require "libs.behavior.conditions"

--- The arguments required to construct a LoopNode.
---@class LoopNodeArgs : NodeArgs
---@field loopCount number @Number of times to execute the child node.
---@field conditionKey string @A key that references a condition function in the conditions table. This function should return a boolean. If false, the loop will terminate early (optional).

--- Represents a node that loops its child node a specified number of times, or until a condition is met.
---@class LoopNode:DecoratorNode
---@field NodeType string @The type of the node.
---@field LoopCount number @The total number of times to loop the child node.
---@field CurrentLoop number @The current loop iteration the node is on.
---@field ConditionKey string @The key to retrieve the condition function from the conditions table.
---@field ConditionFunction function @The condition function that determines if the loop should terminate early.
local LoopNode = {}
setmetatable(LoopNode, { __index = DecoratorNode }) -- Inherit from Node
--- Constructor for LoopNode.
---@param args LoopNodeArgs @Table containing the arguments for the node.
---@return LoopNode @The created LoopNode instance
function LoopNode.new(args)
    ---@class LoopNode:DecoratorNode
    local self = setmetatable(DecoratorNode.new(args), { __index = LoopNode }) -- Set SitNode as its metatable
    self.NodeType = "LoopNode"
    self.LoopCount = args.loopCount or 1
    self.CurrentLoop = 0
    self.ConditionKey = args.conditionKey
    self.ConditionFunction = Conditions[args.conditionKey]

    mq.Write.Trace("%s: Creating '%s' with loop count: %d", self.NodeType, self.Name, self.LoopCount)

    return self
end

function LoopNode:_OnInitialize(blackboard)
    self.CurrentLoop = 0
    mq.Write.Trace("%s '%s': Initialized with loop count %d", self.NodeType, self.Name, self.LoopCount)
end

function LoopNode:_Update(blackboard)
    if self.ConditionKey and self.ConditionFunction and not self.ConditionFunction(blackboard) then
        mq.Write.Debug("%s '%s': Condition '%s' failed, terminating loop early", self.NodeType, self.Name,
            self.ConditionKey)
        return NodeState.Failure
    end

    local childStatus = self.Child:Tick(blackboard)
    if childStatus == NodeState.Success then
        self.CurrentLoop = self.CurrentLoop + 1
        mq.Write.Debug("%s '%s': Loop iteration %d/%d completed successfully", self.NodeType, self.Name, self
        .CurrentLoop, self.LoopCount)
        if self.CurrentLoop < self.LoopCount then
            return NodeState.Running
        else
            mq.Write.Debug("%s '%s': Completed all iterations successfully", self.NodeType, self.Name)
            return NodeState.Success
        end
    end

    mq.Write.Debug("%s '%s': Child node returned %s", self.NodeType, self.Name, NodeState[childStatus])
    return childStatus
end

return LoopNode
