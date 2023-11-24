---@diagnostic disable: missing-return
---@class MercenaryType
__MercenaryType = {
    ---@return number
    ---AA Points spent on mercenary abilities
    AAPoints = function()end,
    ---@return string
    ---Current stance of the mercenary
    Stance = function()end,
    ---@return string
    ---Current state of the mercenary (returns "DEAD","SUSPENDED","ACTIVE", or "UNKNOWN"
    State = function()end,
    ---@return number
    ---Current state ID of the mercenary as a number.
    StateID = function()end,
    ---@return string
    ---Index
    Index = function()end,
}