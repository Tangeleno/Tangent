local mq = require "libs.Helpers.MacroQuestHelpers"
local rapidjson = require('rapidjson')
local socket = require('socket')
local RenderableTab = require "libs.Gui.RenderableTab"
require "libs.Gui.Window"


---@class ActionPlanner
---@field goals table<number, Goal> List of goals in the planner
---@field private actionPlan table<number,Action>
---@field private currentActionIndex number
---@field private currentGoal Goal
---@field private simulatedState StateClass
---@field private generatingPlan boolean
local ActionPlanner = {}
ActionPlanner.__index = ActionPlanner

--- Constructor for creating a new ActionPlanner
---@return ActionPlanner
function ActionPlanner:new()
    mq.Write.Trace("ActionPlanner:new - Creating new ActionPlanner")
    local obj = setmetatable({}, ActionPlanner)
    obj.goals = {}
    obj.actionPlan = {}
    obj.currentActionIndex = 1
    obj.currentGoal = nil
    obj.simulatedState = nil
    obj.generatingPlan = false
    -- Add to Window if it exists
    if Window then
        local plannerTab = setmetatable({}, { __index = RenderableTab })
        function plannerTab:render()
            obj:render() -- Call the render method of ActionPlanner
        end

        Window.AddTab("Action Planner", plannerTab:new("Action Planner"))
    end
    return obj
end

--- Adds a goal to the planner
---@param goal Goal The goal to be added
function ActionPlanner:addGoal(goal)
    mq.Write.Trace("ActionPlanner:addGoal - Adding goal: %s", goal.name)
    table.insert(self.goals, goal)
end

---comments
---@param state StateClass
---@return Goal|nil
function ActionPlanner:findGoal(state)
    mq.Write.Trace("Entering ActionPlanner:findGoal")
    local bestGoal = nil
    local bestGoalPriority = math.huge
    for _, goal in ipairs(self.goals) do
        if goal.conditionMet(state) then
            local goalPriority = goal.getPriority(state)
            if goalPriority < bestGoalPriority then
                --bestGoal may be nil
                bestGoal = goal
                bestGoalPriority = goalPriority
            end
        else
            mq.Write.Debug("Ignoring goal %s because it's condition hasn't been met", goal.name)
        end
    end
    return bestGoal
end

function ActionPlanner:setGoal(goal, state)
    mq.Write.Trace("Entering ActionPlanner:setGoal")
    if self.actionPlan[self.currentActionIndex] then
        self.actionPlan[self.currentActionIndex]:abortAction(state)
    end
    self.currentGoal = goal
    self.actionPlan = {}
    self.currentActionIndex = 1
    self.simulatedState = state
    self.generatingPlan = true
end

---comments
---@param state StateClass
---@return Action|nil,StateClass|nil
function ActionPlanner:findNextAction(state)
    mq.Write.Trace("Entering ActionPlanner:findNextAction")
    local bestAction = nil
    local bestActionImprovement = -math.huge -- Looking for the most significant improvement
    local initialDistance = self.currentGoal.calculateGoalDistance(state)
    local bestState = nil

    for _, possibleAction in ipairs(self.currentGoal.actions) do
        if possibleAction:conditionMet(state) then
            mq.Write.Debug("Calculating cost for action %s", possibleAction.name)
            local cost = possibleAction:calculateCost(state)
            possibleAction:applyEffects(state)
            local newDistance = self.currentGoal.calculateGoalDistance(state)
            local improvement = initialDistance - newDistance -
                cost -- Improvement is the reduction in distance minus the cost

            if improvement > bestActionImprovement then
                bestAction = possibleAction
                bestActionImprovement = improvement
                bestState = state:clone()
            end

            possibleAction:revertEffects(state)
        else
            mq.Write.Debug("Ignoring Action %s because it's condition hasn't been met", possibleAction.name)
        end
    end

    return bestAction, bestState
end

