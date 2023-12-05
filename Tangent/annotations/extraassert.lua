---@diagnostic disable: missing-return
assert = {}

--- Checks if a condition is true.
---@param condition boolean
---@param message string|nil
---@return boolean
function assert.is_true(condition, message) end

--- Checks if a condition is false.
---@param condition boolean
---@param message string|nil
---@return boolean
function assert.is_false(condition, message) end

--- Asserts that the value is nil.
---@param value any
---@param message string|nil
---@return boolean
function assert.is_nil(value, message) end

--- Asserts that the value is not nil.
---@param value any
---@param message string|nil
---@return boolean
function assert.is_not_nil(value, message) end

--- Asserts that two values are equal.
---@param expected any
---@param actual any
---@param message string|nil
---@return boolean
function assert.are_equal(expected, actual, message) end

--- Asserts that two values are not equal.
---@param expected any
---@param actual any
---@param message string|nil
---@return boolean
function assert.are_not_equal(expected, actual, message) end

---@param stubProperty function
---@return Stub
function assert.stub(stubProperty)end

return assert
