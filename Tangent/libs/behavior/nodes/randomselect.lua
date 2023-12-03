local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local SelectNode = require "libs.behavior.nodes.select"
---@class RandomSelector
local RandomSelector = {}
---@param name string @Name of the RandomSelector node.
function RandomSelector.new(name)
    ---@class RandomSelector:SelectNode
    local self = SelectNode.new(name)
    self.NodeType = "RandomSelector"

    mq.Write.Trace("Creating %s: %s", self.NodeType, self.Name)
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