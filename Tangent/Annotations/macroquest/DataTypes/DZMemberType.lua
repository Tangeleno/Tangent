---@diagnostic disable: missing-return
---@class DZMemberType
__DZMemberType = {
    ---@return boolean
    ---Returns true if the dzmember can successfully enter the dz. Example:${DynamicZone.Member[x].Flagged} where x is either index or the name.
    Flagged = function()end,
    ---@return string
    ---The name of the member
    Name = function()end,
    ---@return string
    ---The status of the member - one of the following: Unknown, Online, Offline, In Dynamic Zone, Link Dead
    Status = function()end,
}