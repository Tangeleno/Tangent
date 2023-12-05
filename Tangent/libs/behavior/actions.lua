local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local conditions = require "libs.behavior.conditions"
---@type table<string, fun(nodeBlackboard:table,blackboard:table,...):NodeState>
local actions = {
    sit = function(nodeBlackboard, blackboard, ...)
        if mq.TLO.Me.Sitting() then
            return NodeState.Success
        elseif mq.TLO.Me.Standing() then
            if nodeBlackboard.sitStarted and nodeBlackboard.sitTimer <= 500 then
                nodeBlackboard.sitTimer = nodeBlackboard.sitTimer + blackboard.deltaTime
            else
                mq.TLO.Me.Sit()
                nodeBlackboard.sitStarted = true
                nodeBlackboard.sitTimer = 0
            end
            return NodeState.Running
        end
        return NodeState.Failure
    end,
    target = function(nodeBlackboard, blackboard, targetId, targetType)
        targetType = targetType or 'any'
        if mq.TLO.Target.ID() == targetId then
            return NodeState.Success
        end
        if mq.IsValidTarget(targetId, targetType) then
            if nodeBlackboard.targetStarted and nodeBlackboard.targetTimer <= 500 then
                nodeBlackboard.targetTimer = nodeBlackboard.targetTimer + blackboard.deltaTime
            else
                mq.TLO.Spawn(targetId).DoTarget()
                nodeBlackboard.targetStarted = true
                nodeBlackboard.targetTimer = 0
            end
            return NodeState.Running
        end
        return NodeState.Failure
    end,
    memspell = function(nodeBlackboard, blackboard, spellGem, spellId)
        local spell = mq.TLO.Spell(spellId)
        local me = mq.TLO.Me
        if not me.Book(spell.Name()) then
            mq.Write.Error("Attempted to memorize spell %s, this spell is not in our spellbook", spell.Name())
            return NodeState.Aborted
        end
        if me.Gem(spell.Name()) == spellGem then
            mq.Write.Debug("Spell memorized")
            return NodeState.Success
        end
        if conditions.spellMemorizing() then
            mq.Write.Debug("Spell being memorized")
            return NodeState.Success
        end

        if nodeBlackboard.memStarted and nodeBlackboard.memWaitTimer < 1500 then
            mq.Write.Debug("Waiting for spell to start memorizing")
            --add the current time since last tick to our timer
            nodeBlackboard.memWaitTimer = nodeBlackboard.memWaitTimer + blackboard.deltaTime
            return NodeState.Running
        end
        --we either haven't started memming the spell, or we've waited half a second and it still isn't memming
        mq.Write.Debug("Starting to mem spell")
        mq.cmdf('/memspell %d "%s"', spellGem, spell.Name())
        nodeBlackboard.memStarted = true
        nodeBlackboard.memWaitTimer = 0
        return NodeState.Running
    end
}
return actions
