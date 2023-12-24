local rapidjson = require "rapidjson"
local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

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
local MoveToNode = {}

--- Constructor for MoveToNode.
---@param args MoveToNodeArgs @Table containing the arguments for the node.
---@return MoveToNode @The created MoveToNode instance.
function MoveToNode.new(args)
    mq.Write.Trace("%s: Creating MoveToNode", args.name)
    ---@class MoveToNode:Node
    local self = Node.new(args.name)
    self.NodeType = "MoveTo"
    local navString = "loc %f %f %f"
    local spawn = mq.TLO.Spawn
    ---@type character
    local me = mq.TLO.Me
    ---@type Coordinates
    self.Coordinates = {
        X = 0.0,
        Y = 0.0,
        Z = 0.0
    }
    -- ---@param spawn spawn
    -- ---@param arc Range
    -- ---@param distance Range
    -- ---@return boolean
    function FindCoordinatesToNav(distance)
        local point = mq.GetPointInArc(self.Spawn, self.Arc, distance)
        if not point then
            mq.Write.Error("%s: unable to find point in arc for spawn: %s, Arc: %s, Distance: %s", self.Name,
                self.Spawn.Name(), rapidjson.encode(self.Arc), rapidjson.encode(self.Distance))
            return false
        end
        self.Coordinates = point
        local count = 0
        local pathExists = PathExists()
        while not pathExists and count < 5 do
            count = count + 1
            point = mq.GetPointInArc(self.Spawn, self.Arc, self.Distance)
            if not point then
                mq.Write.Error("%s: unable to find point in arc for spawn: %s, Arc: %s, Distance: %s", self.Name,
                    self.Spawn.Name(), rapidjson.encode(self.Arc), rapidjson.encode(self.Distance))
                return false
            end
            self.Coordinates = point
            pathExists = PathExists()
        end
        return pathExists
    end

    function PathExists()
        return mq.TLO.Navigation.PathExists(string.format(navString, self.Coordinates.X, self.Coordinates.Y,
            self.Coordinates.Z))
    end

    function keyInBlackboard(key, blackboard)
        mq.Write.Trace("keyInBlackboard key: %s, blackboard:%s", key, rapidjson.encode(blackboard))
        local isThere = key and blackboard[key]
        return isThere
    end

    function InitalizeForSpawn(blackboard)
        mq.Write.Trace("%s: Initializing MoveToNode", self.Name)
        if not mq.IsValidTarget(blackboard[args.spawnIdKey], "any") then
            mq.Write.Error("%s: invalid spawn %s found in key %s", self.Name, blackboard[args.spawnIdKey],
                args.spawnIdKey)
            return NodeState.Invalid
        end
        ---@type spawn
        ---@diagnostic disable-next-line: assign-type-mismatch
        self.Spawn = spawn(blackboard[args.spawnIdKey])
        ---@type Coordinates
        self.SpawnCoordinates = { X = self.Spawn.X(), Y = self.Spawn.Y(), Z = self.Spawn.Z() }
        self.SpawnHeading = self.Spawn.Heading.DegreesCCW()
        self.Arc = mq.Positioning.Any
        if keyInBlackboard(args.positionKey, blackboard) then
            self.Arc = blackboard[args.positionKey]
        end
        local distance = math.random(self.Distance.Min, self.Distance.Max)
        self.DistanceSquared = distance * distance
        if FindCoordinatesToNav({ Min = distance, Max = distance }) then
            return NodeState.Success
        end
        return NodeState.Invalid
    end

    function HandleLocationBasedUpdate(blackboard)
        mq.Write.Trace("HandleLocationBasedUpdate")
        --Confirm we're still going to the same place, if not terminate

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
                return NodeState.Success
            end
        elseif PathExists() then
            mq.cmdf("/nav loc %f %f %f", self.Coordinates.Y, self.Coordinates.X, self.Coordinates.Z)
            return NodeState.Running
        else
            return NodeState.Failure
        end
    end

    function self._OnInitialize(blackboard)
        ---@type Range
        self.Distance = { Max = 10, Min = 10 }
        if keyInBlackboard(args.distanceKey, blackboard) then
            self.Distance.Min = blackboard[args.distanceKey].Min
            self.Distance.Max = blackboard[args.distanceKey].Max
            local distance = math.random(self.Distance.Min, self.Distance.Max)
            --set the distance we're actually aiming for
            self.DistanceSquared = distance * distance
        end



        if keyInBlackboard(args.spawnIdKey, blackboard) then
            return InitalizeForSpawn(blackboard)
        elseif keyInBlackboard(args.coordinatesKey, blackboard) then
            self.Coordinates.X = blackboard[args.coordinatesKey].X
            self.Coordinates.Y = blackboard[args.coordinatesKey].Y
            self.Coordinates.Z = blackboard[args.coordinatesKey].Z

            if not PathExists() then
                mq.Write.Error("%s: No path to coordinates %s", self.Name, rapidjson.encode(self.Coordinates))
                return NodeState.Invalid
            end
            return NodeState.Success
        else
            mq.Write.Error("%s: No coordinates or spawn provided args are %s", self.Name, rapidjson.encode(args))
            return NodeState.Invalid
        end
    end

    function HandleSpawnBasedUpdate(blackboard)

    end

    function self._Update(blackboard)
        if keyInBlackboard(args.spawnIdKey, blackboard) then
            --Make sure the spawn is the same spawn
            if self.Spawn.ID() ~= spawn(blackboard[args.spawnIdKey]).ID() then
                --The spawn is different, terminate
                mq.Write.Warn("Spawn changed while navigating")
                mq.cmd("/nav stop")
                return NodeState.Failure
            end
        else
            if self.Coordinates.X ~= blackboard[args.coordinatesKey].X or self.Coordinates.Y ~= blackboard[args.coordinatesKey].Y or self.Coordinates.Z ~= blackboard[args.coordinatesKey].Z then
                mq.Write.Warn("Coordinates changed while navigating")
                --stop the current navigation
                mq.cmd("/nav stop")
                return NodeState.Failure
            end

            --we'll let changes in the distance fly since that isn't going to fundementally change where we're going.
            if keyInBlackboard(args.distanceKey, blackboard) and (self.Distance.Min ~= blackboard[args.distanceKey].Min or self.Distance.Max ~= blackboard[args.distanceKey].Max) then
                self.Distance.Min = blackboard[args.distanceKey].Min
                self.Distance.Max = blackboard[args.distanceKey].Max
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
                mq.Write.Debug("%s: we are within range of the provided location %f %f", args.name, distance,
                    self.DistanceSquared)
                return NodeState.Success
            end
        elseif PathExists() then
            mq.Write.Debug("%s: we are NOT within range of the provided location %f %f", args.name, distance,
                self.DistanceSquared)
            mq.cmdf("/nav loc %f %f %f", self.Coordinates.Y, self.Coordinates.X, self.Coordinates.Z)
            return NodeState.Running
        else
            return NodeState.Failure
        end
    end

    return self
end

return MoveToNode
