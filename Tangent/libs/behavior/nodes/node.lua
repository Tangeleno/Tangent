local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"

---@class NodeArgs
---@field name string

---@class Node
local Node = {
    States = NodeState
}

--- Constructor for Node.
---@param args NodeArgs @Arguments for the node.
---@return Node @The created Node instance
function Node.new(args)
    ---@class Node
    local self = {
        Name = args.name,
        ---@type NodeState
        State = NodeState.Invalid,
        NodeType = "BaseNode"
    }
    mq.Write.Trace("%s: Creating Node named '%s'", self.NodeType, self.Name)

    --- Protected update function called by Tick.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    ---@return NodeState @The state of the node after processing.
    function self._Update(blackboard)
        return NodeState.Invalid
    end

    --- Protected cleanup function, called when the node is terminated.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    function self._OnTerminate(blackboard)
        -- Override in derived classes for cleanup.
    end

    --- Protected initialization function, called before the node's first update after not being in the 'Running' state.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    function self._OnInitialize(blackboard)
        -- Override in derived classes for initialization.
    end

    --- Tick function called each update cycle.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    ---@return NodeState @The state of the node after the tick operation.
    function self.Tick(blackboard)
        mq.Write.Trace("%s '%s': Tick entered", self.NodeType, self.Name)
        if self.State ~= NodeState.Running then
            mq.Write.Trace("%s '%s': Initializing", self.NodeType, self.Name)
            self.State = self._OnInitialize(blackboard) or self.State
        end

        mq.Write.Debug("%s: Updating %s", self.Name, self.NodeType)
        self.State = self._Update(blackboard)
        mq.Write.Trace("%s '%s': Update returned status '%s'", self.NodeType, self.Name, NodeState[self.State])

        if self.State ~= NodeState.Running then
            mq.Write.Trace("%s '%s': Terminating", self.NodeType, self.Name)
            self._OnTerminate(blackboard)
        end
        return self.State
    end

    --- Aborts the node's execution.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    function self.Abort(blackboard)
        mq.Write.Trace("%s '%s': Aborting", self.NodeType, self.Name)
        self._OnTerminate(blackboard)
        self.State = NodeState.Aborted
    end

    --- Returns true if the node is in a terminated state; otherwise, false.
    ---@return boolean
    function self.IsTerminated()
        return self.State == NodeState.Success or self.State == NodeState.Failure or self.State == NodeState.Aborted
    end

    --- Returns true if the node is in a success state; otherwise, false.
    ---@return boolean
    function self.IsSuccess()
        return self.State == NodeState.Success
    end

    --- Returns true if the node is in a failure state; otherwise, false.
    ---@return boolean
    function self.IsFailure()
        return self.State == NodeState.Failure or self.State == NodeState.Aborted or self.State == NodeState.Invalid
    end

    --- Returns true if the node is in a running state; otherwise, false.
    ---@return boolean
    function self.IsRunning()
        return self.State == NodeState.Running
    end

    return self
end

return Node
