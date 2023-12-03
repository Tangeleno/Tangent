local mq = require "libs.Helpers.MacroQuestHelpers"
local ValueLookups = {
    MyHealth = function()
        return mq.TLO.Me.PctHPs()
    end,
    AverageGroupHealth = function()
        local runningHealth
    end
}
return ValueLookups