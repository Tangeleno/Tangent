---@diagnostic disable: missing-return
---@class SwitchType
__SwitchType = {
    ---@return HeadingType
    ---Heading of "closed" switch
    DefaultHeading = function()end,
    ---@return number
    ---Distance from player to switch in (x,y)
    Distance = function()end,
    ---@return HeadingType
    ---Switch is facing this heading
    Heading = function()end,
    ---@return HeadingType
    ---Direction player must move to meet this switch
    HeadingTo = function()end,
    ---@return number
    ---Switch ID
    ID = function()end,
    ---@return boolean
    ---Returns TRUE if the switch is in LoS
    LineOfSight = function()end,
    ---@return string
    ---Name
    Name = function()end,
    ---@return boolean
    ---Open?
    Open = function()end,
    ---@return number
    ---X coordinate
    X = function()end,
    ---@return number
    ---Y coordinate
    Y = function()end,
    ---@return number
    ---Z coordinate
    Z = function()end,
    ---@return number
    ---X coordinate (Westward-positive)
    W = function()end,
    ---@return number
    ---Y coordinate (Northward-positive)
    N = function()end,
    ---@return number
    ---D coordinate (Upward-positive)
    D = function()end,
    ---@return number
    ---X coordinate of "closed" switch
    DefaultX = function()end,
    ---@return number
    ---Y coordinate of "closed" switch
    DefaultY = function()end,
    ---@return number
    ---Z coordinate of "closed" switch
    DefaultZ = function()end,
    ---@return number
    ---X coordinate of "closed" switch (Westward-positive)
    DefaultW = function()end,
    ---@return number
    ---Y coordinate of "closed" switch (Northward-positive)
    DefaultN = function()end,
    ---@return number
    ---Z coordinate of "closed" switch (Upward-positive)
    DefaultU = function()end,
}