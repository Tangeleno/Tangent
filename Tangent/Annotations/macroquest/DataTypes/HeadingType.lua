---@diagnostic disable: missing-return
---@class HeadingType
__HeadingType = {
    ---@return number
    ---The nearest clock direction, e.g. 1-12
    Clock = function()end,
    ---@return number
    ---Heading in degrees (same as casting to float)
    Degrees = function()end,
    ---@return number
    ---Heading in degrees counter-clockwise (the way the rest of MQ2 and EQ uses it)
    DegreesCCW = function()end,
    ---@return string
    ---The long compass direction, eg. "south", "south by southeast"
    Name = function()end,
    ---@return string
    ---The short compass direction, eg. "S", "SSE"
    ShortName = function()end,
}