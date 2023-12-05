local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

--- Creates a node that returns the first failed child or success if all children succeed.
---@class SequenceNode
local SequenceNode = {}

--- Constructor for SequenceNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Sequence node.
---@return SequenceNode @The created SequenceNode instance
function SequenceNode.new(args)
    ---@class SequenceNode:CompositeNode
    local self = CompositeNode.new(args.name)
    self.NodeType = "SequenceNode"
    self.CurrentChildIndex = 1
    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    function self._OnInitialize(blackboard)
        self.CurrentChildIndex = 1
    end

    ---@return NodeState
    function self._Update(blackboard)
        for i = self.CurrentChildIndex, #self.Children do
            self.CurrentChildIndex = i  -- Update CurrentChildIndex at the start of the loop
            local child = self.Children[i]
            local status = child.Tick(blackboard)

            if child.IsRunning() or child.IsFailure() then
                return status
            end
        end

        -- If all children are ticked and none are successful, return Success
        return NodeState.Success
    end

    return self
end

return SequenceNode
