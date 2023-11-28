local mq = require "libs.Helpers.MacroQuestHelpers"
---@type table<string, fun(...):boolean>
local conditions = {
    ["standing"] = function()
        return mq.TLO.Me.Standing()
    end,
    ["isValidTarget"] = function(targetId, targetType)
        return mq.IsValidTarget(targetId, targetType)
    end,
    ["haveCorrectTarget"] = function(targetId)
        return mq.TLO.Target.ID() == targetId
    end,
    ["spellMemorized"] = function(spellId)
        return mq.TLO.Me.Gem(mq.TLO.Spell(spellId).RankName())() ~= nil
    end,
    ["spellMemorizing"] = function ()
        local bookWindow = mq.TLO.Window("SpellBookWnd")
        mq.Write.Debug("Spell memorizing condition: Book Open? %s Gauge Value %d == 0",bookWindow.Open(),bookWindow.Child("SBW_Memorize_Gauge").Value())
        return bookWindow.Open() and bookWindow.Child("SBW_Memorize_Gauge").Value() ~= 0
    end
}
return conditions
