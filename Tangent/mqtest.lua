local mq = require "libs.Helpers.MacroQuestHelpers"

local spell = mq.TLO.Spell(202)
local nospell = mq.TLO.Spell(1231245125124)

print("Checking if spell 202 is a thing")

if spell() then
    print("Spell 202 is a thing!")
else
    print("Spell 202 is not a thing")
end

print("Checking if spell 1231245125124 is a thing")
if nospell() then
    print("Spell 1231245125124 is a thing!")
else
    print("Spell 1231245125124 is not a thing")
end