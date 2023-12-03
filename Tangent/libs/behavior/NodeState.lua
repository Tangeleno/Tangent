---@class NodeState:number
---@class NodeStates
---@field Invalid NodeState @Node is in an invalid state
---@field Success NodeState @Node successfully completed its operation
---@field Failure NodeState @Node failed to complete its operation
---@field Running NodeState @Node is currently running its operation
---@field Aborted NodeState @Node was aborted before completion
local NodeState = {
    Invalid = 0,
    Success = 1,
    Failure = 2,
    Running = 3,
    Aborted = 4,
    [0] = "Invalid",
    [1] = "Success",
    [2] = "Failure",
    [3] = "Running",
    [4] = "Aborted"
}
return NodeState