--goaptest.lua
local mq = require "libs.Helpers.MacroQuestHelpers"
local ActionPlanner = require "libs.goap.actionplanner"
local ClassGoals = require "libs.goap.Goals.ClassGoals"
local State = require "libs.State"
require "libs.Gui.Window"
-- Define priority and condition functions for 'Prepare for Combat' goal
local state = State:new()
state:update()
state:addUI()
-- Assuming you already have an instance of the action planner
local actionPlanner = ActionPlanner:new()

--TODO: have this pull based on class
for _, method in pairs(ClassGoals.Rogue) do
    if type(method) == "function" then
        actionPlanner:addGoal(method())
    end
end

mq.Write.MinimumLevel = mq.Write.LogLevels.Trace
mq.Write.Trace("Starting the loop")
mq.Write.Debug("XTHaterCount is %s",state.XTHaterCount)
while true do
    --slow things down for testing
    mq.delay(500)
    state:update()
    mq.Write.Debug("Calling updatePlanAndExecute with %s state", state:encode())
    actionPlanner:updatePlanAndExecute(state)
end
