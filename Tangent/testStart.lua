local mq = require "libs.Helpers.MacroQuestHelpers"


function HiTest()
    print("Hi Test")
end
function ByeTest()
    print("Bye Test")
end

mq.event("test","You trell your party, 'hi'",HiTest)
mq.event("test","You trell your party, 'bye'",ByeTest)

while true do
    mq.doevents()
    mq.delay(10)
end