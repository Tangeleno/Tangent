---@diagnostic disable: missing-return
---@class AltAbilityType
__AltAbilityType = {
    ---Can this AA be trained
    ---@return boolean
    CanTrain = function()end,
    ---The cost to train
    ---@return number
    Cost = function()end,
    ---Basic Description
    ---@return string
    Description = function()end,
    ---Id of the AA
    ---@return number
    ID = function()end,
    ---Index of the AA
    ---@return number
    Index = function()end,
    ---Max Rank Available
    ---@return number
    MaxRank = function()end,
    ---Minimum level to train
    ---@return number
    MinLevel = function()end,
    ---Reuse time with any hastened AAs
    ---@return number
    MyReuseTime = function()end,
    ---Name of the AA
    ---@return string
    Name = function()end,
    ---Index of the next rank of the AA
    ---@return number
    NextIndex = function()end,
    ---Number of points spent on the AA
    ---@return number
    PointsSpent = function()end,
    ---Is this a passive AA
    ---@return boolean
    Passive = function()end,
    ---AA required before this one can be purchased
    ---@return AltAbilityType
    RequiresAbility = function()end,
    ---Rank of the AA
    ---@return number
    Rank = function()end,
    ---Number of required points in RequiresAbility
    ---@return number
    RequiresAbilityPoints = function()end,
    ---Reuse time with no hastened AAs
    ---@return number
    ReuseTime = function()end,
    ---Sort name of the ability
    ---@return string
    ShortName = function()end,
    ---Spell used by the ability if any
    ---@return SpellType
    Spell = function()end,
    ---AA Type
    ---@return number
    Type = function()end,
}