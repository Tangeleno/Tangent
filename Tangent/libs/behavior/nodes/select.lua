local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local CompositeNode = require "libs.behavior.nodes.composite"

--- Creates a node that returns the first successful child or failure if all children fail.
---@class SelectNode
local SelectNode = {}

--- Constructor for SelectNode.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the Select node.
---@return SelectNode @The created SelectNode instance
function SelectNode.new(args)
    ---@class SelectNode:CompositeNode
    local self = CompositeNode.new(args.name)
    self.NodeType = "SelectNode"
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

            if child.IsRunning() or child.IsSuccess() then
                return status
            end
        end

        -- If all children are ticked and none are successful, return Failure
        return NodeState.Failure
    end

    return self
end

return SelectNode
