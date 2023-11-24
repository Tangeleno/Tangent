local Conditions = require "libs.behavior.conditions"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@type WaitNode
local WaitNode = {}
---@param name string @Name of the Wait node.
---@param time number @Time to wait in seconds.
---@param conditionKey string @A key that references a condition function in the blackboard. This function should return a boolean. If true, the node will succeed before the time has elapsed.
function WaitNode.new(name, time, conditionKey)
    ---@class WaitNode:Node
    local self = Node.new(name)
    self.NodeType = "WaitNode"
    time = time or 0
    local elapsedTime = 0
    local condition = Conditions[conditionKey] or function() return false end

    function self._Update(blackboard)
        if condition(blackboard) then
            return NodeState.Success
        end

        elapsedTime = elapsedTime + blackboard.deltaTime
        if elapsedTime >= time then
            return NodeState.Success
        end
        return NodeState.Running
    end

    function self._OnInitialize()
        self.ElapsedTime = 0
    end

    return self
end
return WaitNode