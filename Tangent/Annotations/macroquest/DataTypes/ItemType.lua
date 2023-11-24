---@diagnostic disable: duplicate-index, missing-return
---@class ItemType
__ItemType = {
    ---@return number
    ---AC value on item
    AC = function()end,
    ---@return number
    ---AGI value on item
    AGI = function()end,
    ---@return number
    ---Accuracy
    Accuracy = function()end,
    ---@return number
    ---Attack value on item
    Attack = function()end,
    ---@return boolean
    ---Attuneable?
    Attuneable = function()end,
    ---@return number
    ---Augment Restrictions
    AugRestrictions = function()end,
    ---@return number
    ---Number of augs on this item
    Augs = function()end,
    ---@return number
    ---Aug slot 1
    AugSlot1 = function()end,
    ---@return number
    ---Aug slot 2
    AugSlot2 = function()end,
    ---@return number
    ---Aug slot 3
    AugSlot3 = function()end,
    ---@return number
    ---Aug slot 4
    AugSlot4 = function()end,
    ---@return number
    ---Aug slot 5
    AugSlot5 = function()end,
    ---@return number
    ---Augment Type
    AugType = function()end,
    ---@return number
    ---Avoidance
    Avoidance = function()end,
    ---@return number
    ---The cost to buy this item from active merchant
    BuyPrice = function()end,
    ---@return number
    ---Spell effect's cast time (in seconds)
    CastTime = function()end,
    ---@return number
    ---CHA value on item
    CHA = function()end,
    ---@return number
    ---Charges
    Charges = function()end,
    ---@return number
    ---Clairvoyance
    Clairvoyance = function()end,
    ---@return string
    ---Returns the #th long class name of the listed classes on an item. Items suitable for ALL classes will effectively have all 17 classes listed.
    Class = function(index)end,
    ---@return number
    ---The number of classes that can use the item. Items suitable for ALL classes will return 16.
    Classes = function()end,
    ---@return number
    ---CombatEffects
    CombatEffects = function()end,
    ---@return number
    ---Number of slots, if this is a container
    Container = function()end,
    ---@return number
    ---Damage Shield Mitigation
    DamageShieldMitigation = function()end,
    ---@return number
    ---Damage Shield value on item
    DamShield = function()end,
    ---@return string
    ---Returns the #th deity of the listed deities on an item. Items with no deity restrictions will return NULL for all values of #.
    Deity = function(index)end,
    ---@return number
    ---The number of deities that can use the item. Items with no deity restrictions will return 0.
    Deities = function()end,
    ---@return number
    ---DEX value on item
    DEX = function()end,
    ---@return string
    ---"None", "Magic", "Fire", "Cold", "Poison", "Disease"
    DMGBonusType = function()end,
    ---@return number
    ---DoT Shielding
    DoTShielding = function()end,
    ---@return string
    ---Spell effect type (see below for spell effect types)
    EffectType = function()end,
    ---@return number
    ---Endurance
    Endurance = function()end,
    ---@return number
    ---Endurance regen
    EnduranceRegen = function()end,
    ---@return EvolvingType
    ---Does this item have Evolving experience on?
    Evolving = function()end,
    ---@return number
    ---The number of items needed to fill all the stacks of the item you have (with a stacksize of 20). If you have 3 stacks (1, 10, 20 in those stacks), you have room for 60 total and you have 31 on you, so FreeStack would return 29.
    FreeStack = function()end,
    ---@return number
    ---Haste value on item
    Haste = function()end,
    ---@return number
    ---HealAmount (regen?)
    HealAmount = function()end,
    ---@return number
    ---Heroic AGI value on item
    HeroicAGI = function()end,
    ---@return number
    ---Heroic CHA value on item
    HeroicCHA = function()end,
    ---@return number
    ---Heroic DEX value on item
    HeroicDEX = function()end,
    ---@return number
    ---Heroic number value on item
    HeroicINT = function()end,
    ---@return number
    ---Heroic STA value on item
    HeroicSTA = function()end,
    ---@return number
    ---Heroic STR value on item
    HeroicSTR = function()end,
    ---@return number
    ---Heroic SvCold value on item
    HeroicSvCold = function()end,
    ---@return number
    ---Heroic SvCorruption value on item
    HeroicSvCorruption = function()end,
    ---@return number
    ---Heroic SvDisease value on item
    HeroicSvDisease = function()end,
    ---@return number
    ---Heroic SvFire value on item
    HeroicSvFire = function()end,
    ---@return number
    ---Heroic SvMagic value on item
    HeroicSvMagic = function()end,
    ---@return number
    ---Heroic SvPoison value on item
    HeroicSvPoison = function()end,
    ---@return number
    ---Heroic WIS value on item
    HeroicWIS = function()end,
    ---@return number
    ---HP value on item
    HP = function()end,
    ---@return number
    ---HPRegen value on item
    HPRegen = function()end,
    ---@return number
    ---Item Icon
    Icon = function()end,
    ---@return number
    ---Item ID
    ID = function()end,
    ---@return number
    ---Instrument Modifier Value
    InstrumentMod = function()end,
    ---@return number
    ---number value on item
    number = function()end,
    ---@return number
    ---Inventory Slot Number (Historic and now deprecated, use ItemSlot and ItemSlot2)
    InvSlot = function()end,
    ---@return ItemType
    ---Item in #th slot, if this is a container or has augs
    Item = function(index)end,
    ---@return number
    ---Returns the delay of the weapon
    ItemDelay = function()end,
    ---@return ItemType
    ---@param value string value must be "CLICKABLE" to generate a clickable link
    ---just prints the actual hexlink for an item (not clickable) unless 'CLICKABLE' is included
    ItemLink = function(value)end,
    ---@return number
    ---Number of items, if this is a container.
    Items = function()end,
    ---@return number
    ---Item Slot number see Slot Names
    ItemSlot = function()end,
    ---@return number
    ---Item Slot subnumber see Slot Names
    ItemSlot2 = function()end,
    ---@return string
    ---"All", "Deepest Guk", "Miragul's", "Mistmoore", "Rujarkian", "Takish", "Unknown"
    LDoNTheme = function()end,
    ---@return boolean
    ---Lore?
    Lore = function()end,
    ---@return boolean
    ---Magic?
    Magic = function()end,
    ---@return number
    ---Mana value on item
    Mana = function()end,
    ---@return number
    ---ManaRegen value on item
    ManaRegen = function()end,
    ---@return number
    ---Max power on an power source
    MaxPower = function()end,
    ---@return number
    ---Quantity of item active merchant has
    MerchQuantity = function()end,
    ---@return string
    ---Name
    Name = function()end,
    ---@return boolean
    ---No Trade?
    NoDrop = function()end,
    ---@return boolean
    ---Temporary?
    NoRent = function()end,
    ---@return number
    ---Power left on power source
    Power = function()end,
    ---@return number
    ---Purity of item
    Purity = function()end,
    ---@return string
    ---Returns the #th long race name of the listed races on an item. Items suitable for ALL races will effectively have all 15 races listed.
    Race = function(index)end,
    ---@return number
    ---The number of races that can use the item. Items suitable for ALL races will return 15.
    Races = function()end,
    ---@return number
    ---Returns the Required Level of an item. Items with no required level will return 0.
    RequiredLevel = function()end,
    ---@return number
    ---Price to sell this item at this merchant
    SellPrice = function()end,
    ---@return number
    ---Shielding
    Shielding = function()end,
    ---@return number
    ---Item size:1 SMALL,2 MEDIUM,3 LARGE,4 GIANT
    Size = function()end,
    ---@return number
    ---If item is a container, size of items it can hold: 1 SMALL,2 MEDIUM,3 LARGE,4 GIANT
    SizeCapacity = function()end,
    ---@return SpellType
    ---Spell effect
    Spell = function()end,
    ---@return number
    ---Spell damage
    SpellDamage = function()end,
    ---@return number
    ---SpellShield
    SpellShield = function()end,
    ---@return number
    ---STA value on item
    STA = function()end,
    ---@return number
    ---Number of items in the stack
    Stack = function()end,
    ---@return number
    ---Number of stacks of the item in your inventory
    Stacks = function()end,
    ---@return boolean
    ---Stackable?
    Stackable = function()end,
    ---@return number
    ---The total number of the stackable item in your inventory
    StackCount = function()end,
    ---@return number
    ---Maximum number if items that can be in the stack
    StackSize = function()end,
    ---@return number
    ---STR value on item
    STR = function()end,
    ---@return number
    ---StrikeThrough
    StrikeThrough = function()end,
    ---@return number
    ---Stun resist
    StunResist = function()end,
    ---@return number
    ---svCold value on item
    svCold = function()end,
    ---@return number
    ---svCorruption value on item
    svCorruption = function()end,
    ---@return number
    ---svDisease value on item
    svDisease = function()end,
    ---@return number
    ---svFire value on item
    svFire = function()end,
    ---@return number
    ---svMagic value on item
    svMagic = function()end,
    ---@return number
    ---svPoison value on item
    svPoison = function()end,
    ---@return TicksType
    ---Returns the number of ticks remaining on an item recast timer
    Timer = function()end,
    ---@return number
    ---Returns the number of seconds remaining on an item recast timer
    TimerReady = function()end,
    ---@return boolean
    ---Tradeskills?
    Tradeskills = function()end,
    ---@return string
    ---Type
    Type = function()end,
    ---@return number
    ---Tribute value of the item
    Tribute = function()end,
    ---@return number
    ---Item value in coppers
    Value = function()end,
    ---@return number
    ---Item weight
    Weight = function()end,
    ---@return number
    ---WIS value on item
    WIS = function()end,
    ---@return InvSlotType
    ---The #th invslot this item can be worn in (fingers/ears count as 2 slots)
    WornSlot = function(index)end,
    ---@return boolean
    ---Can item be worn in invslot with this name? (worn slots only)
    WornSlot = function(name)end,
    ---@return number
    ---The number of invslots this item can be worn in (fingers/ears count as 2 slots)
    WornSlots = function()end,
}