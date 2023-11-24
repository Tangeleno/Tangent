---@diagnostic disable: duplicate-index, missing-return
---@class mq
local mq = {
    ---@param delayMS number|string The amount of time to delay in ms if number, or specified time if string (s,m,ms) i.e. 5m will delay 5 minutes
    delay = function(delayMS)end,
    --Join all the arguments into a single string
    ---@vararg string
    ---@return string
    join = function(...)end,
    ---force exits the script, ignoring the normal lua return flow
    exit=function()end,
    ---Creates a MQ Bind https://gitlab.com/macroquest/next/mqnext/-/wikis/Lua%20Events%20and%20Binds#lua-binds
    ---@param command string The slash command to create i.e. /foobar
    ---@param callback function
    bind=function(command,callback)end,
    ---Removes a MQ Bind
    ---@param command string The slash command to remove i.e /foobar
    unbind=function (command)end,
    ---Creates an event https://gitlab.com/macroquest/next/mqnext/-/wikis/Lua%20Events%20and%20Binds#lua-events
    ---@param name string Name of the event to create
    ---@param pattern string the pattern to match https://macroquest2.com/wiki/index.php/Event
    ---@param callback function
    event=function(name,pattern,callback)end,
    ---Removes an event
    ---@param name string Name of the event to remove
    unevent=function(name)end,
    ---Process the event queue. NOTE: This will only process a single queued event per call.
    doevents=function()end,
    TLO={
        AdvLoot = __TLOAdvLoot,
        Alert = __TLOAlert,
        ---@return boolean
        ---@param command string
        Alias = function(command)end,
        ---Alt Ability by Id
        ---@return AltAbilityType
        ---@param index number Id of the Alt Ability
        AltAbility = function (index)end,
        ---Alt Ability by name
        ---@return AltAbilityType
        ---@param index string Name of the Alt Ability
        AltAbility = function (index)end,
        Corpse = __CorpseType,
        Cursor = __ItemType,
        DisplayItem = __ItemType,
        DoorTarget = __SpawnType,
        DynamicZone = __DynamicZoneType,
        EverQuest = __EverQuestType,
        ---Searches your inventory for an item with the given name
        ---@return ItemType
        ---@param name string|integer the string to search for, by default includes partial matches, use prepend = for an exact match
        FindItem = function(name)end,
        ---Searches your inventory for an item with the given name
        ---@return ItemType
        ---@param name string the string to search for, by default includes partial matches, use prepend = for an exact match
        FindItemBank = function(name)end,
        ---Returns the number of items in your inventory that match the given name
        ---@return number
        ---@param name string the string to search for, by default includes partial matches, use prepend = for an exact match
        FindItemBankCount = function(name)end,
        ---Returns the number of items in your bank that match the given name
        ---@return number
        ---@param name string the string to search for, by default includes partial matches, use prepend = for an exact match
        FindItemCount = function(name)end,
        Friends = __FriendType,
        GameTime = __TimeType,
        Ground = __GroundType,
        ---Returns the number of ground spawns matching the search string
        ---@return number
        ---@param searchString string
        GroundItemCount = function(searchString)end,
        Group = __GroupType,
        ---@return string
        ---@param fileName string
        ---@param section string
        ---@param key string
        ---@param default string
        Ini = function(fileName,section,key,default)end,
        ---@return boolean
        ---Returns true if there is line of sight between two points
        ---@param aX number
        ---@param aY number
        ---@param bX number
        ---@param bY number
        LineOfSight = function(aX,aY,bX,bY)end,
        ---@return boolean
        ---Returns true if there is line of sight between two points
        ---@param aX number
        ---@param aY number
        ---@param aZ number
        ---@param bX number
        ---@param bY number
        ---@param bZ number
        LineOfSight = function(aX,aY,aZ,bX,bY,bZ)end,
        Me = __CharacterType,
        Menu = __MenuType,
        Mercenary = __MercenaryType,
        Merchant = __MerchantType,
        ---@return MountType
        ---@param index number
        Mount = function(index)end,
        ---@return MountType
        ---@param name string
        Mount = function(name)end,
        ---@return SpawnType
        ---@param index number
        NearestSpawn = function(index)end,
        ---@return SpawnType
        ---@param search string spawn search https://macroquest2.com/wiki/index.php/Spawn_Search
        NearestSpawn = function(search)end,
        ---@return SpawnType
        ---@param index number the Nth nearest spawn
        ---@param search string spawn search https://macroquest2.com/wiki/index.php/Spawn_Search
        NearestSpawn = function(index,search)end,
        Raid = __RaidType,
        ---Used to return information on the object that is selected in your own inventory while using a merchant. 
        SelectedItem = __ItemType,
        ---@param index number
        ---@return SkillType
        Skill = function(index)end,
        ---@param name string
        ---@return SkillType
        Skill = function(name)end,
        ---@return SpawnType
        ---@param spawnId number
        Spawn = function(spawnId)end,
        ---@return SpawnType
        ---@param search string spawn search https://macroquest2.com/wiki/index.php/Spawn_Search
        Spawn = function(search)end,
        ---@return number
        ---@param search string spawn search https://macroquest2.com/wiki/index.php/Spawn_Search
        SpawnCount = function(search)end,
        ---@return SpellType
        ---@param spellId number|string
        Spell = function(spellId)end,
        Switch = __SwitchType,
        Target = __TargetType,
        ---@return TaskType
        ---@param name string
        Task = function(name)end,
        ---@return TaskType
        ---@param index number
        Task = function(index)end,
        ---@return WindowType
        ---@param name string
        Window = function(name)end,
        Time = __TimeType,
        Zone = __CurrentZoneType,
        ---@type NavigationType
        Navigation = __NavigationType
    },
    ---See https://gitlab.com/macroquest/next/mqnext/-/wikis/MQ2Lua#command-binding
    cmd={},
    ---See https://gitlab.com/macroquest/next/mqnext/-/wikis/MQ2Lua#imgui-binding
    imgui={
        init=function(name,callback)end
    },
    ---@return SpawnType[]
    ---@param predicate fun(param:SpawnType):boolean
    ---Lua spawn Search
    getFilteredSpawns=function(predicate)end
}
return mq