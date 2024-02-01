local mq = require "libs.Helpers.MacroQuestHelpers"
---@type table<string, fun(...):boolean>
---@type character
---@diagnostic disable-next-line: assign-type-mismatch
local me = mq.TLO.Me
local target = mq.TLO.Target
local conditions = {
    standing = function()
        return me.Standing() == false
    end,
    isValidTarget = function(targetId, targetType)
        return mq.IsValidTarget(targetId, targetType)
    end,
    haveCorrectTarget = function(targetId)
        mq.Write.Debug("Checking if %s == %s", mq.TLO.Target.ID(), targetId)
        return target.ID() == targetId
    end,
    spellMemorized = function(spellId)
        return me.Gem(mq.TLO.Spell(spellId).RankName())() ~= nil
    end,
    spellMemorizing = function()
        local bookWindow = mq.TLO.Window("SpellBookWnd")
        return bookWindow.Open() and bookWindow.Child("SBW_Memorize_Gauge").Value() ~= 0
    end,
    hasAbility = function(abilityName)
        return me.Skill(abilityName)() >= 1
    end,
    isSneaking = function()
        return me.Sneaking()
    end,
    isHiding = function()
        return me.Invis() and not me.AbilityReady("Hide")() and me.Skill("Hide")() > 0
    end
}
return conditions
