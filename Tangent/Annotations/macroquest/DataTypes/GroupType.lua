---@diagnostic disable: duplicate-index, missing-return
---@class GroupType
__GroupType = {
    ---@return boolean
    ---TRUE if someone is missing in group, offline, in other zone or simply just dead
    AnyoneMissing = function()end,
    ---@return number
    ---count of how many Caster DPS mercenaries are in your group
    CasterMercCount = function()end,
    ---@return string
    ---Will now return the cleric as a spawntype if a cleric is in the group (not a mercenary but a REAL cleric)
    Cleric = function()end,
    ---@return number
    ---Number of members in your group, including yourself
    GroupSize = function()end,
    ---@return number
    ---count of how many Healer mercenaries are in your group
    HealerMercCount = function()end,
    ---@return number
    ---Will return the numbers of people in the group that has a hp percent lower than pct
    Injured = function(pct)end,
    ---@return GroupMemberType
    ---Data on the leader of the group
    Leader = function()end,
    ---@return GroupMemberType
    ---Data on the main assist of the group
    MainAssist = function()end,
    ---@return GroupMemberType
    ---Data on the main tank of the group
    MainTank = function()end,
    ---@return GroupMemberType
    ---Data on the group member who can mark NPCs, if one is assigned
    MarkNpc = function()end,
    ---@return GroupMemberType
    ---Data on the Master Looter of the group, if one is assigned
    MasterLooter = function()end,
    ---@return number
    ---count of how many Melee DPS mercenaries are in your group
    MeleeMercCount = function()end,
    ---@return GroupMemberType
    ---Accesses the member of your group with the given name
    Member = function(name)end,
    ---@return GroupMemberType
    ---Accesses #th member of your group; 0 is you, 1 is the first person in the group list, etc.
    Member = function(index)end,
    ---@return number
    ---Total number of group members, excluding yourself
    Members = function()end,
    ---@return number
    ---Count of how many Mercenaries are in the group
    MercenaryCount = function()end,
    ---@return string
    ---Returns the name of the group member your mouse is hovering over
    MouseOver = function()end,
    ---@return boolean
    ---will return a TRUE if offline, and FALSE if online
    Offline = function()end,
    ---@return boolean
    ---will return a Bool TRUE if online but in another zone and FALSE if online and in same zone as you.
    OtherZone = function()end,
    ---@return GroupMemberType
    ---Data on the puller of the group
    Puller = function()end,
    ---@return number
    ---count of how many Tank mercenaries are in your group
    TankMercCount = function()end,
}