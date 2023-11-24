---@diagnostic disable: missing-return
---@class MenuType
__MenuType = {
    ---No documentation
    ---@return number
    Address = function()end,
    ---No documentation
    ---@return number
	NumVisibleMenus = function()end,
    ---No documentation
    ---@return number
	CurrMenu = function()end,
    ---No documentation
    ---@return string
	Name = function()end,
    ---No documentation
    ---@return number
	NumItems = function()end,
    ---No documentation
    ---@return string
    ---@param index number
	Items = function(index)end,
    ---No documentation
    ---@param name string
    Select = function(name)end,
}