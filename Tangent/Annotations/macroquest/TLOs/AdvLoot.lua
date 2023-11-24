---@diagnostic disable: missing-return

---@class TLOAdvLoot
---See https://macroquest2.com/wiki/index.php/TLO:AdvLoot
__TLOAdvLoot = {
    ---Is looting from AdvLoot in progress
    ---@return boolean
    LootInProgress = function()end,
    ---Data on the shared list
    ---@return AdvLootType
    ---@param index number
    SList = function(index)end,
    ---Data on the personal list
    ---@return AdvLootType
    ---@param index number
    PList=function(index)end,
    ---@return number
    SCount=function()end,
    ---@return number
    PCount=function()end,
    ---@return number
    SWantCount=function()end,
    ---@return number
    PWantCount=function()end
}
