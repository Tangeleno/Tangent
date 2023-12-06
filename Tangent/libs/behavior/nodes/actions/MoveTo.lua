local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class MoveToNodeArgs:NodeArgs
---@field spawnIdKey string @Key to extract the spawn id from the blackboard either coordinatesKey or spawnIdKey are required
---@field coordinatesKey string @Key to extract the Coordinates from the blackboard either coordinatesKey or spawnIdKey are required
---@field positionKey string @Key to extract the Range representing the degrees of the arc (see mq.Positioning)
---@field distanceKey string @Key to extra the Range representing the minimum and maximum distance from the destination

---@class MoveToNodeNode
local MoveToNode = {}

--- Constructor for MoveToNode.
---@param args MoveToNodeArgs @Table containing the arguments for the node.
---   - name: string @Name of the SitAction node.
---   - coordinatesKey: string @A key to a blackboard table containing x,y,z coordinates either positionKey or spawnIdKey are required
---   - spawnIdKey: string @A key to a blackboard value containing a spawn Id to move to either positionKey or spawnIdKey are required
---   - positionKey: string @A key to a blackboard value containing a Range {Min,Max} in degrees for where to position in relation to the spawn. Only used if spawnIdKey is provided default 0,359
---   - distanceKey: string @A key to a blackboard value containing a Range {Min,Max} distance values. used to determine when the point is reached. default 5,15
---@return MoveToNode @The created MoveToNode instance
function MoveToNode.new(args)
    ---@class MoveToNode:Node
    local self = Node.new(args.name)
    local navString = "loc %f %f %f"
    local spawn = mq.TLO.Spawn
    self.X = nil
    self.Y = nil
    self.Z = nil

    ---@param spawn spawn
    ---@param arc Range
    ---@param distance Range
    ---@return boolean
    function findCoordinatesToNav(spawn, arc, distance)
        local pathAttemptCount = 0
        self.X, self.Y = mq.GetPointInArc(spawn, arc, distance)
        self.Z = spawn.Z
        while not mq.TLO.Navigation.PathExists(string.format(navString, self.X, self.Y, spawn.Z)) do
            if pathAttemptCount <= 5 then
                --Try 5 times to get a path with the arc provided 5 times
                self.X, self.Y = mq.GetPointInArc(spawn, arc, distance)
            else
                --Try 5 times with a 0-359 arc
                self.X, self.Y = mq.GetPointInArc(spawn, mq.Positioning.Any, distance)
            end
            pathAttemptCount = pathAttemptCount + 1
            if pathAttemptCount > 10 then
                return false
            end
        end
        return true
    end

    function self._OnInitialize(blackboard)
        if args.spawnIdKey and blackboard[args.spawnIdKey] and mq.IsValidTarget(blackboard[args.spawnIdKey], "any") then
            --we are going to use the spawn as our source
            local arc = mq.Positioning.Any
            local distance = { Min = 5, Max = 15 }
            if args.positionKey and blackboard[args.positionKey] then
                arc = blackboard[args.positionKey]
            end
            if args.distanceKey and blackboard[args.distanceKey] then
                distance = blackboard[args.positionKey]
            end
            ---@type spawn
            ---@diagnostic disable-next-line: assign-type-mismatch
            local theSpawn = spawn(blackboard[args.spawnIdKey])
            if not theSpawn then
                mq.Write.Error("Error: unable to retreive spawn %s from mq", blackboard[args.spawnIdKey])
                return NodeState.Invalid
            end
            if not findCoordinatesToNav(theSpawn, arc, distance) then
                mq.Write.Error("Error: unable to find a path to spawn %s ", theSpawn.Name())
                return NodeState.Invalid
            end
        end
    end

    function self._Update(blackboard)
        --if the spawn has moved from it's original position too much, recalculate the destination
    end

    return self
end

return MoveToNode
