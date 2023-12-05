local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

--- Creates a node that waits for a specified duration.
---@class WaitNode
local WaitNode = {}

--- Constructor for WaitNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Wait node.
---   - time: number @Time to wait in seconds.
---@return WaitNode @The created WaitNode instance
function WaitNode.new(args)
    ---@class WaitNode:Node
    local self = Node.new(args.name)
    self.NodeType = "WaitNode"
    mq.Write.Trace("Creating %s: %s waitTime: %f", self.NodeType, args.name, args.time)
    local elapsedTime = 0

    function self._Update(blackboard)
        elapsedTime = elapsedTime + blackboard.deltaTime
        if elapsedTime >= args.time * 1000 then
            return NodeState.Success
        end
        return NodeState.Running
    end

    function self._OnInitialize()
        elapsedTime = 0
    end

    return self
end

return WaitNode
