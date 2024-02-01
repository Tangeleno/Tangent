local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

--- Creates a node that returns the first failed child or success if all children succeed.
---@class SequenceNode
local SequenceNode = {}
setmetatable(SequenceNode, { __index = CompositeNode }) -- Inherit from Node

--- Constructor for SequenceNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return SequenceNode @The created SequenceNode instance
function SequenceNode.new(args)
    ---@class SequenceNode:CompositeNode
    local self = setmetatable(CompositeNode.new(args), { __index = SequenceNode }) -- Set SitNode as its metatable
    self.NodeType = "SequenceNode"
    self.CurrentChildIndex = 1
    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    return self
end

function SequenceNode:_OnInitialize(blackboard)
    self.CurrentChildIndex = 1
end

---@return NodeState
function SequenceNode:_Update(blackboard)
    for i = self.CurrentChildIndex, #self.Children do
        self.CurrentChildIndex = i -- Update CurrentChildIndex at the start of the loop
        local child = self.Children[i]
        child:Tick(blackboard)
        if child.State == NodeState.Invalid then
            mq.Write.Trace("%s: %s received Invalid state from a child, terminating", self.NodeType, self.Name)
            return NodeState.Invalid
        end
        if child:IsRunning() or child:IsFailure() then
            return child.State
        end
    end

    -- If all children are ticked and none are successful, return Success
    return NodeState.Success
end

return SequenceNode
