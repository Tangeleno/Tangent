local mq = require "libs.Helpers.MacroQuestHelpers"
local lookups = require "libs.utility.ValueLookups"


local args = { ... }
local lookupName = args[1] or "MyHealth"

mq.Write.Debug("Executing %s", lookupName)
local value = lookups[lookupName]()
mq.Write.Debug("Lookup executed, resulting value is %s", value)
