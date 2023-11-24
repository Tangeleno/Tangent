local mq = require "libs.Helpers.MacroQuestHelpers"
require "libs.Helpers.StringFunctions"
local socket = require('socket')
local cjson = require('cjson')
local msgpack = require('MessagePack')
local redis = require('redis')

local commands = {
    STOP_COMMAND = "/stoprelay",
    INTERVAL_COMMAND = "/relayinterval",
    RADIUS_COMMAND = "/relayradius"
}

local updateTimes = {
    character = socket.gettime(),
    spawn = socket.gettime(),
    target = socket.gettime()
}
local settings = {
    characterUpdateInterval = 500,
    spawnUpdateInterval = 500,
    spawnRadius = 500,
    REDIS_SERVER = '127.0.0.1',
    REDIS_PORT = 6379,
}

local redisClient = redis.connect(settings.REDIS_SERVER, settings.REDIS_PORT)

local running = true

local function getBuffData(me, i)
    local buff = nil
    if me.Buff(i).ID() then
        buff = {
            Id = me.Buff(i).Spell.ID(),
            Duration = me.Buff(i).Duration(),
        }
    end
    return buff
end

local function getXTargetData(me, i)
    local xTarget = nil
    if me.XTarget(i).ID() ~= 0 then
        local x = me.XTarget(i)
        xTarget = {
            Id = x.ID(),
            Threat = x.PctAggro(),
            DistanceTo = x.Distance(),
            HeadingTo = x.HeadingTo(),
            LineOfSight = x.LineOfSight(),
        }
    end
    return xTarget
end

local function getLeaderName()
    return mq.TLO.Group.Leader.CleanName() or mq.TLO.Me.CleanName()
end

local function UpdateCharacter(client, me, target)
    local characterKey = string.format("%s:%s:characters:%s", mq.TLO.MacroQuest.Server(), getLeaderName(),
        mq.TLO.Me.CleanName())
    mq.Write.Trace("Update time for character")
    local selfUpdate = {
        spawnId = me.ID(),
        currentHP = me.CurrentHPs(),
        maxHP = me.MaxHPs(),
        currentMana = me.CurrentMana(),
        maxMana = me.MaxMana(),
        currentEndurance = me.CurrentEndurance(),
        maxEndurance = me.MaxEndurance(),
        level = me.Level(),
        pctExp = me.PctExp(),
        combatState = mq.CombatStates[me.CombatState()],
        class = mq.Classes[me.Class.ShortName()],
        casting = me.Casting.ID(),
        castingTargetId = me.CastTarget(),
        castingETA = me.CastTimeLeft(),
        autoAttacking = me.Combat(),
        autoFiring = me.AutoFire(),
        heading = me.Heading(),
        buffs = {},
        XTargets = {},
        zone = mq.TLO.Zone.ShortName(),
        targetId = target.ID(),
        groupLeader = mq.TLO.Group.Leader.CleanName() or "Ungrouped",
    }

    for i = 1, me.MaxBuffSlots(), 1 do
        selfUpdate["buffs"][i] = getBuffData(me, i)
    end

    for i = 1, me.XTargetSlots(), 1 do
        selfUpdate["XTargets"][i] = getXTargetData(me, i)
    end

    local selfUpdateJson = msgpack.pack(selfUpdate)
    client:set(characterKey, selfUpdateJson)
    client:expire(characterKey, 6)
end

local function UpdateGroup(client, me)
    mq.Write.Trace("Update time for group, and I am the group leader, or solo")
    local spawnKey = string.format("%s:%s:spawns", mq.TLO.MacroQuest.Server(), getLeaderName())
    local spawnIdsInXTarget = {}
    for i = 1, me.XTargetSlots(), 1 do
        if me.XTarget(i).ID() then
            local x = me.XTarget(i)
            spawnIdsInXTarget[x.ID()] = x.ID()
        end
    end

    local npcs = mq.getFilteredSpawns(function(s)
        local type = s.Type()
        return (type == "NPC" or (type == "Pet" and s.Master.Type() == "NPC")) and
            s.Distance() <= settings.spawnRadius
    end)
    local spawns = {}
    for _, spawn in ipairs(npcs) do
        local s = {
            Name = spawn.Name(),
            Class = mq.Classes[spawn.Class.ShortName()],
            Type = spawn.Type(),
            Id = spawn.ID(),
            Position = { X = spawn.X(), Y = spawn.Y(), Z = spawn.Z() },
            Heading = spawn.Heading(),
        }
        if spawnIdsInXTarget[spawn.ID()] then
            s.PctHPs = spawn.PctHPs()
        end
        table.insert(spawns, s)
    end
    local spawnsJson = msgpack.pack(spawns)
    client:set(spawnKey, spawnsJson)
    client:expire(spawnKey, 6)
end

local function logError(message, err)
    if type(err) == "string" then
        mq.Write.Error(message, err)
    elseif type(err) == "table" then
        local errJson = cjson.encode(err)
        mq.Write.Error(message, errJson)
    else
        mq.Write.Error(message, "")
    end
end

local function Update()
    local me = mq.TLO.Me
    local target = mq.TLO.Target
    local time = socket.gettime() * 1000

    local success, error = pcall(function()
        redisClient:pipeline(function(p)
            if time >= updateTimes.character then
                UpdateCharacter(p, me, target)
                updateTimes.character = time + settings.characterUpdateInterval
            end

            if (me.GroupLeader() or not me.Grouped()) and time >= updateTimes.spawn then
                UpdateGroup(p, me)
                updateTimes.spawn = time + settings.spawnUpdateInterval
            end
        end)
    end)

    if not success then
        logError("An error occurred while updating the blackboard. Err: %s", error)
    end
end

local function changeInterval(...)
    local args = { ... }
    if #args < 2 then
        mq.Write.Error("Incorrect syntax, usage: /relayinterval group|character|target #")
        return
    end
    local number = tonumber(args[2])

    if number < 5 then
        mq.Write.Warn("Warning: the main loop only runs every 5ms, any value smaller will be set to 5ms")
        number = 5
    end

    if not number then
        mq.Write.Error("Incorrect syntax, usage: /relayinterval group|character|target #")
        return
    end

    if string.equals(args[1], "character") then
        settings.characterUpdateInterval = number
    elseif string.equals(args[1], "group") then
        settings.spawnUpdateInterval = number
    elseif string.equals(args[1], "target") then
        settings.targetUpdateInterval = number
    else
        mq.Write.Error("Incorrect syntax, usage: /relayinterval group|character|target #")
        return
    end
end

local function changeRadius(...)
    local args = { ... }
    if #args < 1 then
        mq.Write.Error("Incorrect syntax, usage: /relayradius #")
        return
    end
    local number = tonumber(args[1])
    if not number then
        mq.Write.Error("Incorrect syntax, usage: /relayradius #")
        return
    end
    settings.spawnRadius = number
end



mq.bind(commands.STOP_COMMAND, function() running = false end)
mq.bind(commands.INTERVAL_COMMAND, changeInterval)
mq.bind(commands.RADIUS_COMMAND, changeRadius)

mq.Write.MinimumLevel = mq.Write.LogLevels.Debug

while running do
    while redisClient == nil do
        local success, error = pcall(function()
            redisClient = redis.connect(settings.REDIS_SERVER, settings.REDIS_PORT)
        end)
        if not success then
            local message = string.format("Unable to connect to Redis at %s:%d,%s", settings.REDIS_SERVER,
                settings.REDIS_PORT, "error: %s. Retrying in 1 second...")
            logError(message, error)
            mq.delay(1000)
        end
    end
    mq.delay(5)
    Update()
end
