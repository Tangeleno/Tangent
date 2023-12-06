local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local conditions = require "libs.behavior.conditions"

---@class MemorizeSpellNode
local MemorizeSpellNode = {}
--- Constructor for MemorizeSpell.
---@param args table @Table containing the arguments for the node.
---   - name: string @Name of the MemorizeSpellAction node.
---   - spellGemKey: string @Key to extract the spell gem slot from the blackboard.
---   - spellIdKey: string @Key to extract the spell ID from the blackboard.
---@return MemorizeSpellNode @The created MemorizeSpell instance
function MemorizeSpellNode.new(args)
    mq.Write.Trace("Creating MemorizeSpellNode: %s", args.name)
    ---@class MemorizeSpellNode:Node
    local self = Node.new(args.name)
    self.NodeType = "MemorizeSpellNode"

    self.memStarted = false
    self.memWaitTimer = 0

    function self._OnInitialize(blackboard)
        mq.Write.Trace("Initializing MemorizeSpellNode: ", args.name)
        self.memStarted = false
        self.memWaitTimer = 0
        self.spellGem = blackboard[args.spellGemKey]
        self.spellId = blackboard[args.spellIdKey]
    end

    function self._Update(blackboard)
        mq.Write.Debug("%s : _Update called", args.name)
        local spell = mq.TLO.Spell(self.spellId)
        local me = mq.TLO.Me
        if not me.Book(spell.Name()) then
            mq.Write.Error("%s: Spell %s not in spellbook", args.name, spell.Name())
            return NodeState.Aborted
        end
        if me.Gem(spell.Name())() == self.spellGem then
            mq.Write.Debug("%s: Spell %s already in gem %s", args.name, spell.Name(), self.spellGem)
            return NodeState.Success
        end

        if conditions.spellMemorizing() then
            mq.Write.Debug("%s: Memorization started", args.name)
            return NodeState.Success
        end

        if self.memStarted and self.memWaitTimer < 1500 then
            self.memWaitTimer = self.memWaitTimer + blackboard.deltaTime
            mq.Write.Debug("%s: Waiting for spell memorization, timer at %d", args.name, tostring(self.memWaitTimer))
            return NodeState.Running
        end

        mq.cmdf('/memspell %d "%s"', self.spellGem, spell.Name())
        self.memStarted = true
        self.memWaitTimer = 0
        mq.Write.Debug("%s: Started memorizing spell %s in gem %s", args.name, spell.Name(), self.spellGem)
        return NodeState.Running
    end

    return self
end

return MemorizeSpell
