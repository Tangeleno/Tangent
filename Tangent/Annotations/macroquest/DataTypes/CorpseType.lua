---@diagnostic disable: duplicate-index, missing-return
---@class CorpseType
__CorpseType = {
    ---@return ItemType
    ---@param index number
    ---#th item on the corpse
    Item = function(index)end,
    ---@return ItemType
    ---@param name string
    ---Finds an item by partial name in this corpse (use Item[=name] for exact)
    Item = function(name)end,
    ---@return number
    ---Number of items on the corpse
    Items = function()end,
    ---@return boolean
    ---Corpse open?
    Open = function()end,
}