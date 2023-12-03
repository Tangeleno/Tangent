local mq = require "libs.Helpers.MacroQuestHelpers"
local Node = require "libs.behavior.nodes.node"
---@class DecoratorNode
local DecoratorNode = {}
---@param name string @Name of the decorator node
---@return DecoratorNode @The created DecoratorNode instance
function DecoratorNode.new(name)
    ---@class DecoratorNode:Node
    local self = Node.new(name)
    ---@type Node
    self.Child = nil
    function self.AddChild(node)
        mq.Write.Trace("%s '%s': Added child node '%s'", self.NodeType, self.Name, node.Name)
        self.Child = node
    end

    function self._OnTerminate(blackboard)
        --Clean up children nodes, all nodes need terminated
        if (not self.Child.IsTerminated()) then
            self.Child.Abort()
        end
    end

    return self
end

return DecoratorNode
