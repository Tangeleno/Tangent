---@diagnostic disable: missing-return
---@class XTargetType:SpawnType
__XTargetType = {
    ---@return number
    ---ID of specified XTarget
    ID = function()end,
    ---@return string
    ---Name of specified XTarget
    Name = function()end,
    ---@return number
    ---PctAggro of specified XTarget
    PctAggro = function()end,
    ---@return string
    ---Extended target type (see https://macroquest2.com/wiki/index.php/DataType:xtarget#Extended_Target_Types)
    TargetType = function()end,
}