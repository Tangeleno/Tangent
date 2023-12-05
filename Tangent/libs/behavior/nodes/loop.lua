local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local DecoratorNode = require "libs.behavior.nodes.decorator"
local Conditions = require "libs.behavior.conditions"

---@class LoopNode
local LoopNode = {}

--- Constructor for LoopNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Loop node.
---   - loopCount: number @Number of times to execute the child node.
---   - conditionKey: string @A key that references a condition function in the conditions table. This function should return a boolean. If false, the loop will terminate early (optional).
---@return LoopNode @The created LoopNode instance
function LoopNode.new(args)
    ---@class LoopNode:DecoratorNode
    local self = DecoratorNode.new(args.name)
    self.NodeType = "LoopNode"
    self.LoopCount = args.loopCount or 1
    self.CurrentLoop = 0
    self.ConditionKey = args.conditionKey
    local conditionFunc = Conditions[args.conditionKey]
    mq.Write.Trace("Creating %s: %s, with loop count: %d", self.NodeType, self.Name, self.LoopCount)

    function self._OnInitialize(blackboard)
        self.CurrentLoop = 0
    end

    function self._Update(blackboard)
        if self.ConditionKey and conditionFunc and not conditionFunc(blackboard) then
            mq.Write.Trace("%s: %s condition failed, terminating loop early", self.NodeType, self.Name)
            return NodeState.Failure
        end

        local status = self.Child.Tick(blackboard)
        if status == NodeState.Success then
            self.CurrentLoop = self.CurrentLoop + 1
            mq.Write.Trace("%s %s iteration %d/%d completed", self.NodeType, self.Name, self.CurrentLoop, self.LoopCount)
            if self.CurrentLoop < self.LoopCount then
                return NodeState.Running
            else
                mq.Write.Trace("%s %s completed all iterations successfully", self.NodeType, self.Name)
                return NodeState.Success
            end
        end
        return status
    end

    return self
end

return LoopNode
