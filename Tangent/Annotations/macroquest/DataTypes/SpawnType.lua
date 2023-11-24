---@diagnostic disable: duplicate-index, missing-return
---@class SpawnType
__SpawnType = {
    ---@return number
    ---AA rank number
    AARank = function()end,
    ---@return boolean
    ---AFK?
    AFK = function()end,
    ---@return boolean
    ---returns TRUE or FALSE if a mob is aggressive or not
    Aggressive = function()end,
    ---@return number
    ---Current animation ID. See Animations for a list of animations.
    Animation = function()end,
    ---@return boolean
    ---Anonymous
    Anonymous = function()end,
    ---@return boolean
    ---Current Raid or Group assist target?
    Assist = function()end,
    ---@return boolean
    ---Binding wounds?
    Binding = function()end,
    ---@return BodyType
    ---Body type
    Body = function()end,
    ---@return boolean
    ---Is a buyer? (ie. Buyer in the bazaar)
    Buyer = function()end,
    ---@return number
    ---The number of cached buffs on the spawn
    CachedBuffCount = function()end,
    ---@return CachedBuffType
    ---@param spellId number The spell id of the buff
    ---Returns the buff with the provided spell id
    CachedBuff = function(spellId)end,
    ---@return CachedBuffType
    ---@param search string The search string
    ---Returns the buff that matches the string provided
    ---Search string options are
    ---#<number> to search by sorted buff slot (no empty slots, may not be in the same order as the buffs in the window), valid range 1-97
    ---*<number> to search by unsorted buff slot (what you see in the window)
    ---^<keyword> to search by keyword (Slowed Rooted Mezzed Crippled Maloed Tashed Snared and Beneficial)
    CachedBuff = function(search)end,
    ---@return boolean
    ---TRUE/FALSE on if a splash spell can land...NOTE! This check is ONLY for line of sight to the targetindicator (red/green circle)
    CanSplashLand = function()end,
    ---@return SpellType
    ---Spell, if currently casting (only accurate on yourself, not NPCs or other group members)
    Casting = function()end,
    ---@return ClassType
    ---Class
    Class = function()end,
    ---@return string
    ---The "cleaned up" name
    CleanName = function()end,
    ---@return string
    ---GREY, GREEN, LIGHT BLUE, BLUE, WHITE, YELLOW, RED
    ConColor = function()end,
    ---@return number
    ---Current Endurance points (only updates when target/group)
    CurrentEndurance = function()end,
    ---@return number
    ---Current hit points
    CurrentHPs = function()end,
    ---@return number
    ---Current Mana points (only updates when target/group)
    CurrentMana = function()end,
    ---@return boolean
    ---Dead?
    Dead = function()end,
    ---@return DeityType
    ---Deity
    Deity = function()end,
    ---@return string
    ---Name displayed in game (same as EQ's %T)
    DisplayName = function()end,
    ---@return number
    ---Distance from player in (x,y)
    Distance = function()end,
    ---@return number
    ---Distance from player in (x,y,z) in 3D
    Distance3D = function()end,
    ---@return number
    ---Distance from player in Y plane (North/South)
    DistanceN = function()end,
    ---@return number
    ---Estimated distance in (x,y), taking into account the spawn's movement speed but not the player's
    DistancePredict = function()end,
    ---@return number
    ---Distance from player in Z plane (Up/Down)
    DistanceU = function()end,
    ---@return number
    ---Distance from player in X plane (East/West)
    DistanceW = function()end,
    ---@return number
    ---Distance from player in X plane
    DistanceX = function()end,
    ---@return number
    ---Distance from player in Y plane
    DistanceY = function()end,
    ---@return number
    ---Distance from player in Z plane
    DistanceZ = function()end,
    ---assists the spawn
    DoAssist = function()end,
    ---Faces target
    DoFace = function()end,
    ---targets spawn
    DoTarget = function()end,
    ---@return boolean
    ---Ducking?
    Ducking = function()end,
    ---@return number
    ---returns a inttype, it takes numbers 0-8 or names: head chest arms wrists hands legs feet primary offhand
    Equipment = function()end,
    ---@return number
    ---Location using EQ format
    EQLoc = function()end,
    ---@return boolean
    ---Feet wet/swimming?
    FeetWet = function()end,
    ---@return boolean
    ---Feigning?
    Feigning = function()end,
    ---@return SpawnType
    ---The spawn a player is following using /follow on - also returns your pet's target via ${Me.Pet.Following}
    Following = function()end,
    ---@return boolean
    ---Is your target moving away from you?
    Fleeing = function()end,
    ---@return string
    ---Gender
    Gender = function()end,
    ---@return boolean
    ---GM or Guide?
    GM = function()end,
    ---@return boolean
    ---Group leader?
    GroupLeader = function()end,
    ---@return string
    ---Guild name
    Guild = function()end,
    ---Heading in this direction
    Heading = __HeadingType,
    ---Heading player must travel in to reach this spawn
    HeadingTo = __HeadingType,
    ---@return HeadingType
    ---Heading to the coordinates y,x from the spawn
    HeadingToLoc = function(y,x)end,
    ---@return number
    ---Height
    Height = function()end,
    ---@return number
    ---Represents what the pc/npc is holding
    Holding = function()end,
    ---@return boolean
    ---Hovering?
    Hovering = function()end,
    ---@return number
    ---Spawn ID
    ID = function()end,
    ---@return boolean
    ---Options are: 0 = ANY, 1 = NORMAL, 2 = UNDEAD, 3 = ANIMAL, 4 = SOS
    Invis = function(index)end,
    ---@return boolean
    ---Options are: ANY, NORMAL, UNDEAD,  ANIMAL, SOS
    Invis = function(index)end,
    ---@return boolean
    ---Invited to group?
    Invited = function()end,
    ---@return number
    ---Level
    Level = function()end,
    ---left clicks the spawn
    LeftClick = function()end,
    ---@return boolean
    ---Levitating?
    Levitating = function()end,
    ---@return boolean
    ---LFG?
    LFG = function()end,
    ---@return string
    ---Name of the light class this spawn has
    Light = function()end,
    ---@return boolean
    ---Returns TRUE if spawn is in LoS
    LineOfSight = function()end,
    ---@return boolean
    ---Linkdead?
    Linkdead = function()end,
    ---@return string
    ---Loc of the spawn
    Loc = function()end,
    ---@return string
    ---LocYX of the spawn
    LocYX = function()end,
    ---@return number
    ---Looking this angle
    Look = function()end,
    ---@return number
    ---Current Raid or Group marked npc mark number (raid first)
    Mark = function()end,
    ---@return SpawnType
    ---Master, if it is charmed or a pet
    Master = function()end,
    ---@return number
    ---Maximum Endurance points (only updates when target/group)
    MaxEndurance = function()end,
    ---@return number
    ---Maximum hit points
    MaxHPs = function()end,
    ---@return number
    ---Maximum Mana points (only updates when target/group)
    MaxMana = function()end,
    ---@return number
    ---The max distance from this spawn for it to hit you
    MaxRange = function()end,
    ---@return number
    ---The Max distance from this spawn for you to hit it
    MaxRangeTo = function()end,
    ---@return SpawnType
    ---Mount
    Mount = function()end,
    ---@return boolean
    ---Moving?
    Moving = function()end,
    ---@return number
    ---Location using MQ format
    MQLoc = function()end,
    ---@return string
    ---Name
    Name = function()end,
    ---@return boolean
    ---Is this a "named" spawn (ie. does it's name not start with an "a" or an "an")
    Named = function()end,
    ---@return SpawnType
    ---Find the nearest spawn matching this Spawn Search, to this spawn (most efficient on yourself)
    NearestSpawn = function(search)end,
    ---@return SpawnType
    ---Find the #th nearest spawn matching this Spawn Search, to this spawn (most efficient on yourself)
    NearestSpawn = function(index,search)end,
    ---@return SpawnType
    ---Next spawn in the list
    Next = function()end,
    ---@return SpawnType
    ---Owner, if mercenary
    Owner = function()end,
    ---@return SpawnType
    ---Previous spawn in the list
    Prev = function()end,
    ---@return SpawnType
    ---Pet
    Pet = function()end,
    ---@return number
    ---Percent hit points
    PctHPs = function()end,
    ---@return number
    ---returns a mask as an inttype which has the following meaning: 0=Idle 1=Open 2=WeaponSheathed 4=Aggressive 8=ForcedAggressive 0x10=InstrumentEquipped 0x20=Stunned 0x40=PrimaryWeaponEquipped 0x80=SecondaryWeaponEquipped
    PlayerState = function()end,
    ---@return number
    ---Item ID of anything that may be in the Primary slot
    Primary = function()end,
    ---@return RaceType
    ---Race
    Race = function()end,
    ---Right clicks the spawn
    RightClick = function()end,
    ---@return boolean
    ---Roleplaying?
    Roleplaying = function()end,
    ---@return number
    ---Item ID of anything that may be in the Secondary slot
    Secondary = function()end,
    ---@return boolean
    ---Sitting?
    Sitting = function()end,
    ---@return boolean
    ---Sneaking?
    Sneaking = function()end,
    ---@return number
    ---Speed moving
    Speed = function()end,
    ---@return boolean
    ---Standing?
    Standing = function()end,
    ---@return number
    ---StandState
    StandState = function()end,
    ---@return string
    ---STAND, SIT, DUCK, BIND, FEIGN, DEAD, STUN, HOVER, MOUNT, UNKNOWN
    State = function()end,
    ---@return boolean
    ---Stunned?
    Stunned = function()end,
    ---@return boolean
    ---Stuck?
    Stuck = function()end,
    ---@return string
    ---Suffix attached to name, eg. of <servername>
    Suffix = function()end,
    ---@return string
    ---Last name
    Surname = function()end,
    ---@return string
    ---Prefix/Title before name
    Title = function()end,
    ---@return boolean
    ---Trader?
    Trader = function()end,
    ---@return string
    ---PC, NPC, Untargetable, Mount, Pet, Corpse, Chest, Trigger, Trap, Timer, Item, Mercenary, Aura, Object, Banner, Campfire, Flyer
    Type = function()end,
    ---@return boolean
    ---Underwater?
    Underwater = function()end,
    ---@return number
    ---X coordinate
    X = function()end,
    ---@return number
    ---Y coordinate
    Y = function()end,
    ---@return number
    ---Z coordinate
    Z = function()end,
    ---@return number
    ---X, the Northward-positive coordinate
    N = function()end,
    ---@return number
    ---Y, the Westward-positive coordinate
    W = function()end,
    ---@return number
    ---Z, the Upward-positive coordinate
    U = function()end,
    ---@return number
    ---Shortcut for -X (makes Eastward positive)
    E = function()end,
    ---@return number
    ---Shortcut for -Y (makes Southward positive)
    S = function()end,
    ---@return number
    ---Shortcut for -Z (makes Downward positive)
    D = function()end,
}