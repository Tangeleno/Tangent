local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"

---@class RetryNodeArgs : NodeArgs
---@field name string @Name of the Retry node.
---@field repeatCount number @Number of times to retry the node.

--- Repeats the child node the specified number of times, or until success
---@class RetryNode : DecoratorNode
---@field currentCount integer @The current count of retries.
---@field repeatCount integer @The total number of times to retry the child node..
local RetryNode = {}
setmetatable(RetryNode, { __index = DecoratorNode }) -- Inherit from Node
--- Constructor for RetryNode.
---@param args RetryNodeArgs @Table containing the arguments for the node.
---@return RetryNode @The created RetryNode instance
function RetryNode.new(args)
    ---@class RetryNode:DecoratorNode
    local self = setmetatable(DecoratorNode.new(args), { __index = RetryNode }) -- Set SitNode as its metatable
    self.NodeType = "RetryNode"
    self.currentCount = 0
    self.repeatCount = args.repeatCount or 1 -- Default to 1 if not provided

    mq.Write.Trace("%s: Creating RetryNode '%s' with repeatCount: %d", self.NodeType, self.Name, self.repeatCount)

    return self
end

function RetryNode:_OnInitialize(blackboard)
    mq.Write.Trace("%s: Initializing RetryNode '%s'", self.NodeType, self.Name)
    self.currentCount = 0
end

function RetryNode:_Update(blackboard)
    if not self.Child then
        mq.Write.Error("%s: RetryNode '%s' has no child to retry", self.NodeType, self.Name)
        return NodeState.Failure
    end

    local status = self.Child:Tick(blackboard)

    if status == NodeState.Failure then
        self.currentCount = self.currentCount + 1
        mq.Write.Debug("%s: RetryNode '%s' child failed %d/%d times", self.NodeType, self.Name, self.currentCount,
            self.repeatCount)

        if self.currentCount >= self.repeatCount then
            mq.Write.Trace("%s: RetryNode '%s' reached the maximum number of retries", self.NodeType, self.Name)
            return NodeState.Failure
        end

        return NodeState.Running
    end

    return status
end

return RetryNode
