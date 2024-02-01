local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

--- Creates a node that returns the first successful child or failure if all children fail.
---@class SelectNode:Node
local SelectNode = {}
setmetatable(SelectNode, { __index = CompositeNode }) -- Inherit from Node
--- Constructor for SelectNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return SelectNode @The created SelectNode instance
function SelectNode.new(args)
    ---@class SelectNode:CompositeNode
    local self = setmetatable(CompositeNode.new(args), { __index = SelectNode }) -- Set SitNode as its metatable
    self.NodeType = "SelectNode"
    self.CurrentChildIndex = 1
    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    return self
end

function SelectNode:_OnInitialize(blackboard)
    self.CurrentChildIndex = 1
end

---@return NodeState
function SelectNode:_Update(blackboard)
    for i = self.CurrentChildIndex, #self.Children do
        self.CurrentChildIndex = i -- Update CurrentChildIndex at the start of the loop
        local child = self.Children[i]
        child:Tick(blackboard)
        if child.State == NodeState.Invalid then
            mq.Write.Trace("%s: %s received Invalid state from a child, terminating", self.NodeType, self.Name)
            return NodeState.Invalid
        end
        
        if child:IsRunning() or child:IsSuccess() then
            return child.State
        end
    end
    -- If all children are ticked and none are successful, return Failure
    return NodeState.Failure
end

return SelectNode
