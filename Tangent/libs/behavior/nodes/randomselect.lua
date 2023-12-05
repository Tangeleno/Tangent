local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local SelectNode = require "libs.behavior.nodes.select"

--- Creates a node that selects a random child to execute.
---@class RandomSelector
local RandomSelector = {}

--- Constructor for RandomSelector.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the RandomSelector node.
---@return RandomSelector @The created RandomSelector instance
function RandomSelector.new(args)
    ---@class RandomSelector:SelectNode
    local self = SelectNode.new(args.name)
    self.NodeType = "RandomSelector"

    mq.Write.Trace("Creating %s: %s", self.NodeType, args.name)

    function self._OnInitialize(blackboard)
        -- Randomly shuffle the children
        local shuffled = {}
        for i, v in ipairs(self.Children) do
            local pos = math.random(1, i)
            table.insert(shuffled, pos, v)
        end
        self.Children = shuffled
        self.CurrentChildIndex = 1
    end

    return self
end

return RandomSelector
