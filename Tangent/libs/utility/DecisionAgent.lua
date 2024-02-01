--decisionAgent.lua
--[[ JSON Sample
[
    {
        "name": "Eat",
        "parameter": "hunger",
        "curve": "exponential",
        "scale": 1.0,
        "weight": 1.0,
        "normalize": true
    },
    {
        "name": "Heal",
        "parameter": "health",
        "curve": "quadratic",
        "scale": 1.0,
        "weight": 1.0,
        "normalize": true
    },
    {
        "name": "Composite",
        "curve": "logistic",
        "scale": 1.0,
        "weight": 1.0,
        "normalize": true,
        "aggregate": "AVERAGE",
        "childFunctions": [
            {
                "name": "Eat",
                "parameter": "hunger",
                "curve": "exponential",
                "scale": 1.0,
                "weight": 1.0,
                "normalize": true
            },
            {
                "name": "Heal",
                "parameter": "health",
                "curve": "quadratic",
                "scale": 1.0,
                "weight": 1.0,
                "normalize": true
            }
        ]
    }
]
]]

local cjson = require "rapidjson"

local UtilityFunction = require "libs.utility.UtilityFunction"

--- @class DecisionAgent
--- @field public utilityFunctions UtilityFunction[] The utility functions managed by the decision agent.
local DecisionAgent = {}
DecisionAgent.__index = DecisionAgent

--- DecisionAgent constructor.
--- @param jsonFile string? The path to the JSON file containing utility function definitions.
--- @return DecisionAgent The created decision agent.
function DecisionAgent.create(jsonFile)
    local agent = {}
    setmetatable(agent, DecisionAgent)
    agent.utilityFunctions = {}
    if jsonFile then agent:loadUtilityFunctions(jsonFile) end -- Load utility functions from file if provided
    return agent
end

--- Add a utility function to the agent.
--- @param uf UtilityFunction The utility function to add.
function DecisionAgent:addUtilityFunction(uf)
    table.insert(self.utilityFunctions, uf)
end

--- Load utility functions from a JSON file.
--- @param jsonFile string The path to the JSON file containing utility function definitions.
function DecisionAgent:loadUtilityFunctions(jsonFile)
    local function loadFunctions()
        local function loadJSON()
            local file, err = io.open(jsonFile, "r")
            if not file then
                error("Failed to open file: " .. err)
            end
            local content = file:read("*all")
            file:close()
            local utilityDefinitions = cjson.decode(content)

            local utilityFunctions = {}
            for _, definition in ipairs(utilityDefinitions) do
                local childFunctions = {}
                if definition.childFunctions then
                    for _, childDef in ipairs(definition.childFunctions) do
                        local childUf = UtilityFunction.create(childDef.name, childDef.parameter, childDef.curve,
                            childDef.scale, childDef.weight, childDef.normalize, childDef.childFunctions,
                            childDef.aggregate)
                        table.insert(childFunctions, childUf)
                    end
                end
                local uf = UtilityFunction.create(definition.name, definition.parameter, definition.curve,
                    definition.scale,
                    definition.weight, definition.normalize, childFunctions, definition.aggregate, definition.action)
                table.insert(utilityFunctions, uf)
            end

            return utilityFunctions
        end

        local success, result = pcall(loadJSON)
        if not success then
            error("Error loading utility functions: " .. result)
        end

        return result
    end
    -- Load utility functions as before
    self.utilityFunctions = loadFunctions()
end

--- Calculate utilities for all utility functions.
--- @return table<number>, number A table of utility values, and the total utility.
function DecisionAgent:calculateUtilities()
    local utilities = {}
    local totalUtility = 0

    for _, uf in ipairs(self.utilityFunctions) do
        local utility = uf:calculate()
        table.insert(utilities, utility)
        totalUtility = totalUtility + utility
    end

    return utilities, totalUtility
end

--- Make a decision based on the calculated utilities.
--- @return string The action associated with the best utility.
function DecisionAgent:makeDecision()
    local utilities, totalUtility = self:calculateUtilities()
    if totalUtility == 0 then
        totalUtility = 1e-6
    end
    local bestAction = ""
    local bestUtility = -math.huge

    for i, uf in ipairs(self.utilityFunctions) do
        local normalizedUtility = utilities[i] / totalUtility
        if normalizedUtility > bestUtility then
            bestUtility = normalizedUtility
            bestAction = uf.action
        end
    end

    return bestAction
end

return DecisionAgent
