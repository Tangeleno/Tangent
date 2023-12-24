local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local SelectNode = require "libs.behavior.nodes.select"


---@class RandomSelector : SelectNode
---@field CurrentChildIndex integer @The index of the currently executing child.

--- Creates a node that selects a random child to execute.
local RandomSelector = {}

--- Constructor for RandomSelector.
---@param args NodeArgs @Table containing the arguments for the node.
---@return RandomSelector @The created RandomSelector instance
function RandomSelector.new(args)
    ---@class RandomSelector : SelectNode
    local self = SelectNode.new(args)
    local baseUpdate = self._Update
    self.NodeType = "RandomSelector"

    mq.Write.Trace("%s: Creating RandomSelector named '%s'", self.NodeType, args.name)

    --- Shuffles the children nodes randomly.
    local function shuffleChildren()
        for i = #self.Children, 2, -1 do
            local j = math.random(i)
            self.Children[i], self.Children[j] = self.Children[j], self.Children[i]
        end
    end

    function self._OnInitialize(blackboard)
        mq.Write.Trace("%s: Initializing RandomSelector '%s'", self.NodeType, self.Name)
        shuffleChildren()
        self.CurrentChildIndex = 1
    end

    function self._Update(blackboard)
        -- Update logic specific to RandomSelector.
        -- Calls parent _Update which handles the execution of the currently selected child.
        return baseUpdate(blackboard)
    end

    return self
end

return RandomSelector
