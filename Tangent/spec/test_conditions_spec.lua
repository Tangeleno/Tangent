local mq = require "libs.Helpers.MacroQuestHelpers"
local conditions = require "libs.behavior.conditions"

--These aren't needed but I wrote these as starting examples of tests.
--There may be other 'conditions' in the future that do require tests though
describe("Conditions", function()
    local standingStub, isValidTargetStub, outputStub
    before_each(function()
        outputStub = stub(mq.Write,"Output")
        -- Create spies or stubs as needed
        standingStub = stub(mq.TLO.Me, "Standing").returns(true)
        isValidTargetStub = stub(mq, "IsValidTarget").returns(true)
        -- Add more stubs or spies for other functions in mq
    end)

    after_each(function()
        -- Revert the mocks to their original state
        standingStub:revert()
        isValidTargetStub:revert()
        outputStub:revert()
        -- Revert other stubs or spies
    end)

    it("should return true if standing", function()
        assert.is_true(conditions.standing())
        assert.stub(mq.TLO.Me.Standing).was_called()
    end)
end)
