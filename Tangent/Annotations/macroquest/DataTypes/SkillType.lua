---@diagnostic disable: missing-return
---@class SkillType
__SkillType = {
    ---@return boolean
    ---Returns TRUE if the skill has been activated
    Activated=function()end,
    ---@return boolean
    ---Returns TRUE if the skill uses the kick/bash/slam/backstab/frenzy timer
    AltTimer=function()end,
    ---@return number
    ---Skill number
    ID=function()end,
    ---@return number
    ---Minimum level for your class
    MinLevel=function()end,
    ---@return string
    ---Name of the skill
    Name=function()end,
    ---@return number
    ---Reuse timer (what number format? ticks, seconds, deciseconds?)
    ReuseTime=function()end,
    ---@return number
    ---Skill cap based on your current level and class.
    SkillCap=function()end,
    ---@return number
    ---Base skill level for your class
    StartingSkill=function()end,
}