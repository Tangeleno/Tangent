local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class SitNode
local SitNode = {}

--- Constructor for Sit.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the SitAction node.
---   - maxSitAttempts: number @The number of attempts that should be made before returning failure.
---@return SitNode @The created Sit instance
function SitNode.new(args)
    ---@class SitNode:Node
    local self = Node.new(args.name)
    args.maxSitAttempts = 10
    self.NodeType = "Sit"
    self.sitStarted = false
    self.sitTimer = 0
    self.sitAttempts = 0

    function self._OnInitialize(blackboard)
        self.sitStarted = false
        self.sitTimer = 0
        self.sitAttempts = 0
    end

    function self._Update(blackboard)
        if mq.TLO.Me.Sitting() then
            return NodeState.Success
        elseif mq.TLO.Me.Standing() then
            if self.sitAttempts >= args.maxSitAttempts then
                return NodeState.Failure
            end
            if self.sitStarted and self.sitTimer <= 500 then
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
        return NodeState.Failure
    end

    return self
end

return SitNode
