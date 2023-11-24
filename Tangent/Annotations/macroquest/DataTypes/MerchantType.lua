---@diagnostic disable: duplicate-index, missing-return
---@class MerchantType
__MerchantType = {
    ---@return boolean
    ---Returns TRUE if the merchant's inventory is full
    Full = function()end,
    ---@return number
    ---Number of items on the merchant
    Items = function()end,
    ---@param index number
    ---@return ItemType
    ---Item number # on the merchant's list
    Item = function(index)end,
    ---@param name string
    ---@return ItemType
    ---Finds an item by partial name on the merchant (use merchant.Item[=name] for exact)
    Item = function(name)end,
    ---@return number
    ---The number used to calculate the buy and sell value for an item (this is what is changed by charisma and faction). This value is capped at 1.05 Markup*Item Value = Amount you buy item for Item Value*(1/Markup) = Amount you sell item for
    Markup = function()end,
    ---@return boolean
    ---Returns TRUE if merchant is open
    Open = function()end,
    ---@return ItemType
    ---The currently selected item in the merchant window, and item type
    SelectedItem = function()end,
    ---@return boolean
    ---True if the merchants itemlist has been filled in.
    ItemsReceived = function()end,
    ---Will open the merchant closest to you, or if you have a merchant target
    OpenWindow = function()end,
    ---@param name string
    ---Select item specified or partial match that fits. Use SelectItem[=xxx] for EXACT match(its not case sensitive)
    SelectItem = function(name)end,
    ---@param count number
    ---Buys # of whatever is selected with Merchant.SelectItem[xxx]
    Buy = function(count)end,
    ---@param count number
    ---Sell # of whatever is selected with /seletitem. See examples
    Sell = function(count)end,
}