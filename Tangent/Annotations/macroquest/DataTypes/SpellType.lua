---@diagnostic disable: missing-return
---@class SpellType
__SpellType = {
    ---@return number
    ---AE range (group spells use this for their range)
    AERange = function()end,
    ---@return string
    ---Message when cast on others
    CastOnAnother = function()end,
    ---@return string
    ---Message when cast on yourself
    CastOnYou = function()end,
    ---@return TimeStampType
    ---Cast time (unadjusted)
    CastTime = function()end,
    ---@return string
    ---The resist counter. Will be one of "Disease", "Poison", "Curse" or "Corruption"
    CounterType = function()end,
    ---@return number
    ---The number of counters that the spell adds
    CounterNumber = function()end,
    ---@return TicksType
    ---Duration of the spell (if any)
    Duration = function()end,
    ---@return TicksType
    ---Duration of the spell (if any)
    DurationValue1 = function()end,
    ---@return TimeStampType
    ---Time to recover after fizzle
    FizzleTime = function()end,
    ---@return number
    ---Icon number of the spell.
    GemIcon = function()end,
    ---@return number
    ---Percentage of haste
    HastePct = function()end,
    ---@return number
    ---Spell ID
    ID = function()end,
    ---@return boolean
    ---is this spell a skill?
    IsSkill = function()end,
    ---@return boolean
    ---Is this spell a Swarm spell?
    IsSwarmSpell = function()end,
    ---@return number
    ---Level
    Level = function()end,
    ---@return number
    ---Appears to be max distance
    Location = function()end,
    ---@return number
    ---Mana cost (unadjusted)
    Mana = function()end,
    ---@return TimeStampType
    ---Adjusted cast time
    MyCastTime = function()end,
    ---@return number
    ---Adjusted spell range, including focus effects, etc.
    MyRange = function()end,
    ---@return string
    ---Spell Name
    Name = function()end,
    ---@return number
    ---Push back amount
    PushBack = function()end,
    ---@return number
    ---Maximum range to target (use AERange for AE and group spells)
    Range = function()end,
    ---@return number
    ---Returns either 1, 2 or 3 for spells and 4-30 for clickys and potions.
    Rank = function()end,
    ---@return string
    ---Returns the spell/combat ability name rank character has.
    RankName = function()end,
    ---@return number
    ---Time to recast after successful cast
    RecastTime = function()end,
    ---@return TimeStampType
    ---Same as FizzleTime
    RecoveryTime = function()end,
    ---@return number
    ---Resist adjustment
    ResistAdj = function()end,
    ---@return string
    ---See below for Resist Types
    ResistType = function()end,
    ---@return string
    ---See below for Skill Types
    Skill = function()end,
    ---@return number
    ---Percentage of slow
    SlowPct = function()end,
    ---@return number
    ---Icon number of the spell
    SpellIcon = function()end,
    ---@return string
    ---"Beneficial(Group)", "Beneficial", "Detrimental" or "Unknown"
    SpellType = function()end,
    ---@return boolean
    ---@param duration number
    ---Does the selected spell stack with your current buffs (duration is in ticks)
    Stacks = function(duration)end,
    ---@return boolean
    ---@param duration number
    ---Does the selected spell stack with your pet's current buffs (duration is in ticks)
    StacksPet = function(duration)end,
    ---@return boolean
    ---@param duration number
    ---Does the selected spell stack with your target's current buffs (duration is in ticks)
    StacksTarget = function(duration)end,
    ---@return boolean
    ---@param name string
    ---Does the selected spell stack with the specific SPELL name DOES NOT work with AAs.
    StacksWith = function(name)end,
    ---@return string
    ---See below for Target Types
    TargetType = function()end,
    ---@return string
    ---The "wear off" message
    WearOff = function()end,
    ---@return boolean
    ---@param name string
    ---Does the selected spell stack with the specific SPELL name DOES NOT work with AAs.
    WillStack = function(name)end,
    ---@return number
    ---@param index number
    Attrib = function(index)end,
    ---@return number
    NumEffects = function()end,
    ---@return number
    ---@param index number
    Restrictions = function(index)end,
    ---@return number
    ---@param index number
    Base = function(index)end,
    ---@return string
    Category = function()end,
    ---@return string
    Subcategory = function()end,
    ---@return number
    StackingGroup = function()end,
    ---@return number
    HateGenerated = function()end,
    ---@param index number
    ---@return number
    Max = function(index)end
}