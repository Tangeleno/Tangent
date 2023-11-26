local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"---Repeats the child node the specified number of times, or until failure
---@class RepeatNode
local RepeatNode = {}
---@param name string @Name of the Repeat node
---@param repeatCount number @Number of times to repeat the node
---@return RepeatNode @The created RepeatNode instance
function RepeatNode.new(name, repeatCount)
    ---@class RepeatNode:DecoratorNode
    local self = DecoratorNode.new(name)
    self.NodeType = "RepeatNode"
    local currentCount = 0

    mq.Write.Trace("Creating %s: %s repeatCount: %d", self.NodeType, self.Name,repeatCount)

    function self._OnInitialize(blackboard)
        currentCount = 0
    end

    function self._Update(blackboard)
        local status = self.Child.Tick(blackboard)
        if status == NodeState.Success then
            mq.Write.Trace("RepeatNode %s child node succeeded, incrementing counter", name, currentCount)
            currentCount = currentCount + 1
            if currentCount >= repeatCount then
                mq.Write.Trace("RepeatNode %s completed the specified number of repeats %d >= %d", name, currentCount,
                    repeatCount)
                return NodeState.Success
            end
            return NodeState.Running
        end
        return status
    end

    return self
end

return RepeatNode