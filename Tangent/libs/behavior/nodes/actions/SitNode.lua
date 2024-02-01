local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class SitNodeArgs : NodeArgs
---@field name string @Name of the SitAction node.
---@field maxSitAttempts number @The number of attempts that should be made before returning failure.

---@class SitNode:Node
---@field sitStarted boolean @Flag indicating if the sit action has started.
---@field sitTimer number @Timer to track the duration since the sit action started.
---@field sitAttempts number @The number of attempts made to sit.
---@field maxSitAttempts number @The number of attempts that should be made before returning failure.
local SitNode = {}
setmetatable(SitNode, { __index = Node }) -- Inherit from Node

--- Constructor for Sit.
---@param args SitNodeArgs @Table containing the arguments for the node.
---@return SitNode @The created Sit instance
function SitNode.new(args)
    ---@class SitNode:Node
    local self = setmetatable(Node.new(args), { __index = SitNode }) -- Set SitNode as its metatable
    self.NodeType = "Sit"
    self.sitStarted = false
    self.sitTimer = 0
    self.sitAttempts = 0
    self.maxSitAttempts = args.maxSitAttempts or 10

    mq.Write.Trace("%s: Creating SitNode with max attempts: %d", args.name, self.maxSitAttempts)
    return self
end

function SitNode:_OnInitialize(blackboard)
    mq.Write.Debug("%s: Initializing SitNode", self.Name)
    self.sitStarted = false
    self.sitTimer = 0
    self.sitAttempts = 0
end

function SitNode:_Update(blackboard)
    if mq.TLO.Me.Sitting() then
        return NodeState.Success
    elseif mq.TLO.Me.Standing() then
        if self.sitAttempts >= self.maxSitAttempts then
            mq.Write.Warn("%s: Exceeded max sit attempts", self.Name)
            return NodeState.Failure
        end
        if self.sitStarted and self.sitTimer < 500 then
            self.sitTimer = self.sitTimer + blackboard.deltaTime
            return NodeState.Running
        else
            mq.TLO.Me.Sit()
            self.sitStarted = true
            self.sitTimer = 0
            self.sitAttempts = self.sitAttempts + 1
            return NodeState.Running
        end
    end
    mq.Write.Warn("%s: Unable to sit - neither sitting nor standing detected", self.Name)
    return NodeState.Failure
end

return SitNode
