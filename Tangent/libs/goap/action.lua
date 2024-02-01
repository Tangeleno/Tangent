local mq = require "libs.Helpers.MacroQuestHelpers"
local BehaviorTreeRepository = require "libs.behavior.BehaviorTreeRepository"

--TODO: in the future pull these from redis and have default values
--The ML algorithms will store the values in redis for use by the various GOAPs
--cast time needs to account for milliseconds
local castTimeCostFactor = 5
local cooldownCostFactor = 300
local resourceCostFactor = 500
local maxExpectedCastTimeMilliseconds = 10000
local maxExpectedCooldown = 3600
local resourceWeight = 1.0
local timeWeight = 1.0
local cooldownWeight = 1.0
local opportunityWeight = 1.0

---@class Action
---@field name string
---@field protected behaviorTree BehaviorTree|nil
---@field protected actionStarted boolean
---@field protected maxExpectedCastTimeMilliseconds number
---@field protected maxExpectedCooldown number
---@field protected castTimeCostFactor number
---@field protected cooldownCostFactor number
---@field protected resourceCostFactor number
---@field value number
local Action = {}
Action.__index = Action

--- Constructor for creating a new Action
---@param name string Name of the action
---@param treeName string Name of the behavior tree
---@param treeJson string JSON definition of the behavior tree (optional if already loaded)
---@return Action
function Action:new(name, treeName, treeJson)
    mq.Write.Trace("Action:new - Creating new Action: %s", name)
    local obj = setmetatable({}, Action)
    obj.name = name
    obj.actionStarted = false
    obj.value = 0
    obj.behaviorTree = BehaviorTreeRepository.getTree(treeName)
    --TODO: Tweak these as needed they need to also account for millisecond time usage
    obj.castTimeCostFactor = castTimeCostFactor
    obj.cooldownCostFactor = cooldownCostFactor
    obj.resourceCostFactor = resourceCostFactor
    obj.maxExpectedCastTimeMilliseconds = maxExpectedCastTimeMilliseconds
    obj.maxExpectedCooldown = maxExpectedCooldown
    if not obj.behaviorTree and treeJson then
        mq.Write.Debug("Action:new - Loading behavior tree: %s", treeName)
        BehaviorTreeRepository.loadTree(treeName, treeJson)
        obj.behaviorTree = BehaviorTreeRepository.getTree(treeName)
    end
    return obj
end

function Action:calculateOpportunityCost(state)
    --TODO: implement this if needed
    return 1
end

---Calculates the cost to perform this action
---@param resourceUsed number
---@param totalResource number
---@param castTimeMilliseconds number
---@param cooldown number
---@param state table
---@return number
function Action:doCalculateCost(resourceUsed, totalResource, castTimeMilliseconds, cooldown,state)
    --prevent divide by 0
    totalResource = totalResource or 1
    local resourceCost = (resourceUsed / totalResource) * self.resourceCostFactor
    local timeCost = (castTimeMilliseconds / self.maxExpectedCastTimeMilliseconds) * self.castTimeCostFactor
    local cooldownCost = (cooldown / self.maxExpectedCooldown) * self.cooldownCostFactor
    --TODO:Implement opportunity cost in the future if it's needed.
    -- Opportunity cost can be more complex and might need dynamic evaluation
    local opportunityCost = self:calculateOpportunityCost( state)

    local totalCost = resourceWeight * resourceCost +
        timeWeight * timeCost +
        cooldownWeight * cooldownCost +
        opportunityWeight * opportunityCost
        mq.Write.Trace("Calculated cost for action %s. Cost: %f",self.name,totalCost)
    return totalCost
end
---comment
---@param state StateClass
---@return number
function Action:calculateCost(state)
    error("Action:calcuateCost has not been implemented")
end


--- Function to start the action
---@param state StateClass
function Action:startAction(state)
    mq.Write.Trace("Action:startAction - Starting action: %s", self.name)
    if self.behaviorTree then
        self.actionStarted = true
        self.behaviorTree:Abort(state)
        self.behaviorTree:Tick(state)
    end
end

--- Function to abort the action
---@param state StateClass
function Action:abortAction(state)
    mq.Write.Trace("Action:abortAction - Aborting action: %s", self.name)
    if self.behaviorTree then
        self.actionStarted = false;
        self.behaviorTree:Abort(state)
    end
end

--- Function to update the action each tick or frame
---@param state StateClass
function Action:updateAction(state)
    mq.Write.Trace("Action:updateAction - Updating action: %s", self.name)
    if self.behaviorTree then
        if not self.behaviorTree:IsTerminated() then
            self.behaviorTree:Tick(state)
        else
            self:onActionComplete(state)
            self.actionStarted = false
        end
    end
end

--- Function to check if the action is complete
---@return boolean
function Action:isActionComplete()
    mq.Write.Trace("Action:isActionComplete - Checking if action %s is complete", self.name)
    return self.behaviorTree and self.behaviorTree:IsTerminated()
end

--- Function to check if the action is complete
---@return boolean
function Action:isActionStarted()
    mq.Write.Trace("Action:isActionStarted - Checking if action %s is started", self.name)
    return self.actionStarted
end

--- Function to execute when the action is complete
---@param state StateClass
function Action:onActionComplete(state)
    -- Default implementation (override in subclasses)
end

--- Function to check if the action's prerequisites are met
---@param state StateClass
---@return boolean
function Action:conditionMet(state)
    mq.Write.Error("Action:conditionMet - Method not implemented")
    return true
end

--- Function to simulate the effects of the action on the state
---@param state StateClass
function Action:applyEffects(state)
    mq.Write.Error("Action:applyEffects - Method not implemented")
    -- Default implementation (override in subclasses)
    -- This should modify the state as if the action has been executed
end


--- Function to undo the simulation the effects of the action on the state
---@param state StateClass
function Action:revertEffects(state)
    mq.Write.Error("Action:revertEffects - Method not implemented")
    -- Default implementation (override in subclasses)
    -- This should modify the state as if the action has been executed
end

return Action
