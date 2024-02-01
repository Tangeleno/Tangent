--Disable some diagnostic stuff, this is because instead of ignoring errors in the typedefs and 'overloading' in the traditional sense the typedefs return or types (spell|number|nil|function)z
---@diagnostic disable: param-type-mismatch,return-type-mismatch
--TODO: Fix this, make it a class, add an Encode/Decode function that will use rapidjson. Have it parse an internal _state object so we can have functions on the main object figure out how to set the metatable up so State.Role reads from State._state.Role
--TODO: Add a Clone that will take the _state object and clone it into a new instance of the state
--State.lua
local mq = require "libs.Helpers.MacroQuestHelpers"
local me = mq.TLO.Me
local RenderableTab = require "libs.Gui.RenderableTab"
local rapidjson = require('rapidjson')
local socket = require("Socket")
require "libs.Gui.Window"

local ClassPositions = {
    ["ROG"] = function() return mq.Positioning.Behind end,
    ["WAR"] = function()
        if State.Role == 'Tank' then
            return mq.Positioning.Any
        else
            return mq.Positioning.NotFront
        end
    end
}
local tableFlags = bit32.bor(ImGuiTableFlags.Resizable,
    ImGuiTableFlags.Sortable,
    ImGuiTableFlags.RowBg,
    ImGuiTableFlags.BordersOuter,
    ImGuiTableFlags.BordersV,
    ImGuiTableFlags.NoBordersInBody,
    ImGuiTableFlags.ScrollY)


---@class StateClass
---@field private _state table The internal state object
---@field public new fun(self: StateClass): StateClass
---@field public update fun(self: StateClass)
---@field public clone fun(self: StateClass): StateClass
---@field public addUI fun(self: StateClass)
---@field public render fun(self: StateClass)
---@field public encode fun(self: StateClass): string
---@field public decode fun(self: StateClass, encodedState: string)
---@field public Role string @The role of the agent (DPS,Tank,Caster,Healer,CC)
---@field public Hidden boolean @Is the agent hiding
---@field public Sneaking boolean @is the agent sneaking
---@field public Standing boolean @is the agent standing
---@field public XTHaterCount number @How many XTargets are Auto Haters
---@field public EngageTargetId number @The target the agent should be engaged in combat with
---@field public EngageTargetDistance number @The distance between the agent and the target
---@field public EngageTargetMaxRangeTo number @The maximum distance between the agent and the target to engage in melee combat
---@field public abilityName string @The name of the ability to use: This is set by actions before calling the behavior tree
---@field public Mounted boolean @Is the agent mounted
---@field public Attacking boolean @Is the agent's auto attack on
---@field public Firing boolean @Is the agent's auto fire on
---@field public TargetId integer|nil @The Id of the current target
---@field public targetId integer|nil @The Id of the desired target: This is set by actions before calling the behavior tree
---@field public spawnType string|nil @The type of the spawn: This is set by actions before calling the behavior tree
---@field private lastUpdateTime number @The time from socket.gettime() of the previous update
---@field public deltaTime number @The time difference from the last update in ms
---@field public Spells table<string,spell> @List of all available spells
---@field public spellResult string @The result of the spell cast by the behavior tree
---@field public spellId string|integer @The ID or name of the spell to cast. This is set by actions before calling the behavior tree
---@field public spellType string @The type of spell to cast, 'gem', 'item', 'disc', or 'alt' are valid values
---@field public EngageTargetHealth integer @The percent health of the target
---@field public engageDistance Range @The distance to engage to. Set by actions
---@field public attackState string @The desired state of attack 'on' or 'off' set by actions
---@field public attackType string @The desired type of attack 'attack' or 'autofire' set by actions
local StateClass = {}
StateClass.__index = StateClass
function StateClass:new()
    ---@class StateClass
    ---@class StateClass
    local obj = setmetatable({ _state = {}, Spells = {} }, {
        __index = function(table, key)
            if key == "_state" then
                return rawget(table, "_state")
            end
            local value = rawget(StateClass, key)
            if value then
                return value
            else
                local state = rawget(table, "_state")
                return state and state[key]
            end
        end,
        __newindex = function(table, key, value)
            table._state[key] = value
        end
    })
    obj.Role = 'DPS'
    obj.Hidden = false
    obj.Sneaking = false
    obj.Standing = true
    obj.XTHaterCount = 0
    obj.EngageTargetId = me.GroupAssistTarget.ID()
    obj.EngageTargetDistance = 0
    obj.EngageTargetMaxRangeTo = math.huge
    obj.EngagedWith = 0
    obj.lastUpdateTime = socket.gettime()
    obj.TargetId = mq.TLO.Target.ID()
    obj.Mounted = me.Mount.ID() ~= nil
    obj:setSpells()
    return obj
end

function StateClass:setSpells()
    if me.Class.ShortName() == "ROG" then
        self:configureRogueSpells()
    end
