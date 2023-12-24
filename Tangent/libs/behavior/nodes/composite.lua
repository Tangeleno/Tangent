local mq = require "libs.Helpers.MacroQuestHelpers"
local Node = require "libs.behavior.nodes.node"

---@class CompositeNode : Node
---@field Children Node[] @List of child nodes.
local CompositeNode = {}

--- Constructor for CompositeNode.
---@param args NodeArgs @Name of the composite node.
---@return CompositeNode @The created CompositeNode instance.
function CompositeNode.new(args)
    ---@class CompositeNode : Node
    local self = Node.new(args)
    self.NodeType = "CompositeNode"  -- Specify the type of the node.
    self.Children = {}  -- Initialize an empty table for children.

    --- Adds a child node to the composite node.
    ---@param node Node @The child node to add.
    function self.AddChild(node)
        mq.Write.Trace("%s: Adding child node '%s'", self.Name, node.Name)
        table.insert(self.Children, node)
    end

    --- Called when the node is terminated.
    ---@param blackboard table @The blackboard data.
    function self._OnTerminate(blackboard)
        mq.Write.Trace("%s: Terminating CompositeNode and its children", self.Name)
        -- Clean up children nodes; all nodes need to be terminated.
        for _, child in ipairs(self.Children) do
            if not child.IsTerminated() then
                child.Abort()
                mq.Write.Trace("%s: Terminating child node '%s'", self.Name, child.Name)
            end
        end
    end

    return self
end

return CompositeNode
