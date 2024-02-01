local BehaviorTree = require "libs.behavior.behaviorTree"

local BehaviorTreeRepository = {}
local trees = {} -- Store for behavior trees

-- Loads a behavior tree from JSON data
function BehaviorTreeRepository.loadTree(name, json)
    if type(name) ~= "string" or name == "" then
        error("Invalid name for behavior tree")
    end

    local tree, err = BehaviorTree.new(json)
    if not tree then
        error("Failed to load behavior tree: " .. (err or "Unknown error"))
    end

    trees[name] = tree
end

-- Retrieves a behavior tree by name
---comment
---@param name string
---@return BehaviorTree|nil
function BehaviorTreeRepository.getTree(name)
    if type(name) ~= "string" or not trees[name] then
        return nil
    end
    return trees[name]
end

return BehaviorTreeRepository
