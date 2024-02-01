local mq = require "libs.Helpers.MacroQuestHelpers"
local DecoratorNode = require "libs.behavior.nodes.decorator"

---@class RepeatNodeArgs : NodeArgs
---@field name string @Name of the Repeat node.
---@field repeatCount number @Number of times to repeat the node.

--- Repeats the child node the specified number of times, or until failure.
---@class RepeatNode : DecoratorNode
---@field currentCount integer @The current count of repetitions.
---@field repeatCount integer @The total number of times to repeat the child node.
local RepeatNode = {}
setmetatable(RepeatNode, { __index = DecoratorNode }) -- Inherit from Node
--- Constructor for RepeatNode.
---@param args RepeatNodeArgs @Table containing the arguments for the node.
---@return RepeatNode @The created RepeatNode instance
function RepeatNode.new(args)
    ---@class RepeatNode:DecoratorNode
    local self = setmetatable(DecoratorNode.new(args), { __index = RepeatNode }) -- Set SitNode as its metatable
    self.NodeType = "RepeatNode"
    self.currentCount = 0
    self.repeatCount = args.repeatCount or 1 -- Default to 1 if not provided

    mq.Write.Trace("%s: Creating RepeatNode '%s' with repeatCount: %d", self.NodeType, self.Name, self.repeatCount)

    return self
end

function RepeatNode:_OnInitialize(blackboard)
    mq.Write.Trace("%s: Initializing RepeatNode '%s'", self.NodeType, self.Name)
    self.currentCount = 0
end

function RepeatNode:_Update(blackboard)
    if not self.Child then
        mq.Write.Error("%s: RepeatNode '%s' has no child to repeat", self.NodeType, self.Name)
        return self.States.Failure
    end

    self.Child:Tick(blackboard)

    if self.Child:IsSuccess() then
        self.currentCount = self.currentCount + 1
        mq.Write.Debug("%s: RepeatNode '%s' child succeeded %d/%d times", self.NodeType, self.Name, self.currentCount,
            self.repeatCount)

        if self.currentCount >= self.repeatCount then
            mq.Write.Trace("%s: RepeatNode '%s' completed the specified number of repeats", self.NodeType, self.Name)
            return self.States.Success
        end

        return self.States.Running
    end

    return self.Child.State
end

return RepeatNode
