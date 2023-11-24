---@diagnostic disable: duplicate-index, missing-return
---@class FellowshipType
__FellowShipType = {
    ---@return boolean
    ---TRUE if campfire is up, FALSE if not
    Campfire = function()end,
    ---@return TicksType
    ---Time left on current campfire
    CampfireDuration = function()end,
    ---@return number
    ---Campfire X location
    CampfireX = function()end,
    ---@return number
    ---Campfire Y location
    CampfireY = function()end,
    ---@return number
    ---Campfire Z location
    CampfireZ = function()end,
    ---@return ZoneType
    ---Zone information for the zone that contains your campfire
    CampfireZone = function()end,
    ---@return number
    ---Fellowship ID
    ID = function()end,
    ---@return string
    ---Fellowship leader's name
    Leader = function()end,
    ---@return FellowshipMemberType
    ---Member data by name or #
    Member = function(name)end,
    ---@return FellowshipMemberType
    ---Member data by name or #
    Member = function(index)end,
    ---@return number
    ---Number of members in the fellowship
    Members = function()end,
    ---@return string
    ---Fellowship Message of the Day
    MotD = function()end,
}