---@diagnostic disable: duplicate-index, missing-return
---@class TargetType : SpawnType
__TargetType = {
    ---@return SpellType
    ---Returns the name of the Aego spell if the Target has one
    Aego = function()end,
    ---@return SpawnType
    ---Returns the target's current target.
    AggroHolder = function()end,
    ---@return SpellType
    ---Returns the name of the Beneficial spell if the Target has one. This will skip "player" casted buffs, but will show NPC Casted buffs and some AA buffs.
    Beneficial = function()end,
    ---@return SpellType
    ---Returns the target's spell by buff index number.
    ---@param index number
    Buff = function(index)end,
    ---@return SpellType
    ---Returns the target's spell name, or the first buff if no Index is provided.
    ---@param name string
    Buff = function(name)end,
    ---@return number
    ---Returns the number of buffs on the target.
    BuffCount = function()end,
    ---@return TimeStampType
    ---Returns the duration remaining on this target buff by index number
    ---@param index number
    BuffDuration = function(index)end,
    ---@return TimeStampType
    ---Returns the duration remaining on this target buff by spell name
    ---@param name string
    BuffDuration = function(name)end,
    ---@return boolean
    ---Returns TRUE when the target's buffs are finished populating.
    BuffsPopulated = function()end,
    ---@return SpellType
    ---Returns the name of the Brells spell if the Target has one
    Brells = function()end,
    ---@return SpellType
    ---Returns the name of the Charmed spell if the Target has one
    Charmed = function()end,
    ---@return SpellType
    ---Returns the name of the Clarity spell if the Target has one
    Clarity = function()end,
    ---@return SpellType
    ---Returns the name of any the Corruption spell if Target has one
    Corrupted = function()end,
    ---@return SpellType
    ---Returns the name of the Curse spell if Target has one
    Cursed = function()end,
    ---@return SpellType
    ---Returns the name of the Cripple spell if the Target has one
    Crippled = function()end,
    ---@return string
    ---Returns the name of a Disease spell if the Target has one
    Diseased = function()end,
    ---@return string
    ---Returns the name of a DOT spell if the Target has one
    Dotted = function()end,
    ---@return SpellType
    ---Returns the name of the Damage Shield spell if the Target has one
    DSed = function()end,
    ---@return SpellType
    ---Returns the name of the Focus spell if the Target has one
    Focus = function()end,
    ---@return SpellType
    ---Returns the name of the Growth spell if the Target has one
    Growth = function()end,
    ---@return SpellType
    ---Returns the name of the Haste spell if the Target has one
    Hasted = function()end,
    ---@return SpellType
    ---Returns the name of the Hybrid HP spell if the Target has one
    HybridHP = function()end,
    ---@return SpellType
    ---Returns the name of the Malo spell if the Target has one
    Maloed = function()end,
    ---@return SpellType
    ---Returns the name of the Mez spell if the Target has one
    Mezzed = function()end,
    ---@return string
    ---Returns the name of a Poison spell if the Target has one
    Poisoned = function()end,
    ---@return SpellType
    ---Returns the name of the Predator spell if the Target has one
    Pred = function()end,
    ---@return SpellType
    ---Returns the name of the Rooted spell if the Target has one
    Rooted = function()end,
    ---@return SpellType
    ---Returns the name of the Regen spell if the Target has one
    Regen = function()end,
    ---@return SpellType
    ---Returns the name of the Reverse Damage Shield spell if the Target has one
    RevDSed = function()end,
    ---@return SpellType
    ---Returns the name of the Spiritual Enlightenment spell if the Target has one
    SE = function()end,
    ---@return SpellType
    ---Returns the name of the Shining spell if the Target has one
    Shining = function()end,
    ---@return SpellType
    ---Returns the name of the Skin spell if the Target has one
    Skin = function()end,
    ---@return SpellType
    ---Returns the name of the Slow spell if the Target has one
    Slowed = function()end,
    ---@return SpellType
    ---Returns the name of the Snare spell if the Target has one
    Snared = function()end,
    ---@return SpellType
    ---Returns the name of the Strength spell if the Target has one
    Strength = function()end,
    ---@return SpellType
    ---Returns the name of the Spiritual Vitality spell if the Target has one
    SV = function()end,
    ---@return SpellType
    ---Returns the name of the Symbol spell if the Target has one
    Symbol = function()end,
    ---@return SpellType
    ---Returns the name of the Tash spell if the Target has one
    Tashed = function()end,
}