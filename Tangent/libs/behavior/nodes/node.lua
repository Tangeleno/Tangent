local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
---@type Node
local Node = {
    States = NodeState
}

---@param name string @Name of the node
---@return Node @The created Node instance
function Node.new(name)
    ---@class Node
    local self = {
        Name = name,
        ---@type NodeState
        State = NodeState.Invalid,
        NodeType = "Unknown"
    }
    --this is our true update function, this is is called by the Tick function to handle any actual state change.
    ---Do not call directly, this function is called by Tick()
    ---@protected
    ---@return NodeState
    function self._Update(blackboard)
        return NodeState.Invalid
    end

    --Cleanup function, this is called once the node is no longer running to clean up any variables
    ---Do not call directly, this is called automatically by Tick()
    ---@protected
    function self._OnTerminate(blackboard)
    end

    --Initialization function, called before the node is updated for the first time after not being in the 'Running' state
    ---@protected
    function self._OnInitialize(blackboard)
    end

    ---@param blackboard table @A table that contains shared data for the behavior tree, typically used for storing and retrieving values across different nodes.
    ---@return NodeState @Returns the state of the node after the tick operation, which can be one of the following values: Success, Failure, Running, or Invalid.
    function self.Tick(blackboard)
        mq.Write.Trace("Tick entered for %s %s", self.NodeType, self.Name)
        if self.State ~= NodeState.Running then
            mq.Write.Trace("Initializing Node %s %s", self.NodeType, self.Name)
            self._OnInitialize(blackboard)
        end
        self.State = self._Update()
        mq.Write.Trace("%s %s returned the status %s", self.NodeType, self.Name, NodeState[self.State])
        if self.State ~= NodeState.Running then
            mq.Write.Trace("Terminating Node %s %s", self.NodeType, self.Name)
            self._OnTerminate(blackboard)
        end
        return self.State
    end

    function self.Abort()
        mq.Write.Trace("Aborting Node %s", self.Name)
        self._OnTerminate()
        self.State = NodeState.Aborted
    end

    ---Returns true if the node is in a terminated state; otherwise, false.
    ---@return boolean
    function self.IsTerminated()
        return self.State == NodeState.Success or self.State == NodeState.Failure
    end

    ---Returns true if the node is in a success state; otherwise, false.
    ---@return boolean
    function self.IsSuccess()
        return self.State == NodeState.Success
    end

    ---Returns true if the node is in a failure state; otherwise, false.
    ---@return boolean
    function self.IsFailure()
        return self.State == NodeState.Failure or self.State == NodeState.Aborted or
            self.State == NodeState.Invalid
    end

    ---Returns true if the node is in a running state; otherwise, false.
    ---@return boolean
    function self.IsRunning()
        return self.State == NodeState.Running
    end

    return self
end
return Node