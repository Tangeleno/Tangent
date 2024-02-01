--RoleGoals.lua
local Goal = require "libs.goap.goal"
local mq = require "libs.Helpers.MacroQuestHelpers"
local BaseGoals = require "libs.goap.Goals.BaseGoals"
local MoveToEngageAction = require "libs.goap.Actions.MoveToEngageAction"
local TargetForCombatAction = require "libs.goap.Actions.TargetForCombatAction"
local RoleGoals = {}
---@param conditionMetFunc fun(state: StateClass): boolean Function to determine if the goal's condition is met based on state
---@param calculateDistanceFunc fun(state: StateClass): number Function to calculate the distance to achieving the goal based on state
function RoleGoals.MeleePrepareForCombat(conditionMetFunc, calculateDistanceFunc)
    ---@param state StateClass
    ---@return boolean
    local function conditionMet(state)
        return conditionMetFunc(state)
    end
    ---@param state StateClass
    ---@return number
    local function calculateDistance(state)
        local distance = calculateDistanceFunc(state)
        return distance
    end
    local goal = BaseGoals.PrepareForCombat(nil, conditionMet, calculateDistance)
    -- Add melee-specific actions
    return goal
end

--- Prepares the base goal for combat.
---@param getPriorityFunc nil|fun(state: StateClass): number Function to calculate priority based on state
---@param conditionMetFunc fun(state: StateClass): boolean Function to determine if the goal's condition is met based on state
---@param calculateDistanceFunc fun(state: StateClass): number Function to calculate the distance to achieving the goal based on state
---@return Goal The prepared combat goal
function RoleGoals.MeleeEnemy(getPriorityFunc, conditionMetFunc, calculateDistanceFunc)
    ---@param state StateClass
    ---@return boolean
    local function conditionMet(state)
        return state.EngageTargetId and mq.IsValidTarget(state.EngageTargetId, "NPC")
    end

    ---@param state StateClass
    ---@return number
    local function calculateGoalDistance(state)
        local distance = calculateDistanceFunc(state)
        if state.EngageTargetDistance > state.EngageTargetMaxRangeTo then
            distance = distance + 30
        end
        if state.TargetId ~= state.EngageTargetId then
            distance = distance + 50
        end
        if state.EngagedWith ~= state.EngageTargetId then
            distance = distance + 20
        end
        distance = distance + state.EngageTargetHealth
        return distance
    end

    getPriorityFunc = getPriorityFunc or function() return 10 end
    local goal = Goal:new("Melee Enemy", getPriorityFunc, conditionMet, calculateGoalDistance)
    goal:addAction(MoveToEngageAction:new())
    goal:addAction(TargetForCombatAction:new())
    return goal
end

return RoleGoals
