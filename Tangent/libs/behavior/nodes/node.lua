local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"

---@class NodeArgs
---@field name string


-- Define the base Node table
---@class Node
---@field protected States NodeStates
---@field protected Args NodeArgs
---@field public NodeType string
---@field public Name string
local Node = {}
Node.__index = Node -- Set the __index metamethod of Node to itself
Node.States = NodeState

--- Constructor for Node.
---@param args NodeArgs @Arguments for the node.
---@return Node @The created Node instance
function Node.new(args)
    local instance = setmetatable({
        Name = args.name,
        State = NodeState.Invalid,
        NodeType = "BaseNode",
        Args = args
    }, Node)

    mq.Write.Trace("%s: Creating Node named '%s'", instance.NodeType, instance.Name)
    return instance
end

---Update function called by Tick.
---@param blackboard table @The blackboard being used by the behavior tree.
---@return NodeState @The state of the node after processing.
---@protected
function Node:_Update(blackboard)
    return NodeState.Invalid
end

---Cleanup function, called when the node is terminated.
---@param blackboard table @The blackboard being used by the behavior tree.
---@protected
function Node:_OnTerminate(blackboard)
    -- Override in derived classes for cleanup.
end

---Initialization function, called before the node's first update after not being in the 'Running' state.
---@param blackboard table @The blackboard being used by the behavior tree.
---@protected
function Node:_OnInitialize(blackboard)
    -- Override in derived classes for initialization.
end

---Tick function called each update cycle.
---@param blackboard table @The blackboard being used by the behavior tree.
---@return NodeState @The state of the node after the tick operation.
---@public
function Node:Tick(blackboard)
    mq.Write.Trace("%s '%s': Tick entered", self.NodeType, self.Name)
    if self.State ~= NodeState.Running then
        mq.Write.Trace("%s '%s': Initializing", self.NodeType, self.Name)
        self.State = self:_OnInitialize(blackboard) or self.State
    end

    mq.Write.Debug("%s: Updating %s", self.Name, self.NodeType)
    self.State = self:_Update(blackboard)
    mq.Write.Trace("%s '%s': Update returned status '%s'", self.NodeType, self.Name, NodeState[self.State])

    if self.State ~= NodeState.Running then
        mq.Write.Trace("%s '%s': Terminating", self.NodeType, self.Name)
        self:_OnTerminate(blackboard)
    end
    return self.State
end

---Aborts the node's execution.
---@param blackboard table @The blackboard being used by the behavior tree.
---@public
function Node:Abort(blackboard)
    mq.Write.Trace("%s '%s': Aborting", self.NodeType, self.Name)
    self:_OnTerminate(blackboard)
    self.State = NodeState.Aborted
end

--- Returns true if the node is in a terminated state; otherwise, false.
---@return boolean
---@public
function Node:IsTerminated()
    return self.State == NodeState.Success or self.State == NodeState.Failure or self.State == NodeState.Aborted
end

--- Returns true if the node is in a success state; otherwise, false.
---@return boolean
---@public
function Node:IsSuccess()
    return self.State == NodeState.Success
end

--- Returns true if the node is in a failure state; otherwise, false.
---@return boolean
---@public
function Node:IsFailure()
    return self.State == NodeState.Failure or self.State == NodeState.Aborted or self.State == NodeState.Invalid
end

--- Returns true if the node is in a running state; otherwise, false.
---@return boolean
---@public
function Node:IsRunning()
    return self.State == NodeState.Running
end

return Node
