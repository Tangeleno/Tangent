---@diagnostic disable: missing-return
---@class GroupMemberType : SpawnType
__GroupMemberType = {
    ---@return number
    ---Which number in the group the member is
    Index = function()end,
    ---@return boolean
    ---TRUE if the member is the group's leader, FALSE otherwise
    Leader = function()end,
    ---@return number
    ---The member's level
    Level = function()end,
    ---@return boolean
    ---TRUE if the member is designated as the group's Main Assist, FALSE otherwise
    MainAssist = function()end,
    ---@return boolean
    ---TRUE if the member is designated as the group's Main Tank, FALSE otherwise
    MainTank = function()end,
    ---@return boolean
    ---TRUE if the member is a mercenary, FALSE otherwise
    Mercenary = function()end,
    ---@return string
    ---The name of the group member. This works even if they are not in the same zone as you.
    Name = function()end,
    ---@return boolean
    ---TRUE if the member is offline and FALSE if online
    Offline = function()end,
    ---@return boolean
    ---TRUE if the member is online but in another zone and FALSE if online and in same zone as you.
    OtherZone = function()end,
    ---@return boolean
    ---TRUE if the member is online and in same zone and FALSE if online and not in same zone as you.
    Present = function()end,
    ---@return boolean
    ---TRUE if the member is designated as the group's Puller, FALSE otherwise
    Puller = function()end,
}