local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local conditions = require "libs.behavior.conditions"

local me = mq.TLO.Me

---@class MemorizeSpellNodeArgs : NodeArgs
---@field name string @Name of the MemorizeSpellAction node.
---@field spellGemKey string @Key to extract the spell gem slot from the blackboard.
---@field spellIdKey string @Key to extract the spell ID from the blackboard.

---@class MemorizeSpellNode:Node
---@field memStarted boolean @Flag indicating if memorization has started.
---@field memWaitTimer number @Timer for tracking how long the node has been waiting for memorization to complete.
---@field spellGem integer @The gem slot to which the spell will be memorized.
---@field spellId integer @The ID of the spell to be memorized.
---@field Args MemorizeSpellNodeArgs
local MemorizeSpellNode = {}
setmetatable(MemorizeSpellNode, { __index = Node }) -- Inherit from Node


--- Constructor for MemorizeSpell.
---@param args MemorizeSpellNodeArgs @Table containing the arguments for the node.
---@return MemorizeSpellNode @The created MemorizeSpell instance
function MemorizeSpellNode.new(args)
    ---@class MemorizeSpellNode:Node
    local self = setmetatable(Node.new(args), { __index = MemorizeSpellNode }) -- Set MemorizeSpellNode as its metatable
    self.NodeType = "MemorizeSpellNode"
    self.memStarted = false
    self.memWaitTimer = 0
    mq.Write.Trace("%s: Creating MemorizeSpellNode with spellGemKey '%s' and spellIdKey '%s'", args.name,
        args.spellGemKey, args.spellIdKey)
    return self
end

function MemorizeSpellNode:_OnInitialize(blackboard)
    mq.Write.Trace("%s: Initializing MemorizeSpellNode", self.Name)
    self.memStarted = false
    self.memWaitTimer = 0
    self.spellGem = blackboard[self.Args.spellGemKey]
    self.spellId = blackboard[self.Args.spellIdKey]

    local spellName = mq.TLO.Spell(self.spellId).Name()
    if not mq.TLO.Me.Book(spellName).ID() then
        mq.Write.Error("%s: Spell '%s' (ID: %s) not found in spellbook", self.Name, spellName, self.spellId)
        return NodeState.Invalid
    end

    mq.Write.Debug("%s: Initialized with spell '%s' (ID: %s) to memorize in gem slot %s", self.Name, spellName,
        self.spellId, self.spellGem)
end

function MemorizeSpellNode:_Update(blackboard)
    local spell = mq.TLO.Spell(self.spellId)

    if me.Gem(spell.Name())() == self.spellGem then
        mq.Write.Debug("%s: Spell '%s' already memorized in gem %s", self.Name, spell.Name(), self.spellGem)
        return NodeState.Success
    end

    if conditions.spellMemorizing() then
        mq.Write.Debug("%s: Currently memorizing a spell. Waiting...", self.Name)
        return NodeState.Running
    end

    if self.memStarted and self.memWaitTimer < 1500 then
        self.memWaitTimer = self.memWaitTimer + blackboard.deltaTime
        mq.Write.Debug("%s: Waiting for spell '%s' memorization, timer at %d ms", self.Name, spell.Name(),
            self.memWaitTimer)
        return NodeState.Running
    end

    mq.cmdf('/memspell %d "%s"', self.spellGem, spell.Name())
    self.memStarted = true
    self.memWaitTimer = 0
    mq.Write.Debug("%s: Issued command to memorize spell '%s' in gem slot %s", self.Name, spell.Name(), self.spellGem)
    return NodeState.Running
end

return MemorizeSpellNode
