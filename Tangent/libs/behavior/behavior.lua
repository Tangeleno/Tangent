local mq = require "libs.Helpers.MacroQuestHelpers"
local Node = require "libs.behavior.nodes.node"
local SelectNode = require "libs.behavior.nodes.select"
local SequenceNode = require "libs.behavior.nodes.sequence"
local ParallelNode = require "libs.behavior.nodes.parallel"
local RandomSelector = require "libs.behavior.nodes.randomselect"
local InvertNode = require "libs.behavior.nodes.invert"
local RepeatNode = require "libs.behavior.nodes.repeat"
local RetryNode = require "libs.behavior.nodes.retry"
local LoopNode = require "libs.behavior.nodes.loop"
local SucceederNode = require "libs.behavior.nodes.succeeder"
local FailerNode = require "libs.behavior.nodes.failer"
local WaitNode = require "libs.behavior.nodes.wait"
local ConditionNode = require "libs.behavior.nodes.condition"
local lfs = require "lfs"

local originalPackagePath = package.path

--We are lazy and don't want to continue maintaining this stupid file.
--Most node types are pretty static but the action nodes will likely grow.
--Condition nodes would as well, but we don't have separate nodes for each of those anyways.
--Action nodes are special because they need to maintain some state before returning success
local actionPath = "libs.behavior.nodes.actions"
actionPath = mq.luaDir .. "/" .. actionPath:gsub("%.", "/") -- Convert to slash notation
package.path = package.path .. ";" .. actionPath .. "/?.lua"

-- Load your nodes
local nodes = {
    Node = Node,
    SelectNode = SelectNode,
    SequenceNode = SequenceNode,
    ParallelNode = ParallelNode,
    RandomSelector = RandomSelector,
    InvertNode = InvertNode,
    RepeatNode = RepeatNode,
    RetryNode = RetryNode,
    LoopNode = LoopNode,
    ConditionNode = ConditionNode,
    SucceederNode = SucceederNode,
    FailerNode = FailerNode,
    WaitNode = WaitNode
}
for file in lfs.dir(actionPath) do
    if file:match("^.+(%..+)$") == ".lua" then
        local moduleName = file:gsub("%.lua$", "")
        nodes[moduleName] = require(moduleName)
    end
end

-- Restore the original package.path
package.path = originalPackagePath

return nodes
