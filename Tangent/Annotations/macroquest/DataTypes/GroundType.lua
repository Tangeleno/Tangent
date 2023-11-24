---@diagnostic disable: missing-return
---@class GroundType
__GroundType = {
    ---@return number
    ---Ground item ID (not the same as item ID, this is like spawn ID)
    ID = function()end,
    ---@return number
    ---Distance from player to ground item
    Distance = function()end,
    ---@return number
    ---X coordinate
    X = function()end,
    ---@return number
    ---Y coordinate
    Y = function()end,
    ---@return number
    ---Z coordinate
    Z = function()end,
    ---@return HeadingType
    ---Ground item is facing this heading
    Heading = function()end,
    ---@return string
    ---Name
    Name = function()end,
    ---@return HeadingType
    ---Direction player must move to meet this ground item
    HeadingTo = function()end,
    ---@return boolean
    ---Returns TRUE if ground spawn is in line of sight
    LineOfSight = function()end,
    ---@return number
    Address = function()end,
    ---@return number
    ---Displays name of the grounspawn
    DisplayName = function()end,
    ---@return number
    ---Distance from player to ground item
    Distance3D = function()end,
    ---@return number
    SubID = function()end,
    ---@return number
    ZoneID = function()end,
    ---First spawn
    First = function()end,
    ---Last spawn
    Last = function()end,
    ---Next spawn
    Next = function()end,
    ---Prev spawn
    Prev = function()end,
    ---Will cause the toon to face the called for spawn if it exists
    DoFace = function()end,
    ---Will cause the toon to target the called for spawn if it exists
    DoTarget = function()end,
    ---Picks up the ground spawn
    Grab = function()end,
    ---@return number
    ---X coordinate (Westward-positive)
    W = function()end,
    ---@return number
    ---Y coordinate (Northward-positive)
    N = function()end,
    ---@return number
    ---Z coordinate (Upward-positive)
    U = function()end,
    ---@return GroundType
    ---@param search integer|string
    Search = function(search)end
}