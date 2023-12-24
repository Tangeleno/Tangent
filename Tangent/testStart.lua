local mq = require "libs.Helpers.MacroQuestHelpers"


function hiTest()
    print("Hi Test")
end
function byeTest()
    print("Bye Test")
end

mq.event("test","You trell your party, 'hi'",hiTest)
mq.event("test","You trell your party, 'bye'",byeTest)

while true do
    mq.doevents()
    mq.delay(10)
end