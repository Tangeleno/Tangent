--utilityFunction.lua
local Curves = require "libs.utility.Curves"
local ValueLookups = require "libs.utility.ValueLookups"

--- @class UtilityFunction
--- @field public name string The name of the utility function.
--- @field public parameter string? The parameter used in the utility calculation.
--- @field public curve string The curve function to apply to the utility value.
--- @field public scale number The scaling factor for the utility value.
--- @field public weight number The weighting factor for the utility value.
--- @field public normalize boolean Whether to normalize the utility value.
--- @field public childFunctions table[] The child utility functions.
--- @field public aggregate string The aggregation method for child functions.
--- @field public action string The action associated with the utility function.
local UtilityFunction = {}
UtilityFunction.__index = UtilityFunction

UtilityFunction.aggregates = {
    SUM = function(childUtilities)
        local sum = 0
        for _, utility in ipairs(childUtilities) do sum = sum + utility end
        return sum
    end,
    AVERAGE = function(childUtilities)
        local sum = UtilityFunction.aggregates.SUM(childUtilities)
        return sum / #childUtilities
    end,
    PRODUCT = function(childUtilities)
        local product = 1
        for _, utility in ipairs(childUtilities) do product = product * utility end
        return product
    end,
    INVERSE = function(childUtilities)
        local product = 1
        for _, utility in ipairs(childUtilities) do product = product * utility end
        return 1 / product
    end
}

--- UtilityFunction constructor.
--- @param name string The name of the utility function.
--- @param parameter string? The parameter used in the utility calculation.
--- @param curve string The curve function to apply to the utility value.
--- @param scale number The scaling factor for the utility value.
--- @param weight number The weighting factor for the utility value.
--- @param normalize boolean Whether to normalize the utility value.
--- @param childFunctions table[] The child utility functions.
--- @param aggregate string The aggregation method for child functions.
--- @param action string? The action associated with the utility function.
--- @return UtilityFunction The created utility function.
function UtilityFunction.create(name, parameter, curve, scale, weight, normalize, childFunctions, aggregate, action)
    local uf = {}
    setmetatable(uf, UtilityFunction)
    uf.name = name
    uf.parameter = parameter
    uf.curve = curve or "linear"
    uf.scale = scale or 1.0
    uf.weight = weight or 1.0
    uf.normalize = (normalize == nil) and true or normalize
    uf.childFunctions = childFunctions or {} -- Child utility functions
    uf.aggregate = aggregate or "SUM"        -- Aggregate function
    uf.action = action                       -- Action to be taken
    return uf
end

--- Calculate the utility value.
--- @return number The calculated utility value.
function UtilityFunction:calculate()
    local paramValue = 0
    if self.parameter then
        local lookupFunction = ValueLookups[self.parameter]
        if lookupFunction == nil then
            print("Error: lookup " .. self.parameter .. " not found")
            return 0
        end
        paramValue = lookupFunction()
    end

    -- Calculate and normalize child functions
    local childUtilities = {}
    local sumChildUtilities = 0
    for _, child in ipairs(self.childFunctions) do
        local childUtility = child:calculate()
        table.insert(childUtilities, childUtility)
        sumChildUtilities = sumChildUtilities + childUtility
    end
    if sumChildUtilities ~= 0 then
        -- Normalize child utilities
        for i, utility in ipairs(childUtilities) do
            childUtilities[i] = utility / sumChildUtilities
        end
    end
    -- Aggregate child functions
    local aggregateFunction = UtilityFunction.aggregates[self.aggregate]
    local aggregateUtility = aggregateFunction(childUtilities)

    -- Combine the parameter value with the aggregate utility
    local totalValue = paramValue + aggregateUtility

    -- Apply curve, scale, and weight
    local curveFunction = Curves[self.curve]
    return curveFunction(totalValue) * self.scale * self.weight
end

return UtilityFunction