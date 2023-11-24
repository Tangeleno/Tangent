---@diagnostic disable: missing-return
---@class BuffType : SpellType
__BuffType = {
    ---@return number
    ---The number of counters added by the buff
    Counters = function()end,
    ---@return number
    ---The remaining damage absorption of the buff (if any). This is not entirely accurate, it will only show you to the Dar of your spell when it was initially cast, or what it was when you last zoned (whichever is more recent).
    Dar = function()end,
    ---@return TicksType
    ---The time remaining before the buff fades (not total duration)
    Duration = function()end,
    ---@return number
    ---The ID of the buff or shortbuff slot
    ID = function()end,
    ---@return number
    ---The level of the person that cast the buff on you (not the level of the spell)
    Level = function()end,
    ---@return number
    ---The modifier to a bard song
    Mod = function()end,
    ---Removes the named/partial name buff
    Remove = function()end,
    ---@return SpellType
    ---The spell
    Spell = function()end,
}