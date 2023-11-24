---@diagnostic disable: missing-return
---@class TimeType
__TimeType = {
    ---@return string
    ---Date in the format MM/DD/YYYY
    Date = function()end,
    ---@return number
    ---Day of the month
    Day = function()end,
    ---@return number
    ---Day of the week (1=sunday to 7=saturday)
    DayOfWeek = function()end,
    ---@return number
    ---Hour (0-23)
    Hour = function()end,
    ---@return number
    ---Minute (0-59)
    Minute = function()end,
    ---@return number
    ---Month of the year (1-12)
    Month = function()end,
    ---@return boolean
    ---Gives true if the current hour is considered "night" in EQ (7:00pm-6:59am)
    Night = function()end,
    ---@return number
    ---Second (0-59)
    Second = function()end,
    ---@return number
    ---Number of seconds since midnight
    SecondsSinceMidnight = function()end,
    ---@return string
    ---Time in 12-hour format (HH:MM:SS)
    Time12 = function()end,
    ---@return string
    ---Time in 24-hour format (HH:MM:SS)
    Time24 = function()end,
    ---@return number
    ---Year
    Year = function()end,
    TimeStamp = __TimeStampType
}