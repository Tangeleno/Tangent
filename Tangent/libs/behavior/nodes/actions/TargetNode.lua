local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class TargetNodeArgs : NodeArgs
---@field name string @Name of the TargetAction node.
---@field targetIdKey string @Key to extract the target id from the blackboard.
---@field targetTypeKey string @Key to extract the target type from the blackboard (optional).

---@class TargetNode : Node
---@field targetStarted boolean @Flag indicating if targeting has started.
---@field targetTimer number @Timer to track how long since targeting started.
---@field targetId string @ID of the target extracted from the blackboard.
---@field targetType string @Type of the target (e.g., "any") extracted from the blackboard.
local TargetNode = {}

--- Constructor for TargetNode.
---@param args TargetNodeArgs @Table containing the arguments for the node.
---@return TargetNode @The created TargetNode instance
function TargetNode.new(args)
    ---@class TargetNode : Node
    local self = Node.new(args.name)
    self.NodeType = "TargetNode"

    mq.Write.Trace("%s: Creating TargetNode with targetIdKey: '%s', targetTypeKey: '%s'", args.name, args.targetIdKey,
        args.targetTypeKey or "nil")

    self.targetStarted = false
    self.targetTimer = 0

    function self._OnInitialize(blackboard)
        mq.Write.Debug("%s: Initializing TargetNode", args.name)
        self.targetId = blackboard[args.targetIdKey]
        self.targetType = blackboard[args.targetTypeKey] or "any"
        self.targetStarted = false
        self.targetTimer = 0
    end

    function self._Update(blackboard)

        if mq.TLO.Target.ID() == self.targetId then
            return NodeState.Success
        end

        if mq.IsValidTarget(self.targetId, self.targetType) then
            if self.targetStarted and self.targetTimer < 500 then
                self.targetTimer = self.targetTimer + blackboard.deltaTime
                return NodeState.Running
            else
                mq.TLO.Spawn(self.targetId).DoTarget()
                self.targetStarted = true
                self.targetTimer = 0
                return NodeState.Running
            end
        else
            mq.Write.Warn("%s: Invalid target ID %s or type %s", args.name, self.targetId, self.targetType)
            return NodeState.Failure
        end
    end

    return self
end

return TargetNode
