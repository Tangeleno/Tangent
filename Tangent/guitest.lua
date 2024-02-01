local mq = require "libs.Helpers.MacroQuestHelpers"

require "libs.Gui.Window"
local ActionPlanner = require "libs.goap.actionplanner"
local ClassGoals = require "libs.goap.Goals.ClassGoals"
-- Assuming you already have an instance of the action planner
local actionPlanner = ActionPlanner:new()
local State = require "libs.State"
local state = State:new()
state:update()
state:addUI()
print("")
print("")
print("")
print("")
print("")
print("")
print("")
--TODO: have this pull based on class
for goalName, goal in pairs(ClassGoals.Rogue) do
    if type(goal) == "function" then
        printf("Adding Goal %s",goalName)
        actionPlanner:addGoal(goal())
    end
end


Window.initialize("Tangent")
mq.Write.MinimumLevel = mq.Write.LogLevels.Trace
while Window.IsOpen() do
    mq.Write.Debug("Tick")
    mq.delay(1000)
    state:update()
    mq.Write.Debug("state is %s",state:encode())
    actionPlanner:updatePlanAndExecute(state)
end