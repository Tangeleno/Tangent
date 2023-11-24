---@diagnostic disable: duplicate-index, missing-return
---@class NavigationType
__NavigationType = {
    ---Returns true if navigation is currently active
    ---@return boolean
    Active = function()end,
    ---Returns true if navigation is currently paused
    ---@return boolean
    Paused = function()end,
    ---Returns true if a mesh is loaded in the zone
    ---@return boolean
    MeshLoaded = function()end,
    ---Returns true if the specified navigation parameters results in a navigatable path
    ---@return boolean
    ---@param navigationParameters string
    PathExists = function(navigationParameters)end,
    ---Returns the length of the path for the specified navigation parameters if one exists
    ---@return number
    ---@param navigationParameters string
    PathLength = function(navigationParameters)end,
}