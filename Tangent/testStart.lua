local lfs = require("lfs")
local DI = require "libs.DependencyInjector"
DI.__mq = {}
DI.mq = require "libs.Helpers.MacroQuestHelpers"
function requireAll(folder)
    print("requireAll folder is - " .. folder)
    for file in lfs.dir(folder) do
        if file ~= "." and file ~= ".." then
            local filePath = folder .. '/' .. file
            print("Found file: " .. filePath)
            if lfs.attributes(filePath, "mode") == "file" and file:match("^.+(%.lua)$") then
                local moduleName = filePath:sub(1, -5)  -- Remove the .lua extension
                print("Requiring Lua file: " .. moduleName)
                require(moduleName)
            end
        end
    end
end


--Each of the test files appends to the testSuite object
testSuite = {}

-- Example usage
requireAll("tests")

for _, value in ipairs(testSuite) do
    --each test file will add one or more properties to the testSuite object. 
end