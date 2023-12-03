local mq = require "libs.Helpers.MacroQuestHelpers"
local conditions = require "libs.behavior.conditions"

--These aren't needed but I wrote these as starting examples of tests.
--There may be other 'conditions' in the future that do require tests though
describe("MacroQuestHelpers", function()
    local standingStub, isValidTargetStub, outputStub
    before_each(function()
        --We aren't testing write
        outputStub = stub(mq.Write, "Output")
    end)

    after_each(function()
        outputStub:revert()
    end)

    describe("IsValidTarget", function()
        local spawnStub
        setup(function()
            local spawn = {
                Type = nil,
                Master = nil
            }

            --magic string spawn search so we don't have to stub it 50 times
            --expects myType|masterType
            --so PC|PET or PET|PC or PC or PC|PET or PET
            spawnStub = stub(mq.TLO, "Spawn", function(spawnSearch)
                if (not spawnSearch) then
                    setmetatable(spawn, {
                        __call = function(table, ...)
                            return nil
                        end
                    })
                else
                    setmetatable(spawn, {
                        __call = function(table, ...)
                            return table
                        end
                    })
                    if type(spawnSearch) == "string" then
                        local spawnType, spawnMasterType = string.match(spawnSearch, "([^|]+)|?(.*)")
                        spawn.Type = function()
                            return spawnType
                        end
                        if spawnMasterType then
                            spawn.Master = {
                                Type = function()
                                    return spawnMasterType
                                end
                            }
                        end
                    else
                        spawn.Type = "NPC"
                    end
                end
                return spawn
            end)
        end)
        teardown(function()
            spawnStub:revert()
        end)
        it("Returns true when types match", function()
            local result = mq.IsValidTarget("PC", "PC")
            assert.is_true(result)
        end)

        it("Returns false when types don't match", function()
            local result = mq.IsValidTarget("PC", "NPC")
            assert.is_false(result)
        end)
        
        it("Returns true when Pet and parent matches", function()
            local result = mq.IsValidTarget("PET|PC", "PC")
            assert.is_true(result)
        end)
        it("Returns false when Pet and parent doesn't match", function()
            local result = mq.IsValidTarget("PET|PC", "NPC")
            assert.is_false(result)
        end)
        
        it("Returns true when Pet and parent doesn't exist ", function()
            local result = mq.IsValidTarget("PET", "NPC")
            assert.is_false(result)
        end)
    end)
end)
