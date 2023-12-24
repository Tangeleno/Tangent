local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class WaitNodeArgs : NodeArgs
---@field name string @Name of the Wait node.
---@field time number @Time to wait in seconds.

---@class WaitNode : Node
---@field NodeType string @The type of node, in this case, "WaitNode".
---@field elapsedTime number @Tracks the elapsed time since the node started.
local WaitNode = {}

--- Creates a node that waits for a specified duration.
---@param args WaitNodeArgs @Table containing the arguments for the node.
---@return WaitNode @The created WaitNode instance
function WaitNode.new(args)
    ---@class WaitNode:Node
    local self = Node.new(args)
    self.NodeType = "WaitNode"
    self.elapsedTime = 0
    mq.Write.Trace("%s: Creating '%s' with waitTime: %f seconds", self.NodeType, self.Name, args.time)

    --- Updates the WaitNode, checking if the specified wait time has elapsed.
    ---@param blackboard table @The blackboard being used by the behavior tree.
    ---@return NodeState @The state of the node after processing.
    function self._Update(blackboard)
        self.elapsedTime = self.elapsedTime + blackboard.deltaTime
        if self.elapsedTime >= args.time * 1000 then
            mq.Write.Debug("%s '%s': Wait time completed, returning Success", self.NodeType, self.Name)
            return NodeState.Success
        end
        return NodeState.Running
    end

    --- Initializes the WaitNode, resetting the elapsed time.
    function self._OnInitialize()
        mq.Write.Trace("%s '%s': Initializing, resetting elapsedTime", self.NodeType, self.Name)
        self.elapsedTime = 0
    end

    return self
end

return WaitNode