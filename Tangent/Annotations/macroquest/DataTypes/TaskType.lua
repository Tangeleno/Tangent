---@diagnostic disable: duplicate-index, missing-return
---@class TaskType
__TaskType = {
    ---@return string
    ---@Returns the task's place on the tasklist
    Index = function()end,
    ---@return TaskObjectiveType
    ---@Returns a tasks's Objectives
    ---@param index number
    Objective = function(index)end,
    ---@return number
    ---@Returns the current count of the .Type needed to complete a objective
    CurrentCount = function()end,
    ---@return number
    ---@Returns the required count of the .Type needed to complete a objective
    RequiredCount = function()end,
    ---@return boolean
    ---@Returns true or false if a objective is optional
    Optional = function()end,
    ---@return string
    ---@Returns a string of the required item to complete a objective.
    RequiredItem = function()end,
    ---@return string
    ---@Returns a string of the required skill to complete a objective.
    RequiredSkill = function()end,
    ---@return string
    ---@Returns a string of the required spell to complete a objective.
    RequiredSpell = function()end,
    ---@return number
    ---@Returns an int of the switch used in a objective.
    DZSwitchID = function()end,
    ---@return number
    ---@Returns an int of the task ID
    ID = function()end,
    ---@return string
    ---@Returns description of current step in the task
    Step = function()end,
    ---@return string
    ---@Selects the task
    Select = function()end,
    ---@return string
    ---@Returns name of the shared task
    Title = function()end,
    ---@return TicksType
    ---@Returns amount of time before task expires
    Timer = function()end,
    ---@return number
    ---@Returns number of members in task
    Members = function()end,
    ---@return TaskMemberType
    ---@param index number|string
    ---@Returns specified member in task by index or name
    Member = function(index)end,
    ---@return string
    ---@Returns task leader's name
    Leader = function()end,
    ---@return number
    ---@Returns the Quest Window List Index. (if the window actually has the list filled)
    WindowIndex = function()end,
    ---@return string
    ---@Returns a string that can be one of the following:  Unknown,None,Deliver,Kill,Loot,Hail,Explore,Tradeskill,Fishing, Foraging,Cast,UseSkill,DZSwitch,DestroyObject,Collect,Dialogue
    Type = function()end,
}