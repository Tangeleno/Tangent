local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"

---@class AbilityNodeArgs : NodeArgs
---@field name string @Name of the Ability node.
---@field abilityNameKey string @Key to extract the parameter for the /doability command.
---@field abilityName string @The actual name of the ability if not pulling from the blackboard

---@class AbilityNode:Node
---@field Args AbilityNodeArgs
---@field skillName string @name of the skill to use
local AbilityNode = {}
setmetatable(AbilityNode, { __index = Node }) -- Inherit from Node

--- Constructor for Ability.
---@param args AbilityNodeArgs @Table containing the arguments for the node.
---@return AbilityNode @The created Sit instance
function AbilityNode.new(args)
    ---@class AbilityNode:Node
    local self = setmetatable(Node.new(args), { __index = AbilityNode }) -- Set AbilityNode as its metatable
    self.NodeType = "Ability"
    mq.Write.Trace("%s: Creating AbilityNode", args.name)
    return self
end

function AbilityNode:_OnInitialize(blackboard)
    mq.Write.Debug("%s: Initializing AbilityNode", self.Name)
    self.skillName = self.Args.abilityName or blackboard[self.Args.abilityNameKey] or nil
    mq.Write.Debug("Skill set to %s. AbilityName: %s abilityNameKey: %s",self.skillName,self.Args.abilityName,self.Args.abilityNameKey)
    if mq.TLO.Me.Skill(self.skillName)() < 1 then
        mq.Write.Error("%s: You do not possess the skill %s from blackboard key %s", self.Name,
            blackboard[self.Args.abilityNameKey], self.Args.abilityNameKey)
        return self.States.Invalid
    end
end

function AbilityNode:_Update(blackboard)
    if not mq.TLO.Me.AbilityReady(self.skillName) then
        mq.Write.Warn("Skill %s is not ready",self.skillName)
        return self.States.Failure
    end
    mq.cmdf('/doability "%s"', self.skillName)
    return self.States.Success
end

return AbilityNode
