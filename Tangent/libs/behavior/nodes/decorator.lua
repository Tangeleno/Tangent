local Node = require "libs.behavior.nodes.node"
---@type DecoratorNode
local DecoratorNode = {}
---@param name string @Name of the decorator node
---@return DecoratorNode @The created DecoratorNode instance
function DecoratorNode.new(name)
    ---@class DecoratorNode:Node
    local self = Node.new(name)
    ---@type Node
    self.Child = nil
    function self.AddChild(node)
        self.Child = node
    end

    return self
end
return DecoratorNode