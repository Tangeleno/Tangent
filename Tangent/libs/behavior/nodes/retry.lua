local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"
---Repeats the child node the specified number of times, or until success
---@class RetryNode
local RetryNode = {}
---@param name string @Name of the Retry node
---@param repeatCount number @Number of times to retry the node
---@return RetryNode @The created RetryNode instance
function RetryNode.new(name, repeatCount)
    ---@class RetryNode:DecoratorNode
    local self = DecoratorNode.new(name)
    self.NodeType = "RetryNode"
    local currentCount = 0

    mq.Write.Trace("Creating %s: %s repeatCount: %d", self.NodeType, self.Name,repeatCount)

    function self._OnInitialize(blackboard)
        currentCount = 0
    end

    function self._Update(blackboard)
        local status = self.Child.Tick(blackboard)
        if status == NodeState.Failure then
            mq.Write.Trace("RetryNode %s child node failed, incrementing counter", name, currentCount)
            currentCount = currentCount + 1
            if currentCount >= repeatCount then
                mq.Write.Trace("RepeatNode %s giving up %d >= %d", name, currentCount, repeatCount)
                status = NodeState.Failure
            else
                status = NodeState.Running
            end
        end
        return status
    end

    return self
end

return RetryNode