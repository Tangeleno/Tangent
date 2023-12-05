---@diagnostic disable: missing-return, lowercase-global, duplicate-set-field
--- Describe a group of tests
---@param name string: Description of the test group
---@param callback fun():any A function containing the tests
function describe(name, callback) end

--- Define a single test
---@param name string: Description of the test
---@param callback fun():any The test function
function it(name, callback) end

--- Execute before each test in a describe block
---@param callback fun():any The function to run before each test
function before_each(callback) end

--- Execute after each test in a describe block
---@param callback fun():any The function to run after each test
function after_each(callback) end

--- Create a new stub function.
---@generic T
---@param object T The table containing the function to be stubbed. If nil, a function stub is created.
---@param method string|nil The method name to be stubbed in the given object. If nil, a function stub is created.
---@return T|Stub @The stub function, or the original object and the stub function if object is not nil.
function stub(object, method, ...) end

---@class Stub
local Stub = {}

--- Specify the return values for the stub.
---@vararg any Return values of the stub.
---@return Stub The same stub for chaining.
function Stub.returns(...) end
--- Check if the stub was called with specific arguments.
---@vararg any Arguments that the stub is expected to have been called with.
---@return boolean
function Stub.was_called_with(...) end
--- Check if the stub was called.
---@return boolean
function Stub.was_called() end
--- Reverts the stub to the original function.
function Stub:revert() end
-- Other chainable methods...


