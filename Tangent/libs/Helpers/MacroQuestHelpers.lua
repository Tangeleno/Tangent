require "libs.Helpers.StringFunctions"
require "libs.Helpers.MathFunctions"
---@class Mq
local mq = nil;

---@return Mq
function GenerateMQ()
    local _mq = {
        TLO = {
            Me = {}
        }
    }
    return _mq;
end

local status, module = pcall(require, "mq")
if status then
    -- if we're in macroquest load macroquest
    mq = module
else
    --otherwise we're obviously testing so let's mock it out
    mq = GenerateMQ()
    --Mock __mq stuff here
end


--TODO: Is there a better way than hard coding these values?
mq.MaxTemporaryBuffs = 31
mq.MaxBuffs = 42
mq.MaxMemorizedSpells = 18
mq.MaxNPCBuffs = 400

---Checks if the specified spawn ID is of the specified type
---@return boolean
---@param spawnSearch integer|string The Id to check
---@param type string The type the spawn should be
function mq.IsValidTarget(spawnSearch, type)
    local spawnToCheck = mq.TLO.Spawn(spawnSearch)
    if spawnToCheck() then
        if string.equals(type, "any") then
            return true
        end
        if string.equals(spawnToCheck.Type(), type) or
            spawnToCheck.Type() == "PET" and string.equals(spawnToCheck.Master.Type(), type) then
            return true
        end
    end
    return false
end

mq.CombatStates = {
    Unknown = 0,
    COMBAT = 1,
    DEBUFFED = 2,
    COOLDOWN = 3,
    ACTIVE = 4,
    RESTING = 5
}
mq.Classes = {
    Unknown = 0,
    Warrior = 1,
    Cleric = 2,
    Paladin = 3,
    Ranger = 4,
    ShadowKnight = 5,
    Druid = 6,
    Monk = 7,
    Bard = 8,
    Rogue = 9,
    Shaman = 10,
    Necromancer = 11,
    Wizard = 12,
    Mage = 13,
    Magician = 13,
    Enchanter = 14,
    Beastlord = 15,
    Berserker = 16,
    Banker = 40,
    Merchant = 41,
    TaskMerchant = 58,
    PvPMerchant = 59,
    Adventure = 60,
    AdventureMerchant = 61,
    Aura = 62,
    TributeMaster = 63,
    GuildTributeMaster = 64,
    GuildBanker = 66,
    GoodPointMerchant = 67,
    EvilPointMerchant = 68,
    FellowshipMaster = 69,
    PointMerchant = 70,
    MercenaryMerchant = 71,
    RealEstateMerchant = 72,
    LoyaltyMerchant = 73,
    TributeMaster2 = 74,
    CampFire = 253,
    Banner = 254,
    [0] = "Unknown",
    [1] = "Warrior",
    [2] = "Cleric",
    [3] = "Paladin",
    [4] = "Ranger",
    [5] = "ShadowKnight",
    [6] = "Druid",
    [7] = "Monk",
    [8] = "Bard",
    [9] = "Rogue",
    [10] = "Shaman",
    [11] = "Necromancer",
    [12] = "Wizard",
    [13] = "Magician",
    [14] = "Enchanter",
    [15] = "Beastlord",
    [16] = "Berserker",
    [40] = "Banker",
    [41] = "Merchant",
    [58] = "TaskMerchant",
    [59] = "PvPMerchant",
    [60] = "Adventure",
    [61] = "AdventureMerchant",
    [62] = "Aura",
    [63] = "TributeMaster",
    [64] = "GuildTributeMaster",
    [66] = "GuildBanker",
    [67] = "GoodPointMerchant",
    [68] = "EvilPointMerchant",
    [69] = "FellowshipMaster",
    [70] = "PointMerchant",
    [71] = "MercenaryMerchant",
    [72] = "RealEstateMerchant",
    [73] = "LoyaltyMerchant",
    [74] = "TributeMaster2",
    [253] = "CampFire",
    [254] = "Banner",
    WAR = 1,
    CLR = 2,
    PAL = 3,
    RNG = 4,
    SHD = 5,
    DRU = 6,
    MNK = 7,
    BRD = 8,
    ROG = 9,
    SHM = 10,
    NEC = 11,
    WIZ = 12,
    MAG = 13,
    ENC = 14,
    BST = 15,
    BER = 16,
}


---@class CastResult:number
---@class CastResults
---@field Success CastResult
---@field Started CastResult
---@field Collapsed CastResult
---@field NoLOS CastResult
---@field NoComponent CastResult
---@field Distracted CastResult
---@field Silenced CastResult
---@field Immune CastResult
---@field Interrupted CastResult
---@field Fizzled CastResult
---@field BadTarget CastResult
---@field NotReady CastResult
---@field NoMana CastResult
---@field OutOfRange CastResult
---@field OutDoors CastResult
---@field Resisted CastResult
---@field Standing CastResult
---@field Stunned CastResult
---@field Blocked CastResult
mq.CastResults = {
    Success = 0,
    Started = 1,
    Collapsed = 2,
    NoLOS = 3,
    NoComponent = 4,
    Distracted = 5,
    Silenced = 6,
    Immune = 7,
    Interrupted = 8,
    Fizzled = 9,
    BadTarget = 10,
    NotReady = 11,
    NoMana = 12,
    OutOfRange = 13,
    OutDoors = 14,
    Resisted = 15,
    Standing = 16,
    Stunned = 17,
    Blocked = 18,
    [0] = "Success",
    [1] = "Started",
    [2] = "Collapsed",
    [3] = "NoLOS",
    [4] = "NoComponent",
    [5] = "Distracted",
    [6] = "Silenced",
    [7] = "Immune",
    [8] = "Interrupted",
    [9] = "Fizzled",
    [10] = "BadTarget",
    [11] = "NotReady",
    [12] = "NoMana",
    [13] = "OutOfRange",
    [14] = "OutDoors",
    [15] = "Resisted",
    [16] = "Standing",
    [17] = "Stunned",
    [18] = "Blocked",
}