function ActionPlanner:updatePlanAndExecute(state)
    mq.Write.Trace("Entering ActionPlanner:updatePlanAndExecute")
    local recommendedGoal = self:findGoal(state)
    if recommendedGoal == nil or self.currentGoal ~= recommendedGoal or self.currentActionIndex > #self.actionPlan and not self.generatingPlan then
        --goal is different than the current goal, or we didn't find a goal, or we need to restart the goal
        --so we clear everything
        self:setGoal(recommendedGoal, state)
    end

    --if the current goal is nil return
    if not self.currentGoal then
        return
    end

    self:generatePlan(state)
    self:executeAction(state)
end

---@param state StateClass
function ActionPlanner:executeAction(state)
    mq.Write.Trace("Entering ActionPlanner:executeAction")
    local currentAction = self.actionPlan[self.currentActionIndex]
    if currentAction then
        if currentAction:isActionStarted() then
            currentAction:updateAction(state)
        else
            currentAction:startAction(state)
        end
        if currentAction:isActionComplete() then
            currentAction:onActionComplete(state)
            self.currentActionIndex = self.currentActionIndex + 1
        end
    end
end

---@param state StateClass
function ActionPlanner:generatePlan(state)
    local currentAction = self.actionPlan[self.currentActionIndex]
    mq.Write.Trace("Entering ActionPlanner:generatePlan")
    if self.actionPlan[self.currentActionIndex] then
        mq.Write.Debug("The current action is %s", self.actionPlan[self.currentActionIndex].name)
    end

    --first we need to check if the current action is still the best action
    local betterAction, betterState = self:findNextAction(state)
    if betterAction and betterAction ~= currentAction and (currentAction and not currentAction:isActionStarted()) then
        --we have a better action plan
        --so we need to clear out all the other actions
        for i = #self.actionPlan, self.currentActionIndex, -1 do
            table.remove(self.actionPlan, i)
        end
        --we've removed the current and all planned steps, now we set the current step to the betterAction, and set the simulated state
        table.insert(self.actionPlan, betterAction)
        self.simulatedState = betterState
    else
        mq.Write.Debug("No better action found better action is %s current action is %s",betterAction and betterAction.name or "nil",currentAction and currentAction.name or "nil")
    end

    if self.generatingPlan then
        --we have a goal, now we need to work on generating the action plan. We will give 1ms to generate the plan
        local planningStartTime = socket.gettime()
        local nextAction, simulatedState = self:findNextAction(self.simulatedState)
        if nextAction ~= nil then
            table.insert(self.actionPlan, nextAction)
            self.simulatedState = simulatedState
        end
        while socket.gettime() - planningStartTime > 0.001 and self.generatingPlan do
            nextAction, simulatedState = self:findNextAction(self.simulatedState)
            if nextAction ~= nil then
                table.insert(self.actionPlan, nextAction)
                self.simulatedState = simulatedState
            else
                self.generatingPlan = false
            end
        end
    end

    --TODO: REMOVE THIS
    -- mq.Write.Trace("The current action plan is:")
    -- for index, action in ipairs(self.actionPlan) do
    --     mq.Write.Trace("\t %d: %s", index, action.name)
    -- end
end

function ActionPlanner:render()
    -- Render the currently selected goal and action plan
    if self.currentGoal then
        ImGui.Text("Current Goal: " .. self.currentGoal.name)

        -- Render the current action plan
        ImGui.Text("Action Plan:")
        for i, action in ipairs(self.actionPlan) do
            if action then
                if i == self.currentActionIndex then
                    -- Highlight the current action
                    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 0, 1)
                    ImGui.Text(action.name .. " (current)")
                    ImGui.PopStyleColor()
                else
                    ImGui.Text(action.name)
                end
            end
        end
    else
        ImGui.Text("No Goal")
    end

    -- Render all goals and their actions
    if ImGui.CollapsingHeader("Goals") then
        for _, goal in ipairs(self.goals) do
            if ImGui.Selectable(goal.name, self.selectedGoal == goal) then
                self.selectedGoal = goal
            end
            if self.selectedGoal == goal then
                ImGui.Indent()
                for _, action in ipairs(goal.actions) do
                    ImGui.BulletText(action.name)
                end
                ImGui.Unindent()
            end
        end
    end
end

return ActionPlanner