end

function StateClass:configureRogueSpells()
    local combatAbility = me.CombatAbility
    ---@return spell
    local function findAssassinStrike()
        if combatAbility("Daggerslash")() then
            return combatAbility(combatAbility("Daggerslash"))
        end
        if combatAbility("Daggerslice")() then
            return combatAbility(combatAbility("Daggerslice"))
        end
        if combatAbility("Daggergash")() then
            return combatAbility(combatAbility("Daggergash"))
        end
        if combatAbility("Daggerthrust")() then
            return combatAbility(combatAbility("Daggerthrust"))
        end
        if combatAbility("Daggerstrike")() then
            return combatAbility(combatAbility("Daggerstrike"))
        end
        if combatAbility("Daggerswipe")() then
            return combatAbility(combatAbility("Daggerswipe"))
        end
        if combatAbility("Daggerlunge")() then
            return combatAbility(combatAbility("Daggerlunge"))
        end
        if combatAbility("Swiftblade")() then
            return combatAbility(combatAbility("Swiftblade"))
        end
        if combatAbility("Razorarc")() then
            return combatAbility(combatAbility("Razorarc"))
        end
        if combatAbility("Daggerfall")() then
            return combatAbility(combatAbility("Daggerfall"))
        end
        if combatAbility("Ancient Chaos Strike")() then
            return combatAbility(combatAbility("Ancient Chaos Strike"))
        end
        if combatAbility("Kyv Strike")() then
            return combatAbility(combatAbility("Kyv Strike"))
        end
        if combatAbility("Assassin's Strike")() then
            return combatAbility(combatAbility("Assassin's Strike"))
        end
        if combatAbility("Thief's Vengeance")() then
            return combatAbility(combatAbility("Thief's Vengeance"))
        end
        if combatAbility("Sneak Attack")() then
            return combatAbility(combatAbility("Sneak Attack"))
        end
        return nil
    end

    self.Spells.AssassinStrike = findAssassinStrike()
    mq.Write.Debug("Found AssassinStrikeSkill %s", self.Spells.AssassinStrike.Name())
end

function StateClass:update()
    local time = socket.gettime()
    self.deltaTime = (time - self.lastUpdateTime) * 1000 -- delta time should be ms
    self.lastUpdateTime = time
    self.Hidden = me.Invis() and not me.AbilityReady("Hide")()
    self.Sneaking = me.Sneaking()
    self.Standing = me.Standing()
    self.XTHaterCount = me.XTHaterCount() or 0
    self.EngageTargetId = me.GroupAssistTarget.ID() -- TODO: Pull this from Redis
    self.EngageTargetDistance = 0
    self.EngageTargetMaxRangeTo = 999999999
    self.EngageTargetHealth = me.GroupAssistTarget.PctHPs()
    self.EngagePosition = ClassPositions[me.Class.ShortName()]()
    self.Mounted = me.Mount.ID() ~= nil
    self.TargetId = mq.TLO.Target.ID()
    if self.EngageTargetId and mq.IsValidTarget(self.EngageTargetId, "NPC") then
        local theEngageSpawn = mq.TLO.Spawn(self.EngageTargetId)
        self.EngageTargetDistance = theEngageSpawn.Distance()
        self.EngageTargetMaxRangeTo = theEngageSpawn.MaxRangeTo()
    else
        self.EngageTargetMaxRangeTo = 999999999
    end
end

---comments
---@return StateClass
function StateClass:clone()
    local newState = StateClass:new()
    newState._state = rapidjson.decode(rapidjson.encode(self._state)) -- Deep copy
    return newState
end

function StateClass:addUI()
    if Window then
        local stateTab = setmetatable({}, { __index = RenderableTab })
        local thisState = self
        function stateTab:render()
            thisState:render() -- Call the render method of State
        end

        Window.AddTab("State", stateTab:new("State"))
    end
end

function StateClass:render()
    if ImGui.BeginTable("StateTable", 2, tableFlags) then
        ImGui.TableSetupColumn("Name")
        ImGui.TableSetupColumn("Value")
        ImGui.TableHeadersRow()

        for key, value in pairs(self._state) do
            if type(value) ~= "function" then
                local label = key
                ImGui.TableNextRow()

                -- Use Selectable for the whole row
                ImGui.TableSetColumnIndex(0)
                if ImGui.Selectable(label .. "##" .. key, false, ImGuiSelectableFlags.SpanAllColumns) then
                    -- Handle selection
                end

                -- Since the selectable spans all columns, manually render other columns
                ImGui.TableSetColumnIndex(1)
                ImGui.Text(tostring(value))
            end
        end

        ImGui.EndTable()
    end
end

function StateClass:encode()
    return rapidjson.encode(self._state)
end

function StateClass:decode(encodedState)
    self._state = rapidjson.decode(encodedState)
end

return StateClass
