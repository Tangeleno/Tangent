local rapidjson = require "rapidjson"
local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
---@type character
---@diagnostic disable-next-line: assign-type-mismatch
local me = mq.TLO.Me
local navString = "loc %f %f %f"
local spawn = mq.TLO.Spawn
local function keyInBlackboard(key, blackboard)
    return key and blackboard[key]
end

---@class MoveToNodeArgs : NodeArgs
---@field name string @Name of the node.
---@field spawnIdKey string @Key to extract the spawn ID from the blackboard.
---@field coordinatesKey string @Key to extract the coordinates from the blackboard.
---@field positionKey string @Key to extract the position range from the blackboard.
---@field distanceKey string @Key to extract the distance range from the blackboard.

---@class MoveToNode : Node
---@field Coordinates Coordinates @Target coordinates to move to.
---@field Spawn spawn @Spawn to move towards if specified.
---@field Arc Range @Arc range for positioning relative to the spawn.
---@field Distance Range @Distance range to the target location.
---@field Args MoveToNodeArgs
local MoveToNode = {}
setmetatable(MoveToNode, { __index = Node }) -- Inherit from Node

--- Constructor for MoveToNode.
---@param args MoveToNodeArgs @Table containing the arguments for the node.
---@return MoveToNode @The created MoveToNode instance.
function MoveToNode.new(args)
    mq.Write.Trace("%s: Creating MoveToNode", args.name)
    ---@class MoveToNode:Node
    local self = setmetatable(Node.new(args), { __index = MoveToNode }) -- Set MoveToNode as its metatable
    self.NodeType = "MoveTo"

    ---@type Coordinates
    self.Coordinates = {
        X = 0.0,
        Y = 0.0,
        Z = 0.0
    }

    return self
end

function MoveToNode:FindCoordinatesToNav(distance)
    local point = mq.GetPointInArc(self.Spawn, self.Arc, distance)
    if not point then
        mq.Write.Error("%s: unable to find point in arc for spawn: %s, Arc: %s, Distance: %s", self.Name,
            self.Spawn.Name(), rapidjson.encode(self.Arc), rapidjson.encode(self.Distance))
        return false
    end
    self.Coordinates = point
    local count = 0
    local pathExists = self:PathExists()
    while not pathExists and count < 5 do
        count = count + 1
        point = mq.GetPointInArc(self.Spawn, self.Arc, self.Distance)
        if not point then
            mq.Write.Error("%s: unable to find point in arc for spawn: %s, Arc: %s, Distance: %s", self.Name,
                self.Spawn.Name(), rapidjson.encode(self.Arc), rapidjson.encode(self.Distance))
            return false
        end
        self.Coordinates = point
        pathExists = self:PathExists()
    end
    return pathExists
end

function MoveToNode:PathExists()
    return mq.TLO.Navigation.PathExists(string.format(navString, self.Coordinates.X, self.Coordinates.Y,
        self.Coordinates.Z))
end

function MoveToNode:InitalizeForSpawn(blackboard)
    mq.Write.Trace("%s: Initializing MoveToNode", self.Name)
    if not mq.IsValidTarget(blackboard[self.Args.spawnIdKey], "any") then
        mq.Write.Error("%s: invalid spawn %s found in key %s", self.Name, blackboard[self.Args.spawnIdKey],
        self.Args.spawnIdKey)
        return NodeState.Invalid
    end
    ---@type spawn
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.Spawn = spawn(blackboard[self.Args.spawnIdKey])
    ---@type Coordinates
    self.SpawnCoordinates = { X = self.Spawn.X(), Y = self.Spawn.Y(), Z = self.Spawn.Z() }
    self.SpawnHeading = self.Spawn.Heading.DegreesCCW()
    self.Arc = mq.Positioning.Any
    if keyInBlackboard(self.Args.positionKey, blackboard) then
        self.Arc = blackboard[self.Args.positionKey]
    end
    local distance = math.random(self.Distance.Min, self.Distance.Max)
    self.DistanceSquared = distance * distance
    if self:FindCoordinatesToNav({ Min = distance, Max = distance }) then
        return NodeState.Success
    end
    return NodeState.Invalid
