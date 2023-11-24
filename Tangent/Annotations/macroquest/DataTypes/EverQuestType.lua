---@diagnostic disable: duplicate-index, missing-return
---@class EverQuestType
__EverQuestType = {
    ---@return boolean
    ---Returns TRUE if EverQuest is in Background
    Background = function()end,
    ---@return string
    ---Date that MQ2Main.dll was built
    BuildDate = function()end,
    ---@return number
    ---Currently returns the zone ID the character is currently in
    CharSelectList = function()end,
    ---@return boolean
    ---Returns TRUE if channel name is joined
    ChatChannel = function(channelName)end,
    ---@return string
    ---Returns the name of chat channel #
    ChatChannel = function(index)end,
    ---@return number
    ---Returns the number of channels currently joined
    ChatChannels = function()end,
    ---@return string
    ---return a string representing the currently loaded UI skin
    CurrentUI = function()end,
    ---@return string
    ---Last normal error message
    Error = function()end,
    ---@return boolean
    ---Returns TRUE if EverQuest is in Foreground
    Foreground = function()end,
    ---@return string
    ---CHARSELECT INGAME UNKNOWN
    GameState = function()end,
    ---@return boolean
    ---returns a bool true or false if the "Default" UI skin is the one loaded
    IsDefaultUILoaded = function()end,
    ---@return string
    ---Last command entered
    LastCommand = function()end,
    ---@return string
    ---Name of last person to send you a tell
    LastTell = function()end,
    ---@return boolean
    ---Returns TRUE if a layoutcopy is in progress and FALSE if not.
    LayoutCopyInProgress = function()end,
    ---@return boolean
    ---Returns TRUE if an object has been left clicked
    LClickedObject = function()end,
    ---@return string
    ---Your station name
    LoginName = function()end,
    ---@return number
    ---Mouse's X location
    MouseX = function()end,
    ---@return number
    ---Mouse's Y location
    MouseY = function()end,
    ---@return string
    ---Last MQ2Data parsing error message
    MQ2DataError = function()end,
    ---@return number
    ---Your current (Process ID)
    PID = function()end,
    ---@return number
    ---Your current ping
    Ping = function()end,
    ---@return number
    ---Running time of current MQ2 session, in milliseconds
    Running = function()end,
    ---@return number
    ---Returns the screenmode as an integer, 2 is Normal and 3 is No Windows
    ScreenMode = function()end,
    ---@return string
    ---Full name of your server
    Server = function()end,
    ---@return string
    ---Last syntax error message
    SyntaxError = function()end,
    ---@return number
    ---Returns the processor priority that Everquest is set to. Where 1 is Low 2 is below Normal 3 is Normal 4 is Above Normal 5 is High and 6 is RealTime
    PPriority = function()end,
    ---@return number
    ---EverQuest viewport upper left (X) position
    ViewportX = function()end,
    ---@return number
    ---EverQuest viewport center (X) position
    ViewportXCenter = function()end,
    ---@return number
    ---EverQuest viewport lower right (X) position
    ViewportXMax = function()end,
    ---@return number
    ---EverQuest viewport upper left (Y) position
    ViewportY = function()end,
    ---@return number
    ---EverQuest viewport center (Y) position
    ViewportYCenter = function()end,
    ---@return number
    ---EverQuest viewport lower right (Y) position
    ViewportYMax = function()end,
}