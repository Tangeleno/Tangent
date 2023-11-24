---@diagnostic disable: missing-return
---@class TaskObjectiveType
__TaskObjectiveType = {
    ---@return string
    ---Returns a tasks's Objectives
    Instruction = function()end,
    ---@return string
    ---Returns the status of the objective in the format amount done Vs total IE 0/3
    Status = function()end,
    ---@return string
    ---Returns the zone the objective is to be performed in
    Zone = function()end,
}