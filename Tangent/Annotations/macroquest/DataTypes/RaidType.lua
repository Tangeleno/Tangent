---@diagnostic disable: duplicate-index, missing-return
---@class RaidType
__RaidType = {
    ---@return number
    ---Average level of raid members (more accurate than in the window)
    AverageLevel = function()end,
    ---@return boolean
    ---Have I been invited to the raid?
    Invited = function()end,
    ---@return RaidMemberType
    ---Raid leader
    Leader = function()end,
    ---@return boolean
    ---Returns TRUE if the raid is locked
    Locked = function()end,
    ---@return string
    ---Specified looter name by number
    ---@param index number
    Looter = function(index)end,
    ---@return number
    ---Number of specified looters
    Looters = function()end,
    ---@return number
    ---Loot type number: 1 Leader 2 Leader & GroupLeader 3 Leader & Specified
    LootType = function()end,
    ---@return RaidMemberType
    ---Raid main assist
    MainAssist = function()end,
    ---@return RaidMemberType
    ---Raid Master Looter
    MasterLooter = function()end,
    ---@return RaidMemberType
    ---Raid member by number
    ---@param index number
    Member = function(index)end,
    ---@return RaidMemberType
    ---Raid member by name
    ---@param name string
    Member = function(name)end,
    ---@return number
    ---Total number of raid members
    Members = function()end,
    ---@return RaidMemberType
    ---Raid target (clicked in raid window)
    Target = function()end,
    ---@return number
    ---Sum of all raid members' levels
    TotalLevels = function()end,
}