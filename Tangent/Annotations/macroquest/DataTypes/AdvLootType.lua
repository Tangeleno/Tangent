---@diagnostic disable: missing-return
---@class AdvLootType
---see https://macroquest2.com/wiki/index.php/TLO:AdvLoot#Sub_members_of_TLO:AdvLoot
__AdvLootType = {
    ---Is the item set to always greed
    ---@return boolean
    AlwaysGreed = function()end,
    ---Is the item set to always need
    ---@return boolean
    AlwaysNeed=function()end,
    ---Is the item set to auto roll
    ---@return boolean
    AutoRoll=function()end,
    ---Is the item set to greed
    ---@return boolean
    Greed=function()end,
    ---Icon ID of the item
    ---@return number
    IconID=function()end,
    ---Is the item set to need
    ---@return boolean
    Need=function()end,
    ---Is the item set to never
    ---@return boolean
    Never=function()end,
    ---Is the item set to no
    ---@return boolean
    No=function()end,
    ---Is the item no drop
    ---@return boolean
    NoDrop=function()end,
    ---The number of items in the stack
    ---@return number
    StackSize=function()end,
    ---The ID of the item
    ---@return number
    ID=function()end,
}