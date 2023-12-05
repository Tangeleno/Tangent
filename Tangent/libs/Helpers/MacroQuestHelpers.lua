

require "libs.Helpers.StringFunctions"
require "libs.Helpers.MathFunctions"
---@class Mq
local mq = nil;

---@return Mq
function GenerateMQ()
    local _mq = {
        TLO = {
            Me={}
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
---@param position ArcValue
---@return boolean
function mq.InPosition(spawn, position)
    --TODO: make this work
    return true
end

---@class ArcValue
---@field MinArc number
---@field MaxArc number

---@class ArcValues
---@field Front ArcValue
---@field NotFront ArcValue
---@field Left ArcValue
---@field Right ArcValue
---@field Behind ArcValue
---@field Any ArcValue
mq.Positioning = {}
mq.Positioning.Front = {
    MinArc = -10,
    MaxArc = 10
}
mq.Positioning.NotFront = {
    MinArc = 60,
    MaxArc = 300
}
mq.Positioning.Left = {
    MinArc = 240,
    MaxArc = 300
}
mq.Positioning.Right = {
    MinArc = 60,
    MaxArc = 120
}
mq.Positioning.Behind = {
    MinArc = 150,
    MaxArc = 210
}
mq.Positioning.Any = {
    MinArc = 0,
    MaxArc = 360
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

---@class LogLevel
---@field Level number
---@field MQColor string
---@field Abbreviation string

---@class LogLevels
---@field Trace LogLevel
---@field Debug LogLevel
---@field Info LogLevel
---@field Warn LogLevel
---@field Error LogLevel
---@field Fatal LogLevel
---@field Help LogLevel

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
