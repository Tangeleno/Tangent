---@diagnostic disable: missing-return
---@class CurrentZoneType : ZoneType
__CurrentZoneType = {
    ---@return boolean
    ---Are we in a dungeon
    Dungeon=function()end,
    ---@return number
    ---Gravity
    Gravity=function()end,
    ---@return number
    ---Zone ID
    ID=function()end,
    ---@return boolean
    ---Are we indoors?
    Indoor=function()end,
    ---@return number
    ---Maximum clip plane allowed in zone
    MaxClip=function()end,
    ---@return number
    ---Minimum clip plane allowed in zone
    MinClip=function()end,
    ---@return string
    ---Full zone name
    Name=function()end,
    ---@return boolean
    ---Can we bind here?
    NoBind=function()end,
    ---@return boolean
    ---Are we outdoors?
    Outdoor=function()end,
    ---@return string
    ---Short zone name
    ShortName=function()end,
    ---@return number
    ---Sky type
    SkyType=function()end,
    ---@return number
    ---Zone type:0=Indoor Dungeon 1=Outdoor 2=Outdoor City 3=Dungeon City 4=Indoor City 5=Outdoor Dungeon
    Type=function()end,
	---@return number
    ---Succor spot Y coordinate
    SafeY =function()end,
	---@return number
    ---Succor spot X coordinate
    SafeX =function()end,
	---@return number
    ---Succor spot Z coordinate
    SafeZ =function()end,
	---@return number
    ---Succor spot X, the Northward-positive coordinate coordinate
    SafeN =function()end,
	---@return number
    ---Succor spot Y, the Westward-positive coordinate coordinate
    SafeW =function()end,
	---@return number
    ---Succor spot Z, the Upward-positive coordinate  coordinate
    SafeU =function()end,
    ---@return number
	ZoneType =function()end,
}