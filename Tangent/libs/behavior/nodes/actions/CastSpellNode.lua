local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"
local Node = require "libs.behavior.nodes.node"
local socket = require("socket")

---@class CastSpellNodeArgs : NodeArgs
---@field targetIdKey string @Key to extract the target ID from the blackboard.
---@field targetTypeKey string @Key to extract the target type from the blackboard.
---@field spellIdKey string @Key to extract the spell ID from the blackboard.
---@field spellTypeKey string @Key to extract the spell type from (Item,AA,Gem,Disc)
---@field spellResultKey string @Key to place the result of the spell (Success,Interrupt,Fizzle,Immune,etc)


---@class CastSpellNode
---@field targetId string @ID of the target extracted from the blackboard.
---@field targetType string @Type of the target (e.g., "any") extracted from the blackboard.
---@field spellId string @ID of the spell extracted from the blackboard.
---@field spellType string @Type of the spell (e.g., "Item", "AA", "Gem", "Disc") extracted from the blackboard.
---@field spellResultKey string @Key for placing the result of the spell in the blackboard.
---@field cumulativeTime number @Total time since the last cast attempt
---@field attempts number @Number of attempts made to cast the spell.
---@field SpellFinished boolean @Indicates if the spell casting has finished.
---@field SpellSuccess boolean @Indicates if the spell was successfully cast.
---@field SpellResult CastResult @Result of the spell casting, using the mq.CastResults enumeration.
---@field Started boolean @Indicates if spell casting has started.
---@field eventList table @List of event identifiers that have been registered.

local CastSpellNode = {}

local eventMappings = {
    ["Your gate is too unstable, and collapses#*#"] = mq.CastResults.Collapsed,
    ["You cannot see your target#*#"] = mq.CastResults.NoLOS,
    ["You are missing some required components#*#"] = mq.CastResults.NoComponent,
    ["Your ability to use this item has been disabled because you do not have at least a gold membership#*#"] = mq
        .CastResults.NoComponent,
    ["You need to play a#*#instrument for this song#*#"] = mq.CastResults.NoComponent,
    ["You are too distracted to cast a spell now#*#"] = mq.CastResults.Distracted,
    ["You can't cast spells while invulnerable#*#"] = mq.CastResults.Distracted,
    ["You *CANNOT* cast spells, you have been silenced#*#"] = mq.CastResults.Silenced,
    ["Your target has no mana to affect#*#"] = mq.CastResults.Immune,
    ["Your target is immune to changes in its attack speed#*#"] = mq.CastResults.Immune,
    ["Your target is immune to changes in its run speed#*#"] = mq.CastResults.Immune,
    ["Your target is immune to snare spells#*#"] = mq.CastResults.Immune,
    ["Your target cannot be mesmerized#*#"] = mq.CastResults.Immune,
    ["Your target looks unaffected#*#"] = mq.CastResults.Immune,
    ["Your #*# is interrupted#*#"] = mq.CastResults.Interrupted,
    ["Your spell is interrupted#*#"] = mq.CastResults.Interrupted,
    ["Your #*# spell is interrupted#*#"] = mq.CastResults.Interrupted,
    ["Your casting has been interrupted#*#"] = mq.CastResults.Interrupted,
    ["Your spell fizzles#*#"] = mq.CastResults.Fizzled,
    ["Your #*# spell fizzles#*#"] = mq.CastResults.Fizzled,
    ["You miss a note, bringing your song to a close#*#"] = mq.CastResults.Fizzled,
    ["You must first select a target for this spell#*#"] = mq.CastResults.BadTarget,
    ["This spell only works on#*#"] = mq.CastResults.BadTarget,
    ["You must first target a group member#*#"] = mq.CastResults.BadTarget,
    ["Spell recast time not yet met#*#"] = mq.CastResults.NotReady,
    ["Insufficient Mana to cast this spell#*#"] = mq.CastResults.NoMana,
    ["Your target is out of range, get closer#*#"] = mq.CastResults.OutOfRange,
    ["This spell does not work here#*#"] = mq.CastResults.OutDoors,
    ["You can only cast this spell in the outdoors#*#"] = mq.CastResults.OutDoors,
    ["You can not summon a mount here#*#"] = mq.CastResults.OutDoors,
    ["You must have both the Horse Models and your current Luclin Character Model enabled to summon a mount#*#"] = mq
        .CastResults.OutDoors,
    ["You haven't recovered yet#*#"] = mq.CastResults.NotReady,
    ["#*# resisted your #*#!"] = mq.CastResults.Resisted,
    ["Spell recovery time not yet met#*#"] = mq.CastResults.NotReady,
    ["Your target resisted the#*#spell#*#"] = mq.CastResults.Resisted,
    ["#*#avoided your#*#!#*#"] = mq.CastResults.Resisted,
    ["You must be standing to cast a spell#*#"] = mq.CastResults.Standing,
    ["You can't cast spells while stunned#*#"] = mq.CastResults.Stunned,
    ["You are already on a mount#*#"] = mq.CastResults.Blocked,
    ["#*#spell did not take hold. (Blocked by#*#"] = mq.CastResults.Blocked,
    ["#*#spell did not take hold on#*#(Blocked by#*#"] = mq.CastResults.Blocked,
    ["Your spell did not take hold#*#"] = mq.CastResults.Blocked,
    ["Your spell would not have taken hold#*#"] = mq.CastResults.Blocked,
    ["Your spell is too powerful for your intended target#*#"] = mq.CastResults.Blocked,
    ["You need to be in a more open area to summon a mount#*#"] = mq.CastResults.Blocked,
    ["You can only summon a mount on dry land#*#"] = mq.CastResults.Blocked,
    ["This pet may not be made invisible#*#"] = mq.CastResults.Blocked
}
local maxAttempts = 2


