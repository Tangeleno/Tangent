local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local SelectNode = require "libs.behavior.nodes.select"

---@class RandomSelector : SelectNode
---@field CurrentChildIndex integer @The index of the currently executing child.
local RandomSelector = {}
setmetatable(RandomSelector, { __index = SelectNode }) -- Inherit from Node

---Selects a random child to execute.
---@param args NodeArgs @Table containing the arguments for the node.
---@return RandomSelector @The created RandomSelector instance
function RandomSelector.new(args)
    ---@class RandomSelector : SelectNode
    local self = setmetatable(SelectNode.new(args), { __index = RandomSelector }) -- Set SitNode as its metatable
    self.NodeType = "RandomSelector"

    mq.Write.Trace("%s: Creating RandomSelector named '%s'", self.NodeType, args.name)

    return self
end

---@private
function RandomSelector:shuffleChildren()
    for i = #self.Children, 2, -1 do
        local j = math.random(i)
        self.Children[i], self.Children[j] = self.Children[j], self.Children[i]
    end
end

function RandomSelector:_OnInitialize(blackboard)
    mq.Write.Trace("%s: Initializing RandomSelector '%s'", self.NodeType, self.Name)
    self:shuffleChildren()
    self.CurrentChildIndex = 1
end

return RandomSelector
