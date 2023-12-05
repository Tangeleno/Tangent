local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"

--- Repeats the child node the specified number of times, or until failure.
---@class RepeatNode
local RepeatNode = {}

--- Constructor for RepeatNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Repeat node.
---   - repeatCount: number @Number of times to repeat the node.
---@return RepeatNode @The created RepeatNode instance
function RepeatNode.new(args)
    ---@class RepeatNode:DecoratorNode
    local self = DecoratorNode.new(args.name)
    self.NodeType = "RepeatNode"
    local currentCount = 0

    mq.Write.Trace("Creating %s: %s repeatCount: %d", self.NodeType, self.Name, args.repeatCount)

    function self._OnInitialize(blackboard)
        currentCount = 0
    end

    function self._Update(blackboard)
        local status = self.Child.Tick(blackboard)
        if status == NodeState.Success then
            mq.Write.Trace("RepeatNode %s child node succeeded, incrementing counter", args.name, currentCount)
            currentCount = currentCount + 1
            if currentCount >= args.repeatCount then
                mq.Write.Trace("RepeatNode %s completed the specified number of repeats %d >= %d", args.name, currentCount,
                    args.repeatCount)
                return NodeState.Success
            end
            return NodeState.Running
        end
        return status
    end

    return self
end

return RepeatNode
