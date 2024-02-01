local mq = require "libs.Helpers.MacroQuestHelpers"
local Node = require "libs.behavior.nodes.node"

---@class DecoratorNode : Node
---@field Child Node @The child node that this decorator will manage.
local DecoratorNode = {}
setmetatable(DecoratorNode, { __index = Node }) -- Inherit from Node

--- Constructor for DecoratorNode.
---@param args NodeArgs @Table containing the arguments for the node.
---@return DecoratorNode @The created DecoratorNode instance
function DecoratorNode.new(args)
    ---@class DecoratorNode : Node
    local self = setmetatable(Node.new(args), { __index = DecoratorNode }) -- Set SitNode as its metatable
    self.NodeType = "DecoratorNode"
    mq.Write.Trace("%s: Creating DecoratorNode named '%s'", self.NodeType, args.name)

    ---@type Node
    self.Child = nil

    return self
end

--- Adds a child node to the decorator.
---@param node Node @The child node to be added.
function DecoratorNode:AddChild(node)
    if self.Child then
        mq.Write.Warn("%s '%s': Already has a child node. Replacing existing child '%s' with new child '%s'",
            self.NodeType, self.Name, self.Child.Name, node.Name)
    else
        mq.Write.Trace("%s '%s': Added child node '%s'", self.NodeType, self.Name, node.Name)
    end
    self.Child = node
end

--- Cleanup function called when the node is terminated.
---@param blackboard table @The blackboard being used by the behavior tree.
function DecoratorNode:_OnTerminate(blackboard)
    mq.Write.Trace("%s '%s': Terminating and cleaning up child node", self.NodeType, self.Name)
    -- Clean up the child node, if it hasn't been terminated yet.
    if self.Child and (not self.Child:IsTerminated()) then
        self.Child:Abort(blackboard)
    end
end

return DecoratorNode
