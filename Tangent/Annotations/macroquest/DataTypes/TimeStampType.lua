---@diagnostic disable: missing-return
---@class TimeStampType
__TimeStampType = {
    ---@return number
    ---Number of hours in the timestamp (1hr 23min 53 seconds will return 1)
    Hours = function()end,
    ---@return number
    ---Number of Minutes in the timestamp (1hr 23min 53 seconds will return 23)
    Minutes = function()end,
    ---@return number
    ---Number of Seconds in the timestamp (1hr 23min 53 seconds will return 53)
    Seconds = function()end,
    ---@return string
    ---Time value formatted in H:M:S
    TimeHMS = function()end,
    ---@return string
    ---Time value formatted in M:S
    Time = function()end,
    ---@return number
    ---Total number of minutes in the timestamp (1hr 23min 53 seconds will return 83)
    TotalMinutes = function()end,
    ---@return number
    ---Total number of minutes in the timestamp (1hr 23min 53 seconds will return 5033)
    TotalSeconds = function()end,
    ---@return number
    ---Time value represented in milliseconds
    Raw = function()end,
    ---@return number
    ---timestamp represented in seconds (1hr 23 min 53 seconds will return 5033.00)
    Float = function()end,
    ---@return number
    ---Time value represented in ticks
    Ticks = function()end,
}