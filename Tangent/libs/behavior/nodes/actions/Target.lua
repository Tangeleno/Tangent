local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class TargetNode
local TargetNode = {}

--- Constructor for TargetNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the TargetAction node.
---   - targetIdKey: string @Key to extract the target id from the blackboard.
---   - targetTypeKey: string @Key to extract the target type from the blackboard (optional).
---@return TargetNode @The created TargetNode instance
function TargetNode.new(args)
    local name = args.name
    local targetIdKey = args.targetIdKey
    local targetTypeKey = args.targetTypeKey

    ---@class TargetNode:Node
    local self = Node.new(name)
    self.NodeType = "TargetNode"
    mq.Write.Trace("Creating %s: %s with targetIdKey %s, targetTypeKey %s", self.NodeType, name, targetIdKey, targetTypeKey or "nil")

    self.targetStarted = false
    self.targetTimer = 0

    function self._OnInitialize(blackboard)
        if not targetTypeKey then
            self.targetType = "any"
            mq.Write.Trace("Initializing %s: targetType set to 'any'", name)
        else
            self.targetType = blackboard[targetTypeKey]
            mq.Write.Trace("Initializing %s: targetType set to %s", name, self.targetType)
        end
        self.targetId = blackboard[targetIdKey]
        mq.Write.Trace("Initializing %s: targetId set to %s", name, self.targetId)
        self.targetStarted = false
        self.targetTimer = 0
    end

    function self._Update(blackboard)
        if mq.TLO.Target.ID() == self.targetId then
            mq.Write.Trace("%s: Target with ID %s is already targeted, returning Success", name, self.targetId)
            return NodeState.Success
        end

        if mq.IsValidTarget(self.targetId, self.targetType) then
            if self.targetStarted and self.targetTimer <= 500 then
                self.targetTimer = self.targetTimer + blackboard.deltaTime
                mq.Write.Trace("%s: Targeting in progress for ID %s, returning Running", name, self.targetId)
                return NodeState.Running
            else
                mq.TLO.Spawn(self.targetId).DoTarget()
                self.targetStarted = true
                self.targetTimer = 0
                mq.Write.Trace("%s: Starting to target ID %s, returning Running", name, self.targetId)
                return NodeState.Running
            end
        else
            mq.Write.Error("%s: Invalid target ID %s or type %s, returning Failure", name, self.targetId, self.targetType)
            return NodeState.Failure
        end
    end

    return self
end

return TargetNode