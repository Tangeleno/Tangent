---@diagnostic disable: missing-return
---@class CachedBuffType : SpellType
__CachedBuffType = {
	---@return string
    ---Returns the name of the caster who applied the cached buff
    Caster = function()end,
	---@return number
    ---Returns the number of cached buffs, or -1 if none
    Count = function()end,
	---@return number
    ---Returns the buff slot the target had the buff in
    Slot = function()end,
	---@return SpellType
    ---The buff spell
    Spell = function()end,
	---@return number
    ---The buff spell id
    SpellID = function()end,
	---@return TimeStampType
    ---Original duration of the buff
    OriginalDuration = function()end,
	---@return TimeStampType
    ---Current estimated duration of the buff
    Duration = function()end,
	---@return TimeStampType
    ---How stale the data is
    Staleness = function()end,
}