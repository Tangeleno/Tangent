local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@class WaitNode
local WaitNode = {}
---@param name string @Name of the Wait node.
---@param time number @Time to wait in seconds.
function WaitNode.new(name, time)
    ---@class WaitNode:Node
    local self = Node.new(name)
    self.NodeType = "WaitNode"
    mq.Write.Trace("Creating %s: %s waitTime: %f", self.NodeType, self.Name,time)
    time = time or 0
    local elapsedTime = 0
    function self._Update(blackboard)
        elapsedTime = elapsedTime + blackboard.deltaTime
        if elapsedTime >= time then
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