---@class Goal
---@field name string
---@field getPriority fun(state: table): number
---@field actions table<int,Action>
---@field conditionMet fun(state: table): boolean
---@field calculateGoalDistance fun(state: table): number
local Goal = {}
Goal.__index = Goal

--- Constructor for creating a new Goal
---@param name string Name of the goal
---@param getPriority fun(state: table): number Function to calculate the goal's priority
---@param conditionMet fun(state: table): boolean Function to check if the goal's condition is met
---@param calculateGoalDistance fun(state: table): number Function to calculate the distance to achieving the goal
---@return Goal
function Goal:new(name, getPriority, conditionMet, calculateGoalDistance)
    local obj = setmetatable({}, Goal)
    obj.name = name
    obj.getPriority = getPriority
    obj.conditionMet = conditionMet or function(state) return true end
    obj.calculateGoalDistance = calculateGoalDistance or function(state) return 0 end
    obj.actions = {} -- Actions associated with this goal
    return obj
end

--- Adds an action to the goal
---@param action Action The action to be added to this goal
function Goal:addAction(action)
    table.insert(self.actions, action)
end

return Goal