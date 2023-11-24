---@diagnostic disable: missing-return
---@class TaskMemberType
__TaskMemberType = {
    ---@return string
    ---Name of the member
    Name = function()end,
    ---@return boolean
    ---True if member is leader
    Leader = function()end,
    ---@return number
    ---Task index for member (i.e., 1-6)
    Index = function()end,
}