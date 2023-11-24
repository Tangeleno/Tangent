--- Calculates a random point on an arc
---@param x number
---@param y number
---@param facing number
---@param distanceMin number
---@param distanceMax number
---@param arcMin number
---@param arcMax number
---@return number,number
function math.PointInArc(x, y, facing, distanceMin, distanceMax, arcMin, arcMax)
    local arc = math.random(arcMin, arcMax)
    facing = math.ToRadians(facing + 90 + arc)
    local distanceTo = math.random(distanceMin, distanceMax)
    local sinA = math.sin(facing)
    local cosA = math.cos(facing)
    local x1 = cosA
    local y1 = sinA
    return x + x1 * distanceTo, y + y1 * distanceTo
end

--- Calculates a random point in a circle
---@param x number
---@param y number
---@param radius number
---@return number,number
function math.RandomPointInCircle(x, y, radius)
    local r = math.random(radius)
    local random = math.random()
    local theta = random * 2 * math.pi
    local x = x + r * math.sin(theta)
    local y = y + r * math.cos(theta)
    return x, y
end

function math.ToRadians(degrees)
    return degrees * 0.017453292519943295769236907684886
end
function math.ToDegrees(radians)
    return radians * 57.295779513082320876798154814105
end

function math.clamp(value,min,max)
    value = value or 0
    min = min or 0
    max = max or 0
    value = math.max(value,min)
    value = math.min(value,max)
    return value
end
