---@diagnostic disable: missing-return
---@class EvolvingType
__EvolvingType = {
    ---@return number
    ---Percentage of experience that the item has gained
    ExpPct = function()end,
    ---@return boolean
    ---Is evolving item experience turned on for this item?
    ExpOn = function()end,
    ---@return number
    ---The level of the evolving item.
    Level = function()end,
    ---@return number
    ---The maximum level of the evolving item
    MaxLevel = function()end,
}