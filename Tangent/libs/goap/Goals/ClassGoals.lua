--classgoals.lua
local RoleGoals   = require "libs.goap.Goals.RoleGoals"
local HideAction  = require "libs.goap.Actions.HideAction"
local SneakAction = require "libs.goap.Actions.SneakAction"
local RogueEngageAction = require "libs.goap.Actions.RogueEngageAction"

local ClassGoals  = {}

local function True()
    return true
end


ClassGoals.Rogue = {
    prepareForCombat = function()
        ---@param state StateClass
        ---@return number
        local function calculateDistance(state)
            local distance = 0
            if (not state.Hidden) then
                distance = distance + 1
            end
            if (not state.Sneaking) then
                distance = distance + 1
            end
            return distance
        end

        ---@param state StateClass
        ---@return boolean
        local function conditionFunction(state)
            return state.XTHaterCount == 0 and not state.Hidden or not state.Sneaking or state.Standing
        end
        local goal = RoleGoals.MeleePrepareForCombat(conditionFunction, calculateDistance)
        goal:addAction(HideAction:new())
        goal:addAction(SneakAction:new())
        return goal
    end,
    meleeCombat = function()
        ---@param state StateClass
        ---@return number
        local function calculateDistance(state)
            local distance = 0
            if not state.Hidden then
                distance = distance + 5
            end
            if not state.Sneaking then
                distance = distance + 5
            end
            return distance
        end
        ---@param state StateClass
        ---@return number
        local function getPriority(state)
            return 3
        end
        ---@param state StateClass
        ---@return boolean
        local function condition(state)
            return mq.IsValidTarget(state.EngageTargetId, 'NPC') and not state.EngagedWith ~= state.EngageTargetId
        end
        local goal = RoleGoals.MeleeEnemy(getPriority, condition, calculateDistance)
        goal:addAction(RogueEngageAction:new())

        return goal
    end
}

return ClassGoals
