-- basegoals.lua
local Goal = require "libs.goap.goal"
local SitAction = require "libs.goap.Actions.SitAction"

--- Default priority function
local getPriority = function() return 10 end

---@class BaseGoals
local BaseGoals = {}

--- Prepares the base goal for combat.
---@param getPriorityFunc nil|fun(state: State): number Function to calculate priority based on state
---@param conditionMetFunc fun(state: State): boolean Function to determine if the goal's condition is met based on state
---@param calculateDistanceFunc fun(state: State): number Function to calculate the distance to achieving the goal based on state
---@return Goal The prepared combat goal
function BaseGoals.PrepareForCombat(getPriorityFunc, conditionMetFunc, calculateDistanceFunc)
    ---@param state State
    ---@return boolean
    local function conditionMet(state)
        return state.XTHaterCount <= 0 and conditionMetFunc(state)
    end

    ---@param state State
    ---@return number
    local function calculateGoalDistance(state)
        local distance = calculateDistanceFunc(state)
        if state.Standing then
            distance = distance + 1
        end
        return distance
    end

    getPriorityFunc = getPriorityFunc or getPriority
    local goal = Goal:new("PrepareForCombat", getPriorityFunc, conditionMet, calculateGoalDistance)
    goal:addAction(SitAction:new())
    return goal
end

return BaseGoals