---@param args CastSpellNodeArgs
---@return CastSpellNode
function CastSpellNode.new(args)
    ---@class CastSpellNode:Node
    local self = Node.new(args.name)
    local me = mq.TLO.Me
    self.NodeType = "CastSpellNode"
    self.eventList = {};
    mq.Write.Trace("%s: Creating CastSpellNode", args.name)
    function ValidateSpell()
        --make sure we have the spell memorized
        local spell = mq.TLO.Spell(self.spellId)
        if not spell() then
            mq.Write.Error("%s: Spell with an id of %s does not exist", self.Name, self.spellId)
            return false
        end
        --check if the spell is memorized
        local spellGem = me.Gem(spell.Name())()
        if not spellGem then
            mq.Write.Error("%s: Spell '%s' is not memorized", self.Name, spell.Name())
            return false
        end
        -- check if the spell is ready
        local gemTimerSeconds = me.GemTimer(spellGem).TotalSeconds()
        if gemTimerSeconds > 0 then
            mq.Write.Error("%s: Spell '%s' will not be ready for another %d seconds", self.Name, spell.Name(),
                gemTimerSeconds)
            return false
        end
        return true
    end

    function ValidateItem()
        if mq.TLO.FindItemCount(self.spellId)() == 0 then
            mq.Write.Error("%s: Unable to locate itemId %s in inventory", self.Name, self.spellId)
            return false
        end
        local theItem = mq.TLO.FindItem(self.spellId)
        if theItem.TimerReady() > 0 then
            mq.Write.Error("%s: Item %s is not ready", self.Name, self.spellId)
            return false
        end

        if not theItem.Spell() then
            mq.Write.Error("%s: Item %s does not have a spell", self.Name, self.spellId)
            return false
        end
        return true
    end

    function ValidateCombatAbility()
        if not me.CombatAbility(self.spellId)() then
            mq.Write.Error("%s: Character does not possess combat ability %s", self.Name, self.spellId)
            return false
        end
        if not me.CombatAbilityReady(self.spellId)() then
            mq.Write.Error("%s: Combat Ability %s is not ready", self.Name, self.spellId)
            return false
        end
        return true
    end

    function ValidateAltAbility()
        local theAbility = me.AltAbility(self.spellId)
        if not theAbility() then
            mq.Write.Error("%s: Character does not possess the AA %s", self.Name, self.spellId)
            return false
        end
        if not me.AltAbilityReady(self.spellId)() then
            mq.Write.Error("%s: Alt Ability %s is not ready", self.Name, self.spellId)
            return false
        end
        if not theAbility.Spell() then
            mq.Write.Error("%s: Alt Ability %s does not have a spell", self.Name, self.spellId)
            return false
        end
        return true
    end

    function AddEvent(matcherText, callback)
        local eventId = string.format("%s-%s", self.Name, matcherText)
        mq.event(eventId, matcherText, callback)
        table.insert(self.eventList, eventId)
    end

    -- Initialization of the node
    function self._OnInitialize(blackboard)
        self.initalizedOn = socket.gettime()
        mq.Write.Trace("%s: Initializing CastSpellNode", args.name)
        -- Extract the necessary keys from the blackboard
        self.targetId = blackboard[args.targetIdKey]
        self.targetType = blackboard[args.targetTypeKey] or "any"
        self.spellId = blackboard[args.spellIdKey]
        self.spellType = blackboard[args.spellTypeKey]
        mq.Write.Debug("Calling IsValidTarget %s - %s", self.targetId, self.targetType)
        -- Validate the extracted values...
        if not mq.IsValidTarget(self.targetId, self.targetType) then
            mq.Write.Error("%s: Invalid target type expected %s but target %s was %s", self.Name, self.targetType,
                self.targetId,
                mq.TLO.Spawn(self.targetId).Type())
            return NodeState.Invalid
        end
        --validate our target is correct
        if mq.TLO.Spawn(self.targetId).ID() ~= mq.TLO.Target.ID() then
            mq.Write.Error("%s: Invalid target our target is %s, but expected %s", self.Name, mq.TLO.Target.Name(),
                mq.TLO.Spawn(self.targetId).Name())
            return NodeState.Invalid
        end

        local valid
        local theSpell
        --Check the spell is available
        if not self.spellType or self.spellType == "" then
            mq.Write.Error("%s: No spell type provided")
            valid = NodeState.Invalid
        elseif self.spellType:equals("gem") then
            valid = ValidateSpell()
            if valid then
                theSpell = me.Book(self.spellId)
            end
        elseif self.spellType:equals("item") then
            valid = ValidateItem()
            if valid then
                theSpell = mq.TLO.FindItem(self.spellId).Spell
            end
        elseif self.spellType:equals("disc") then
            valid = ValidateCombatAbility()
            if valid then
                ---@type integer
                local discNumber = me.CombatAbility(self.spellId)
                theSpell = me.CombatAbility(discNumber);
            end
        elseif self.spellType:equals("alt") then
            valid = ValidateAltAbility()
            if valid then
                theSpell = me.AltAbility(self.spellId).Spell
            end
        end

        if (not valid) then
            return NodeState.Invalid
        end

        -- Initialize variables
        self.attempts = 0
        self.cumulativeTime = 1000
        self.SpellFinished = false
        self.SpellSuccess = false
        self.SpellResult = nil
        self.SpellStarted = false

        -- Set up event listeners...

        --set up the unique events for this particular spell
        --These help with detecting discs and other instant cast things
        local theSpawn = mq.TLO.Spawn(self.targetId)
        if theSpawn.ID() == me.ID() then
            --casting on self
            AddEvent(theSpell.CastOnYou(), function() HandleEvent(mq.CastResults.Success) end)
        else
            mq.Write.Debug("The spell is %s",theSpell)
            AddEvent(string.format("#1# %s", theSpell.CastOnAnother()),
                function() HandleEvent(mq.CastResults.Success) end)
        end
        --Combat abilities use the phrase 'You activate' rather than 'You begin casting'
        if not self.spellType:equals("disc") then
            AddEvent("You begin casting #*#", HandleStarted)
        else
            AddEvent("You activate #*#", HandleStarted)
        end
        --these ones are the same for everyone
        for pattern, result in pairs(eventMappings) do
            AddEvent(pattern, function() HandleEvent(result) end)
        end
    end

    ---@param result CastResult
    function HandleEvent(result)
        mq.Write.Debug("%s: Handling event with result %s", self.Name, mq.CastResults[result])
        self.SpellFinished = true
        self.SpellSuccess = result == mq.CastResults.Success
        self.SpellResult = result
    end

    function HandleStarted()
        self.SpellStarted = true
        --Assume it's going to succeed
        self.SpellSuccess = true
        self.SpellResult = mq.CastResults.Success
    end

    function IssueCastCommand()
        mq.Write.Debug("%s: Issuing cast command for spell type %s", self.Name, self.spellType)
        if self.spellType:equals("gem") then
            --get the spell
            local spell = mq.TLO.Spell(self.spellId)
            --get the gem the spell is in
            local gem = me.Gem(spell.Name())
            --issue the cast command
            if (gem) then
                local command = string.format("/cast %s", gem)
                mq.cmd(command)
            end
        elseif self.spellType:equals("item") then
            --we assume the items are in the proper spot to be clicked (not our job to equip items)
            local theItem = mq.TLO.FindItem(self.spellId);
            if (mq.TLO.FindItem(self.spellId)()) then
                --Instant cast spells are weird and don't actually say "You begin casting" so we assume the click was successful
                if theItem.CastTime() == 0 then
                    HandleStarted()
                end
                mq.cmdf('/itemnotify "%s" rightmouseup', self.spellId)
            end
        elseif self.spellType:equals("disc") then
            mq.cmdf("/disc %s",self.spellId)
        elseif self.spellType:equals("alt") then
            --We need to get the id of the AA
            local aaId = mq.TLO.AltAbility(self.spellId).ID()
            if aaId then
                mq.cmdf("/alt act %s", aaId)
            end
        end
    end

    function CheckCastingSuccess(blackboard)
        mq.Write.Trace("%s: Checking casting success. Result: %s", self.Name, mq.CastResults[self.SpellResult])
        blackboard[args.spellResultKey] = self.SpellResult

        if self.SpellResult == mq.CastResults.Success then
            return NodeState.Success
        end
        return NodeState.Failure
    end

    -- Handle the casting process
    function self._Update(blackboard)

        -- Update the cumulative time since the last cast attempt.
        -- If this is the first update or the spell just started, reset the cumulative time.
        if not self.cumulativeTime or self.SpellStarted then
            self.cumulativeTime = 0
        else
            self.cumulativeTime = self.cumulativeTime + blackboard.deltaTime
        end

        -- Loop through each registered event and process it. This took way too long to do individually, around 1 second
        -- Doing all events though takes 0.03 seconds
        -- for _, eventId in ipairs(self.eventList) do
        --     mq.doevents(eventId)
        -- end
        mq.doevents()
        -- If it's been more than 500 milliseconds since the last cast attempt and we're not casting,
        -- and the spell hasn't already started casting.
        if self.cumulativeTime > 500 and not me.Casting.ID() and not self.SpellStarted then
            if self.attempts < maxAttempts then
                -- Attempt to cast the spell
                self.attempts = self.attempts + 1
                self.cumulativeTime = 0 -- Reset the timer since we're making an attempt now.
                IssueCastCommand()
            else
                -- We're beyond our max attempts, so we return failure.
                mq.Write.Debug("%s: Exceeded maximum casting attempts", self.Name)
                return NodeState.Failure
            end
        end

        -- If we're done casting, check the result and return the corresponding state.
        if self.SpellFinished or (self.SpellStarted and not me.Casting.ID()) then
            return CheckCastingSuccess(blackboard)
        end

        -- If none of the above conditions are met, we're still trying to cast, so return Running.
        return NodeState.Running
    end

    -- Cleanup function
    function self._OnTerminate(blackboard)
        mq.Write.Trace("%s: Terminating CastSpellNode Run Time: %f", self.Name,socket.gettime() - self.initalizedOn)
        -- Unregister all events
        for _, eventId in ipairs(self.eventList) do
            mq.unevent(eventId)
        end
        -- Clear the event list
        self.eventList = {}
    end

    return self
end

return CastSpellNode