end

function MoveToNode:_OnInitialize(blackboard)
    --Set the nav options to move us to our exact loc
    mq.cmd("/nav setopt distance=1")
    ---@type Range
    self.Distance = { Max = 10, Min = 10 }
    if keyInBlackboard(self.Args.distanceKey, blackboard) then
        self.Distance.Min = blackboard[self.Args.distanceKey].Min
        self.Distance.Max = blackboard[self.Args.distanceKey].Max
        local distance = math.random(self.Distance.Min, self.Distance.Max)
        --set the distance we're actually aiming for
        self.DistanceSquared = distance * distance
    end

    if keyInBlackboard(self.Args.spawnIdKey, blackboard) then
        return self:InitalizeForSpawn(blackboard)
    elseif keyInBlackboard(self.Args.coordinatesKey, blackboard) then
        self.Coordinates.X = blackboard[self.Args.coordinatesKey].X
        self.Coordinates.Y = blackboard[self.Args.coordinatesKey].Y
        self.Coordinates.Z = blackboard[self.Args.coordinatesKey].Z

        if not self:PathExists() then
            mq.Write.Error("%s: No path to coordinates %s", self.Name, rapidjson.encode(self.Coordinates))
            return NodeState.Invalid
        end
        return NodeState.Success
    else
        mq.Write.Error("%s: No coordinates or spawn provided args are %s", self.Name, rapidjson.encode(self.Args))
        return NodeState.Invalid
    end
end

function MoveToNode:_OnTerminate(blackboard)
    mq.cmd("/nav setopt reset")
end


function MoveToNode:_Update(blackboard)
    if keyInBlackboard(self.Args.spawnIdKey, blackboard) then
        --Make sure the spawn is the same spawn
        if self.Spawn.ID() ~= spawn(blackboard[self.Args.spawnIdKey]).ID() then
            --The spawn is different, terminate
            mq.Write.Warn("Spawn changed while navigating")
            mq.cmd("/nav stop")
            return NodeState.Failure
        end
    else
        if self.Coordinates.X ~= blackboard[self.Args.coordinatesKey].X or self.Coordinates.Y ~= blackboard[self.Args.coordinatesKey].Y or self.Coordinates.Z ~= blackboard[self.Args.coordinatesKey].Z then
            mq.Write.Warn("Coordinates changed while navigating")
            --stop the current navigation
            mq.cmd("/nav stop")
            return NodeState.Failure
        end

        --we'll let changes in the distance fly since that isn't going to fundementally change where we're going.
        if keyInBlackboard(self.Args.distanceKey, blackboard) and (self.Distance.Min ~= blackboard[self.Args.distanceKey].Min or self.Distance.Max ~= blackboard[self.Args.distanceKey].Max) then
            self.Distance.Min = blackboard[self.Args.distanceKey].Min
            self.Distance.Max = blackboard[self.Args.distanceKey].Max
            local distance = math.random(self.Distance.Min, self.Distance.Max)
            self.DistanceSquared = distance * distance
        end
    end
    local distance = math.DistanceSquared(self.Coordinates, me)
    local withinRange = distance <= self.DistanceSquared

    --if we're navigating and not at our determined distance return running
    if mq.TLO.Navigation.Active() and not withinRange then
        return NodeState.Running
    end

    --if we're with in distance return success
    if withinRange then
        if mq.TLO.Navigation.Active() then
            mq.cmd("/nav stop")
            return NodeState.Running
        else
            mq.Write.Debug("%s: we are within range of the provided location %f %f", self.Args.name, distance,
                self.DistanceSquared)
            return NodeState.Success
        end
    elseif self:PathExists() then
        mq.Write.Debug("%s: we are NOT within range of the provided location %f %f", self.Args.name, distance,
            self.DistanceSquared)
        mq.cmdf("/nav loc %f %f %f", self.Coordinates.Y, self.Coordinates.X, self.Coordinates.Z)
        return NodeState.Running
    else
        return NodeState.Failure
    end
end

return MoveToNode
