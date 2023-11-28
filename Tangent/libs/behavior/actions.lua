local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"

---@type table<string, fun(...):NodeState>
local actions = {
    ["sit"] = function(...)
        mq.TLO.Me.Sit()
        return NodeState.Success
    end,
    ["target"] = function(targetId)
        if mq.IsValidTarget(targetId, "any") then
            mq.TLO.Spawn(targetId).DoTarget()
            return NodeState.Success
        end
        return NodeState.Failure
    end,
    ["memspell"] = function(spellGem, spellId)
        local spell = mq.TLO.Spell(spellId)
        local me = mq.TLO.Me
        if not me.Book(spell.Name()) then
            mq.Write.Error("Attempted to memorize spell %s, this spell is not in our spellbook", spell.Name())
            return NodeState.Aborted
        end
        if me.Gem(spell.Name()) == spellGem then
            return NodeState.Success
        end
        mq.cmdf('/memspell %d "%s"', spellGem, spell.Name())
        return NodeState.Success
    end
}
return actions
