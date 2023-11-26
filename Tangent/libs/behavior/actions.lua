local mq = require "libs.Helpers.MacroQuestHelpers"
local NodeState = require "libs.behavior.NodeState"

---@type table<string, fun(...):NodeState>
local actions = {
    ["sit"] = function(...)
        mq.TLO.Me.Sit()
        return NodeState.Success
    end,
    ["target"] = function(targetId)
        if mq.IsValidTarget(targetId,"any") then
            mq.TLO.Spawn(targetId).DoTarget()
            return NodeState.Success
        end
        return NodeState.Failure
    end
}
return actions
