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
    end
}
return conditions
