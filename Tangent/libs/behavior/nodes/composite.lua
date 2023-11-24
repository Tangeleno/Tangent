local Node = require "libs.behavior.nodes.node"
---@type CompositeNode
local CompositeNode = {}
---@param name string @Name of the composite node
---@return CompositeNode @The created CompositeNode instance
function CompositeNode.new(name)
    ---@class CompositeNode:Node
    local self = Node.new(name)
    ---@type Node[]
    self.Children = {}
    ---@param node Node
    function self.AddChild(node)
        table.insert(self.Children, node)
    end

    return self
end

return CompositeNode