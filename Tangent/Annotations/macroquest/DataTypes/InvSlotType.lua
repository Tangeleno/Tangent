---@diagnostic disable: missing-return
---@class InvSlotType
__InvSlotType = {
    ---@return number
    ---ID of this item slot (usable directly by /itemnotify)
    ID = function()end,
    ---@return ItemType
    ---Item data for the item in this slot
    Item = function()end,
    ---@return string
    ---For inventory slots not inside packs, the slot name, otherwise NULL
    Name = function()end,
    ---@return InvSlotType
    ---Container that must be opened to access the slot with /itemnotify
    Pack = function()end,
    ---@return number
    ---Slot number inside the pack which holds the item, otherwise NUL
    Slot = function()end,
}