---@param windowName string
---@param buttonName string
---@param leftOrRight string @left|right
function mq.ClickUIButton(windowName, buttonName, leftOrRight)
    local window = mq.TLO.Window(windowName)
    local button = window.Child(buttonName)
    if window.Open() then
        if string.equals(leftOrRight, "left") then
            button.LeftMouseUp()
        else
            button.RightMouseUp()
        end
    end
end

---@param windowName string
---@param dropDownName string
---@param valueToSelect string
function mq.SelectListItem(windowName, dropDownName, valueToSelect)
    ---@type MQWindow
    local dropdown = mq.TLO.Window(windowName).Child(dropDownName)
    ---@type string
    local optionToSelect = dropdown.List(valueToSelect)()
    if optionToSelect and dropdown.GetCurSel() ~= optionToSelect then
        dropdown.Select(optionToSelect)
    end
end

---Is the character in the correct position relative to the provided spawn
---@param spawn spawn
---@param position Range
---@return boolean
function mq.InPosition(spawn, position)
    --TODO: make this work
    return true
end

---Gets x,y,z coordinates for the provided spawn that is within the provided arc
---@param spawn spawn
---@param arcRange? Range
---@param distanceRange? Range
---@return Coordinates|nil
function mq.GetPointInArc(spawn, arcRange, distanceRange)
    if not arcRange then
        arcRange = mq.Positioning.Any
    end
    if not distanceRange then
        distanceRange = { Min = 1, Max = spawn.MaxRangeTo() }
    end
    if spawn then
        local x, y = math.PointInArc(spawn.X(), spawn.Y(), spawn.Heading.Degrees(), distanceRange.Min, distanceRange.Max,
            arcRange.Min, arcRange.Max)
        return { X = x, Y = y, Z = spawn.Z() }
    end
    return nil
end

---@type ArcValues
mq.Positioning = {
    Front = {
        Min = -10,
        Max = 10
    },
    NotFront = {
        Min = 60,
        Max = 300
    },
    Left = {
        Min = 240,
        Max = 300
    },
    Right = {
        Min = 60,
        Max = 120
    },
    Behind = {
        Min = 150,
        Max = 210
    },
    Any = {
        Min = 0,
        Max = 359
    }
}

--Write Code shamelessly stolen from Knightly
--https://gitlab.com/Knightly1/knightlinc/-/blob/master/Write.lua

---@param logLevel LogLevel
local function GetCallerString(logLevel)
    if logLevel.Level > mq.Write.CallStringLevel then
        return ''
    end

    local callString = 'unknown'
    local callerInfo = debug.getinfo(4, 'Sl')
    if callerInfo and callerInfo.short_src ~= nil and callerInfo.short_src ~= '=[C]' then
        callString = string.format('%s @%s', callerInfo.short_src:match("[^\\^/]*.lua$"), callerInfo.currentline)
    end
    return string.format('(%s) ', callString)
end

---@class Write
mq.Write = {
    UseColors = false,
    ---@type LogLevels
    LogLevels = {
        ---@type LogLevel
        Trace = { Level = 1, MQColor = "\at", Abbreviation = "[TRACE]" },
        ---@type LogLevel
        Debug = { Level = 2, MQColor = "\am", Abbreviation = "[DEBUG]" },
        ---@type LogLevel
        Info  = { Level = 3, MQColor = "\ag", Abbreviation = "[INFO]" },
        ---@type LogLevel
        Warn  = { Level = 4, MQColor = "\ay", Abbreviation = "[WARN]" },
        ---@type LogLevel
        Error = { Level = 5, MQColor = "\ao", Abbreviation = "[ERROR]" },
        ---@type LogLevel
        Fatal = { Level = 6, MQColor = "\ar", Abbreviation = "[FATAL]" },
        ---@type LogLevel
        Help  = { Level = 7, MQColor = "\aw", Abbreviation = "[HELP]" }
    },
    ---@type function|string
    Prefix = "",
    CallStringLevel = 0,
    Separator = "::",
    Trace = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Trace, message, ...)
    end,
    Debug = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Debug, message, ...)
    end,
    Info = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Info, message, ...)
    end,
    Warn = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Warn, message, ...)
    end,
    Error = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Error, message, ...)
    end,
    Fatal = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Fatal, message, ...)
    end,
    Help = function(message, ...)
        mq.Write.Output(mq.Write.LogLevels.Help, message, ...)
    end,
    Output = function(logLevel, message, ...)
        if logLevel.Level < mq.Write.MinimumLevel.Level then
            return
        end
        local inputMessage = string.format(message, ...)
        print(string.format('%s%s %s%s%s%s %s',
            logLevel.MQColor,
            type(mq.Write.Prefix) == 'function' and mq.Write.Prefix() or mq.Write.Prefix,
            logLevel.Abbreviation,
            "\ax",
            mq.Write.Separator,
            inputMessage,
            GetCallerString(logLevel)))
    end
}
mq.Write.MinimumLevel = mq.Write.LogLevels.Debug
return mq
