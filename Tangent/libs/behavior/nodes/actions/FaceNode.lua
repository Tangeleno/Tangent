local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class FaceNodeArgs : NodeArgs
---@field name string @Name of the Face node.
---@field faceIdKey string @Key to int value of the target we should face
---@field locationKey string @key to Coordinates (table with X,Y,Z properties)

---@class FaceNode:Node
---@field Args FaceNodeArgs
local FaceNode = {}
setmetatable(FaceNode, { __index = Node }) -- Inherit from Node

--- Constructor for Face.
---@param args FaceNodeArgs @Table containing the arguments for the node.
---@return FaceNode @The created Sit instance
function FaceNode.new(args)
    ---@class FaceNode:Node
    local self = setmetatable(Node.new(args), { __index = FaceNode }) -- Set FaceNode as its metatable
    self.NodeType = "Face"
    self.IsLocFace = false
    mq.Write.Trace("%s: Creating FaceNode", args.name)
    return self
end

function FaceNode:_OnInitialize(blackboard)
    mq.Write.Debug("%s: Initializing FaceNode", self.Name)
    if self.Args.faceIdKey and blackboard[self.Args.faceIdKey] then
        self.IsLocFace = false
    elseif self.Args.locationKey and blackboard[self.Args.locationKey] then
        self.IsLocFace = true
    end
end

function FaceNode:_Update(blackboard)
    if self.IsLocFace then
        ---@type Coordinates
        local loc = blackboard[self.Args.locationKey]
        mq.cmdf("/face fast loc %f,%f,%f", loc.Y, loc.X, loc.Z)
        if math.abs(mq.TLO.Me.HeadingToLoc(loc.Y, loc.X).DegreesCCW() - mq.TLO.Me.Heading.DegreesCCW()) > 5 then
            return NodeState.Running
        end
    else
        local spawn = mq.TLO.Spawn(blackboard[self.Args.faceIdKey])
        if not spawn then
            mq.Write.Warn("SpawnId %s is not valid", blackboard[self.Args.faceIdKey])
            return NodeState.Failure
        end
        mq.cmdf("/face fast id %s", blackboard[self.Args.faceIdKey])
        if math.abs(spawn.HeadingTo.DegreesCCW() - mq.TLO.Me.Heading.DegreesCCW()) > 5 then
            return NodeState.Running
        end
    end
    return NodeState.Success
end

return FaceNode
