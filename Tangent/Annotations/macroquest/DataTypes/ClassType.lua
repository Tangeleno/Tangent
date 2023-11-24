---@diagnostic disable: missing-return
---@class ClassType
__ClassType = {
    ---@return boolean
    ---Can cast spells, including Bard
    CanCast = function()end,
    ---@return boolean
    ---Cleric/Paladin?
    ClericType = function()end,
    ---@return boolean
    ---Druid/Ranger?
    DruidType = function()end,
    ---@return boolean
    ---Cleric/Druid/Shaman?
    HealerType = function()end,
    ---@return number
    ---The class's ID #
    ID = function()end,
    ---@return boolean
    ---Mercenary?
    MercType = function()end,
    ---@return string
    ---The "long name" as in "Ranger"
    Name = function()end,
    ---@return boolean
    ---Necromancer/Shadow Knight?
    NecromancerType = function()end,
    ---@return boolean
    ---Any one of: Shaman, Necromancer, Mage, Beastlord
    PetClass = function()end,
    ---@return boolean
    ---Any one of: Cleric, Druid, Shaman, Necromancer, Wizard, Mage, Enchanter
    PureCaster = function()end,
    ---@return boolean
    ---Shaman/Beastlord?
    ShamanType = function()end,
    ---@return string
    ---The "short name" as in "RNG"
    ShortName = function()end,
}