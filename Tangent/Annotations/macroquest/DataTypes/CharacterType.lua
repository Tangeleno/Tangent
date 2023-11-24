---@diagnostic disable: duplicate-index, missing-return
---@class CharacterType : SpawnType
__CharacterType = {
    ---@return number
    ---AA exp as a raw number out of 10,000 (10,000=100%)
    AAExp = function()end,
    ---@return number
    ---Unused AA points
    AAPoints = function()end,
    ---@return number
    ---The number of points you have spent on AA abilities
    AAPointsSpent = function()end,
    ---@return number
    ---The total number of AA points you have
    AAPointsTotal = function()end,
    ---@return number
    ---The total number of AA Vitality you have
    AAVitality = function()end,
    ---@return string
    ---Skill name assigned to this doability button
    ---@param name string
    Ability = function(name)end,
    ---@return number
    ---The doability button number that the skill name is on
    ---@param index number
    Ability = function(index)end,
    ---@return boolean
    ---Ability with this name or on this button # ready?
    ---@param id number
    AbilityReady = function(id)end,
    ---@return boolean
    ---Ability with this name or on this button # ready?
    ---@param name string
    AbilityReady = function(name)end,
    ---@return number
    ---Accuracy bonus from gear and spells
    AccuracyBonus = function()end,
    ---@return SpellType
    ---Returns a spell if melee discipline is active.
    ActiveDisc = function()end,
    ---@return number
    ---If Tribute is active, how much it is costing you every 10 minutes. Returns NULL if tribute is inactive.
    ActiveFavorCost = function()end,
    ---@return AltAbilityType
    ---Returns the total number of points you have spent in ability # or name
    ---@param name string
    AltAbility = function(name)end,
    ---@return AltAbilityType
    ---Returns the total number of points you have spent in ability # or name
    AltAbility = function(id)end,
    ---@return boolean
    ---Alt ability # or name ready?
    ---@param name string
    AltAbilityReady = function(name)end,
    ---@return boolean
    ---Alt ability # or name ready?
    ---@param id number
    AltAbilityReady = function(id)end,
    ---@return number
    ---Alt ability reuse time remaining (in ticks) for ability # or name
    ---@param id number
    AltAbilityTimer = function(id)end,
    ---@return number
    ---Alt ability reuse time remaining (in ticks) for ability # or name
    ---@param name string
    AltAbilityTimer = function(name)end,
    ---@return boolean
    ---Alternate timer ready? (Bash/Slam/Frenzy/Backstab). Note: ${AbilityReady} works fine with most of these.
    AltTimerReady = function()end,
    ---@return number
    ---Character Agility
    AGI = function()end,
    ---@return SpawnType
    ---spawn info for aggro lock player
    AggroLock = function()end,
    ---@return boolean
    ---Am I the group leader?
    AmIGroupLeader = function()end,
    ---@return boolean
    ---returns true/false if the assist is complete
    AssistComplete = function()end,
    ---@return number
    ---Attack bonus from gear and spells
    AttackBonus = function()end,
    ---@return number
    ---Your Attack Speed. No haste spells/items = AttackSpeed of 100. A 41% haste item will result in an AttackSpeed of 141. This variable does not take into account spell or song haste.
    AttackSpeed = function()end,
    ---@return string
    ---The aura effect name
    Aura = function()end,
    ---@return boolean
    ---Is Autofire on?
    AutoFire = function()end,
    ---@return number
    ---Avoidance bonus from gear/spells
    AvoidanceBonus = function()end,
    ---@return ItemType
    ---Item in this bankslot #
    ---@param slotNumber number
    Bank = function(slotNumber)end,
    ---@return boolean
    ---Is a bard song playing?
    BardSongPlaying = function()end,
    ---@return number
    ---Slot in your spellbook assigned to spell name.
    ---@param name string
    Book = function(name)end,
    ---@return SpellType
    ---Spell assigned to this slot # in your spellbook
    ---@param slotNumber number
    Book = function(slotNumber)end,
    ---@return BuffType
    ---The buff with this name
    ---@param name string
    Buff = function(name)end,
    ---@return BuffType
    ---The buff in this slot #
    Buff = function(slotNumber)end,
    ---@return boolean
    ---if you are an active buyer
    Buyer = function()end,
    ---@return boolean
    ---for some indoor zones that where not flagged as nomount and added bazaar, nexus to zones where its ok to mount.
    CanMount = function()end,
    ---@return number
    ---Career favor/tribute
    CareerFavor = function()end,
    ---@return number
    ---Total cash on your character, expressed in coppers (eg. if you are carrying 100pp, Cash will return 100000)
    Cash = function()end,
    ---@return number
    ---Total cash in your bank, expressed in coppers
    CashBank = function()end,
    ---@return number
    ---Character Charisma
    CHA = function()end,
    ---@return number
    ---Chronobines on your character
    Chronobines = function()end,
    ---@return number
    ---Clairvoyance Bonus
    ClairvoyanceBonus = function()end,
    ---@return boolean
    ---In combat?
    Combat = function()end,
    ---@return TimeStampType
    ---ETA for spell to finish casting
    CastTimeLeft = function()end,
    ---@return SpawnType
    ---The target for the currently casting spell
    CastTarget = function ()end,
    ---@return SpellType
    ---The name of Combat Ability # in your list (not the same as anyone else's list!)
    ---@param index number
    CombatAbility = function(index)end,
    ---@return number
    ---The number of Combat ability name in your list (not the same as anyone else's list!)
    ---@param name string
    CombatAbility = function(name)end,
    ---@return boolean
    ---Is this Combat Ability ready?
    ---@param id number
    CombatAbilityReady = function(id)end,
    ---@return boolean
    ---Is this Combat Ability ready?
    CombatAbilityReady = function(name)end,
    ---@return number
    ---The time remaining (in seconds) before the Combat Ability name is usable
    ---@param name string
    CombatAbilityTimer = function(name)end,
    ---@return number
    ---The time remaining (in seconds) before the Combat Ability name is usable
    ---@param id number
    CombatAbilityTimer = function(id)end,
    ---@return number
    ---Combat Effects bonus from gear and spells
    CombatEffectsBonus = function()end,
    ---@return string
    ---Returns one of the following: COMBAT, DEBUFFED, COOLDOWN, ACTIVE, RESTING, UNKNOWN
    CombatState = function()end,
    ---@return number
    ---Copper on your character
    Copper = function()end,
    ---@return number
    ---Copper in bank
    CopperBank = function()end,
    ---@return SpellType
    ---Returns the name of the Corrupted debuff if you have one
    Corrupted = function()end,
    ---@return number
    ---Number of buffs you have, not including short duration buffs
    CountBuffs = function()end,
    ---@return number
    ---Number of curse counters you have
    CountersCurse = function()end,
    ---@return number
    ---Number of disease counters you have
    CountersDisease = function()end,
    ---@return number
    ---Number of poison counters you have
    CountersPoison = function()end,
    ---@return number
    ---Number of songs you have
    CountSongs = function()end,
    ---@return number
    ---Damage Absorption Counters Remaining
    Counters = function()end,
    ---@return number
    ---Current endurance
    CurrentEndurance = function()end,
    ---@return number
    ---Current favor/tribute
    CurrentFavor = function()end,
    ---@return number
    ---Current hit points
    CurrentHPs = function()end,
    ---@return number
    ---Current mana
    CurrentMana = function()end,
    ---@return number
    ---Current weight
    CurrentWeight = function()end,
    ---@return SpellType
    ---Returns the name of the Curse debuff if you are effected by one
    Cursed = function()end,
    ---@return number
    ---Damage Shield bonus from gear and spells
    DamageShieldBonus = function()end,
    ---@return number
    ---Damage Shield Mitigation bonus from gear and spells
    DamageShieldMitigationBonus = function()end,
    ---@return number
    ---Damage absorption remaining (eg. from Rune-type spells)
    Dar = function()end,
    ---@return string
    ---Returns the name of any Disease spell
    Diseased = function()end,
    ---@return number
    ---Character Dexterity
    DEX = function()end,
    ---@return string
    ---Returns name of first DoT on character.
    Dotted = function()end,
    ---@return number
    ---DoT Shield bonus from gear and spells
    DoTShieldBonus = function()end,
    ---@return number
    ---Doubloons on your character
    Doubloons = function()end,
    ---@return TicksType
    ---Downtime (Ticks left til combat timer end)
    Downtime = function()end,
    ---@return number
    ---Drunkenness level
    Drunk = function()end,
    ---@return number
    ---Number of Ebon Crystals on your character
    EbonCrystals = function()end,
    ---@return number
    ---Endurance bonus from gear and spells
    EnduranceBonus = function()end,
    ---@return number
    ---Endurance regen from the last tick
    EnduranceRegen = function()end,
    ---@return number
    ---Endurance regen bonus
    EnduranceRegenBonus = function()end,
    ---@return number
    ---Experience (out of 10,000)
    Exp = function()end,
    ---@return number
    ---Returns a numeric number representing which expansions your toon is flagged for
    ExpansionFlags = function()end,
    ---@return number
    ---Faycites on your character
    Faycites = function()end,
    ---@return FellowshipType
    ---Info about Fellowship
    Fellowship = function()end,
    ---@return number
    ---Number of open buff slots (not counting the short duration buff slots)
    FreeBuffSlots = function()end,
    ---@return number
    ---Number of free inventory spaces, of at least # size (giant=4) 
    ---@param size? number @Defaults to '0' to include all sizes
    FreeInventory = function(size)end,
    ---@return number|SpellType
    ---If provided a string returns the slot # with the spell name
    ---If provided a number returns the spell in that gem slot
    ---@param index string|number
    Gem = function(index)end,
    ---@return TicksType
    ---The timer for the spell with this name or in this gem #
    ---@param index number|string
    GemTimer = function(index)end,
    ---@return number
    ---Gold on character
    Gold = function()end,
    ---@return number
    ---Gold in bank
    GoldBank = function()end,
    ---@return SpawnType
    ---Current group assist target
    GroupAssistTarget = function()end,
    ---@return boolean
    ---Grouped?
    Grouped = function()end,
    ---@return number
    ---Group leadership experience (out of 330)
    GroupLeaderExp = function()end,
    ---@return number
    ---Group leadership points
    GroupLeaderPoints = function()end,
    ---@return string
    ---Returns a string of your group members (excluding you)
    GroupList = function()end,
    ---@return SpawnType
    ---Current group marked NPC (1-3)
    ---@param index number
    GroupMarkNPC = function(index)end,
    ---@return number
    ---Size of group
    GroupSize = function()end,
    ---@return number
    ---Total LDoN points earned in Deepest Guk
    GukEarned = function()end,
    ---@return number
    ---Returns the ID number of your guild
    GuildID = function()end,
    ---@return boolean
    ---Returns TRUE/FALSE if you have that expansion #
    ---@param expansionNumber number
    HaveExpansion = function(expansionNumber)end,
    ---@return number
    ---Total Combined Haste (worn and spell) as shown in Inventory Window stats
    Haste = function()end,
    ---@return number
    ---Total Heal Amount bonus from gear
    HealAmountBonus = function()end,
    ---@return number
    ---Total Heroic Agility bonus from gear
    HeroicAGIBonus = function()end,
    ---@return number
    ---Total Heroic Charisma bonus from gear
    HeroicCHABonus = function()end,
    ---@return number
    ---Total Heroic Dexterity bonus from gear
    HeroicDEXBonus = function()end,
    ---@return number
    ---Total Heroic Intelligence bonus from gear
    HeroicINTBonus = function()end,
    ---@return number
    ---Total Heroic Stamina bonus from gear
    HeroicSTABonus = function()end,
    ---@return number
    ---Total Heroic Strength bonus from gear
    HeroicSTRBonus = function()end,
    ---@return number
    ---Total Heroic Wisdom bonus from gear
    HeroicWISBonus = function()end,
    ---@return number
    ---Hit point bonus from gear and spells
    HPBonus = function()end,
    ---@return number
    ---Hit point regeneration from last tick
    HPRegen = function()end,
    ---@return number
    ---HP regen bonus from gear and spells
    HPRegenBonus = function()end,
    ---@return number
    ---Hunger level
    Hunger = function()end,
    ---@return number
    ---Spawn ID
    ID = function()end,
    ---@return boolean
    ---Returns TRUE/FALSE if you are in an instance.
    InInstance = function()end,
    ---@return number
    ---Character Intelligence
    INT = function()end,
    ---@return ItemType
    ---Item in this slot #
    ---@param slotNumber number
    Inventory = function(slotNumber)end,
    ---@return ItemType
    ---Item in this slotname (inventory slots only). See Slot Names for a list of slotnames.
    ---@param slotName string
    Inventory = function(slotName)end,
    ---@return string
    ---Returns the invulnerable spell name on you, can be used with spell data type ex. ${Me.Invulnerable.Spell.ID}
    Invulnerable = function()end,
    ---@return boolean
    ---True/False on if the item is ready to cast.
    ---@param itemName string
    ItemReady = function(itemName)end,
    ---@return number
    ---Level of Delegate MA of the current group leader (not your own ability level)
    LADelegateMA = function()end,
    ---@return number
    ---Level of Delegate Mark NPC of the current group leader (not your own ability level)
    LADelegateMarkNPC = function()end,
    ---@return number
    ---Level of Find Path PC of the current group leader (not your own ability level)
    LAFindPathPC = function()end,
    ---@return number
    ---Level of Health Enhancement of the current group leader (not your own ability level)
    LAHealthEnhancement = function()end,
    ---@return number
    ---Level of Health Regen of the current group leader (not your own ability level)
    LAHealthRegen = function()end,
    ---@return number
    ---Level of HoTT of the current group leader (not your own ability level)
    LAHoTT = function()end,
    ---@return number
    ---Level of Inspect Buffs of the current group leader (not your own ability level)
    LAInspectBuffs = function()end,
    ---@return number
    ---Level of Mana Enhancement of the current group leader (not your own ability level)
    LAManaEnhancement = function()end,
    ---@return number
    ---Level of Mark NPC of the current group leader (not your own ability level)
    LAMarkNPC = function()end,
    ---@return number
    ---Level of NPC Health of the current group leader (not your own ability level)
    LANPCHealth = function()end,
    ---@return number
    ---Level of Offense Enhancement of the current group leader (not your own ability level)
    LAOffenseEnhancement = function()end,
    ---@return number
    ---Level of Spell Awareness of the current group leader (not your own ability level)
    LASpellAwareness = function()end,
    ---@return number
    ---The EQ language number of the specified language. See below for language/number table.
    ---@param name string
    Language = function(name)end,
    ---@return string
    ---Returns the EQ language name of the language number specified. See below for language/number table.
    ---@param languageNumber number
    Language = function(languageNumber)end,
    ---@return number
    ---Your skill in language
    ---@param language string
    LanguageSkill = function(language)end,
    ---@return number
    ---Size of your largest free inventory space
    LargestFreeInventory = function()end,
    ---@return number
    ---Size of your largest free inventory space
    LargestFreeInventory = function()end,
    ---@return TimeStampType
    ---Returns a timestamp of last time you zoned
    LastZoned = function()end,
    ---@return number
    ---Available LDoN points
    LDoNPoints = function()end,
    ---@return number
    ---Character Level
    Level = function()end,
    ---@return number
    ---Mana bonus from gear and spells
    ManaBonus = function()end,
    ---@return number
    ---Mana regeneration from last tick
    ManaRegen = function()end,
    ---@return number
    ---Mana regen bonus from gear and spells
    ManaRegenBonus = function()end,
    ---@return number
    ---Max number of buffs you can have on you. /echo ${Me.MaxBuffSlots}
    MaxBuffSlots = function()end,
    ---@return number
    ---Max endurance
    MaxEndurance = function()end,
    ---@return number
    ---Max hit points
    MaxHPs = function()end,
    ---@return number
    ---Max mana
    MaxMana = function()end,
    ---@return string
    ---The state of your Mercenary, ACTIVE, SUSPENDED, or UNKNOWN (If it's dead). Returns NULL if you do not have a Mercenary.
    Mercenary = function()end,
    ---@return string
    ---Current active mercenary stance as a string, default is NULL.
    MercenaryStance = function()end,
    ---@return number
    ---Total LDoN points earned in Miragul's
    MirEarned = function()end,
    ---@return number
    ---Total LDoN points earned in Mistmoore
    MMEarned = function()end,
    ---@return boolean
    ---Moving? (including strafe)
    Moving = function()end,
    ---@return string
    ---First name
    Name = function()end,
    ---@return number
    ---Returns the amount of spell gems your toon has
    NumGems = function()end,
    ---@return number
    ---Orux on your character
    Orux = function()end,
    ---@return number
    ---AA exp as a %
    PctAAExp = function()end,
    ---@return number
    ---Percentage of AA Vitality your toon has
    PctAAVitality = function()end,
    ---@return number
    ---Your aggro percentage
    PctAggro = function()end,
    ---@return number
    ---Current endurance as a %
    PctEndurance = function()end,
    ---@return number
    ---Experience as a %
    PctExp = function()end,
    ---@return number
    ---Group leadership exp as a %
    PctGroupLeaderExp = function()end,
    ---@return number
    ---Current HP as a %
    PctHPs = function()end,
    ---@return number
    ---Current mana as a %
    PctMana = function()end,
    ---@return number
    ---Raid leadership experience as a %
    PctRaidLeaderExp = function()end,
    ---@return number
    ---Percentage of Vitality the toon has
    PctVitality = function()end,
    ---@return SpellType
    ---The spell in this PetBuff slot #
    ---@param buffSlot number
    PetBuff = function(buffSlot)end,
    ---@return number
    ---Finds PetBuff slot with the spell name
    ---@param name string
    PetBuff = function(name)end,
    ---@return number
    ---Phosphenes on your character
    Phosphenes = function()end,
    ---@return number
    ---Phosphites on your character
    Phosphites = function()end,
    ---@return number
    ---Platinum on your character
    Platinum = function()end,
    ---@return number
    ---Platinum in bank
    PlatinumBank = function()end,
    ---@return number
    ---Platinum in shared bank
    PlatinumShared = function()end,
    ---@return string
    ---Returns the name of any Poison spell
    Poisoned = function()end,
    ---@return number
    ---Number of Radiant Crystals on your character
    RadiantCrystals = function()end,
    ---@return SpawnType
    ---Current raid assist target (1-3)
    ---@param index number
    RaidAssistTarget = function(index)end,
    ---@return number
    ---Raid leadership exp (out of 330)
    RaidLeaderExp = function()end,
    ---@return number
    ---Raid leadership points
    RaidLeaderPoints = function()end,
    ---@return SpawnType
    ---Current raid marked NPC (1-3)
    ---@param index number
    RaidMarkNPC = function(index)end,
    ---@return boolean
    ---Ranged attack ready?
    RangedReady = function()end,
    ---@return number
    ---Total LDoN points earned in Rujarkian
    RujEarned = function()end,
    ---@return boolean
    ---Do I have auto-run turned on?
    Running = function()end,
    ---@return number
    ---Secondary Percentage aggro
    SecondaryPctAggro = function()end,
    ---@return SpawnType
    ---spawninfo for secondary aggro player
    SecondaryAggroPlayer = function()end,
    ---@return number
    ---Shielding bonus from gear and spells
    ShieldingBonus = function()end,
    ---@return boolean
    ---Am I Shrouded?
    Shrouded = function()end,
    ---@return string
    ---Returns the name of the Silence type effect on you
    Silenced = function()end,
    ---@return number
    ---Silver on your character
    Silver = function()end,
    ---@return number
    ---Silver in bank
    SilverBank = function()end,
    ---Causes toon to sit if not already
    Sit = function()end,
    ---@return number
    ---Skill level of skill with this name or ID #
    ---@param name string
    Skill = function(name)end,
    ---@return number
    ---Skill level of skill with this name or ID #
    ---@param id number
    Skill = function(id)end,
    ---@return number
    ---Skill cap of skill with this name or ID #
    ---@param id number
    SkillCap = function(id)end,
    ---@return number
    ---Skill cap of skill with this name or ID #
    ---@param name string
    SkillCap = function(name)end,
    ---@return BuffType
    ---Finds song with this name
    ---@param name string
    Song = function(name)end,
    ---@return BuffType
    ---The song in this slot #
    ---@param slotNumber number
    Song = function(slotNumber)end,
    ---@return SpawnType
    ---The character's spawn
    Spawn = function()end,
    ---@return SpellType
    ---@param index string|number @The name or id of the spell
    ---returns the spell in your spellbook, nil if the spell is not scribed
    Spell = function(index)end,
    ---@return boolean
    ---returns TRUE if you have a spell in cooldown and FALSE when not.
    SpellInCooldown = function()end,
    ---@return number
    ---Spell Damage bonus
    SpellDamageBonus = function()end,
    ---@return number
    ---your characters spell rank cap. if it returns: 1 = Rk. I spells 2 = Rk. II spells 3 = Rk. III spells
    SpellRankCap = function()end,
    ---@return boolean
    ---Gem with this spell name or in this gem # ready to cast?
    ---@param gemNumber number
    SpellReady = function(gemNumber)end,
    ---@return boolean
    ---Gem with this spell name or in this gem # ready to cast?
    ---@param name string
    SpellReady = function(name)end,
    ---@return number
    ---Spell Shield bonus from gear and spells
    SpellShieldBonus = function()end,
    ---@return number
    ---Character Stamina
    STA = function()end,
    ---causes toon to stand if not already
    Stand = function()end,
    ---Causes toon to stop casting
    StopCast = function()end,
    ---@return number
    ---Character Strength
    STR = function()end,
    ---@return number
    ---Strikethrough bonus from gear and spells
    StrikeThroughBonus = function()end,
    ---@return boolean
    ---Am I stunned?
    Stunned = function()end,
    ---@return number
    ---Stun Resist bonus from gear and spells
    StunResistBonus = function()end,
    ---@return string
    ---Subscription type GOLD, FREE, (Silver?)
    Subscription = function()end,
    ---@return number
    ---Returns an int Usage: /echo I have ${Me.SubscriptionDays} left before my all access expires.
    SubscriptionDays = function()end,
    ---@return string
    ---Last name
    Surname = function()end,
    ---@return number
    ---Your character's lowest resist
    svChromatic = function()end,
    ---@return number
    ---Character Cold Resist
    svCold = function()end,
    ---@return number
    ---Character Corruption Resist
    svCorruption = function()end,
    ---@return number
    ---Character Disease Resist
    svDisease = function()end,
    ---@return number
    ---Character Fire Resist
    svFire = function()end,
    ---@return number
    ---Character Magic Resist
    svMagic = function()end,
    ---@return number
    ---Character Poison Resist
    svPoison = function()end,
    ---@return number
    ---The average of your character's resists
    svPrismatic = function()end,
    ---@return number
    ---Total LDoN points earned in Takish
    TakEarned = function()end,
    ---@return SpawnType
    ---Target of Target (will only work when group or raid Target of Target is active; if not, it will return NULL)
    TargetOfTarget = function()end,
    ---@return number
    ---Thirst level
    Thirst = function()end,
    ---@return boolean
    ---if you are an active Trader
    Trader = function()end,
    ---@return boolean
    ---Tribute Active
    TributeActive = function()end,
    ---@return TicksType
    ---Tribute Timer
    TributeTimer = function()end,
    ---@return boolean
    ---TRUE/FALSE if using advanced looting
    UseAdvancedLooting = function()end,
    ---@return number
    ---Character Wisdom
    WIS = function()end,
    ---@return XTargetType
    ---Extended target data for the specified XTarget #. Note: Passing no index to this returns the number of current extended targets.
    ---@param index number
    XTarget = function(index)end,
    ---@return number
    ---Total amount of Vitality your toon has
    Vitality = function()end,
    ---@return number
    ---It returns the number of AUTO-HATER mobs on the extended target window where your aggro is less than the optional parameter aggroPct. aggroPct must be between 1-100 inclusive or it will be set to 100 (the default value).
    ---@param aggroPct number
    XTAggroCount = function(aggroPct)end,
    ---@return number
    ---Maximum number of XTargets
    XTargetSlots = function()end,
}