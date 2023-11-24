---@diagnostic disable: missing-return
---@class RaidMemberType : SpawnType
__RaidMemberType = {
    ---@return ClassType
    ---Raid member's class (works without being in zone)
    Class = function()end,
    ---@return number
    ---Current group number (or 0)
    Group = function()end,
    ---@return boolean
    ---Returns TRUE if the member is a group leader
    GroupLeader = function()end,
    ---@return number
    ---Raid member's level (works without being in zone)
    Level = function()end,
    ---@return boolean
    ---Allowed to loot with current loot rules and looters?
    Looter = function()end,
    ---@return string
    ---Raid member's name
    Name = function()end,
    ---@return boolean
    ---Returns TRUE if the member is the raid leader
    RaidLeader = function()end,
    ---@return SpawnType
    ---Spawn object for this player if available (must be in zone)
    Spawn = function()end,
}