--ValueLookups.lua
local mq = require "libs.Helpers.MacroQuestHelpers"
local ValueLookups = {
    MyHealth = function()
        return mq.TLO.Me.PctHPs()
    end,
    AverageGroupHealth = function()
        local runningHealth = 0
        local groupMembers = mq.TLO.Group.Members() + 1
        local presentGroupCount = 0
        for i = 0, groupMembers, 1 do
            local currentMember = mq.TLO.Group.Member(i)
            if (currentMember() and currentMember.Present()) then
                runningHealth = runningHealth + currentMember.PctHPs()
                presentGroupCount = presentGroupCount + 1
            end
        end
        return runningHealth / presentGroupCount
    end,
    Grouped = function()
        if (mq.TLO.Me.Grouped()) then
            return 1
        else
            return 0
        end
    end,
    GroupMembers = function()
        return mq.TLO.Group.Members()
    end
}
return ValueLookups
