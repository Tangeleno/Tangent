---@diagnostic disable: missing-return
---@class TicksType
__TicksType = {
    ---@return number
    ---The number of hours in HH:MM:SS (0-23)
    Hours = function()end,
    ---@return number
    ---The number of minutes in HH:MM:SS (1-59)
    Minutes = function()end,
    ---@return number
    ---The number of seconds in HH:MM:SS (1-59)
    Seconds = function()end,
    ---@return number
    ---The total number of minutes
    TotalMinutes = function()end,
    ---@return number
    ---The total number of seconds
    TotalSeconds = function()end,
    ---@return number
    ---The value in ticks
    Ticks = function()end,
    ---@return string
    ---Time in the form MM:SS
    Time = function()end,
    ---@return string
    ---Time in the form HH:MM:SS (if there are no hours, the form will be MM:SS)
    TimeHMS = function()end,
}