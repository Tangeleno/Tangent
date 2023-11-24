---@diagnostic disable: duplicate-index, missing-return
---@class DynamicZoneType
__DynamicZoneType = {
    ---@return DZMemberType
    ---The leader of the dynamic zone
    Leader = function()end,
    ---@return boolean
    ---Returns true if the dzleader can successfully enter the dz (this also means the dz is actually Loaded.) Example: ${DynamicZone.LeaderFlagged}
    LeaderFlagged = function()end,
    ---@return number
    ---Maximum number of characters that can enter this dynamic zone
    MaxMembers = function()end,
    ---@return DZMemberType
    ---The dynamic zone member
    Member = function(name)end,
    ---@return DZMemberType
    ---The dynamic zone member
    Member = function(index)end,
    ---@return number
    ---Current number of characters in the dynamic zone
    Members = function()end,
    ---@return string
    ---The full name of the dynamic zone
    Name = function()end,
}