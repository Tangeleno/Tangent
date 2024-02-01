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
    return x + cosA * distanceTo, y + sinA * distanceTo
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

function math.Clamp(value, min, max)
    value = value or 0
    min = min or 0
    max = max or 0
    value = math.max(value, min)
    value = math.min(value, max)
    return value
end

--- Calculates the squared distance between two points in 3D space.
---@param x1 number|Coordinates|spawn: The x-coordinate of the first point, a coordinate table, or a Spawn.
---@param y1 number|Coordinates|spawn: The y-coordinate of the first point or the second coordinates/Spawn.
---@param z1? number: The z-coordinate of the first point (if using coordinates).
---@param x2? number|Coordinates|spawn: The y-coordinate of the first point or the second coordinates/Spawn.
---@param y2? number: The y-coordinate of the second point (if using coordinates).
---@param z2? number: The z-coordinate of the second point (if using coordinates).
---@return number: The squared distance between the two points.
function math.DistanceSquared(x1, y1, z1, x2, y2, z2)
    ---@param tableValue Coordinates|spawn
    ---@return Coordinates
    local function getValuesFromTableType(tableValue)
        ---@type Coordinates
        local result
        if type(tableValue) == "userdata" then
            result = { X = tableValue.X(), Y = tableValue.Y(), Z = tableValue.Z() }
        else
            ---@type Coordinates
            ---@diagnostic disable-next-line: assign-type-mismatch
            result = tableValue
        end
        return result
    end
    ---@type Coordinates,Coordinates
    local coord1, coord2
    if type(x1) == "table" or type(x1) == "userdata" then
        --both spawn and coordinates are tables
        --spawn however the values are functions
        coord1 = getValuesFromTableType(x1)

        --the first parameter is ta table, so at most we're going to end up using y1,z1,x2
        --handle the easiest case first, the second parameter being a table
        if type(y1) == "table" or type(y1) == "userdata" then
            coord2 = getValuesFromTableType(y1)
        elseif type(y1) == "number" then
            ---@diagnostic disable-next-line: assign-type-mismatch
            coord2 = { X = y1, Y = z1, Z = x2 }
        else
            error(string.format("Invalid value for parameter y1, expected number or table got %s value is %s", type(y1),y1))
        end
    else
        --the first three parameters are numbers
        ---@diagnostic disable-next-line: assign-type-mismatch
        coord1 = { X = x1, Y = y1, Z = z1 }
        if type(x2) == "table" or type(x2) == "userdata" then
            coord2 = getValuesFromTableType(x2)
        else
            --else they're numbers
            ---@diagnostic disable-next-line: assign-type-mismatch
            coord2 = { X = x2, Y = y2, Z = z2 }
        end
    end
    
    if coord1.X == nil or coord1.Y == nil or coord1.Z == nil or coord2.X == nil or coord2.Y == nil or coord2.Z == nil then
        return -1
    end

    local x = coord1.X - coord2.X
    local y = coord1.Y - coord2.Y
    local z = coord1.Z - coord2.Z

    return x * x + y * y + z * z
end

--- Calculates the distance between two points in 3D space.
---@param x1 number|Coordinates|spawn: The x-coordinate of the first point, a coordinate table, or a Spawn.
---@param y1 number|Coordinates|spawn: The y-coordinate of the first point or the second coordinates/Spawn.
---@param z1 number: The z-coordinate of the first point (if using coordinates).
---@param x2 number|Coordinates|spawn: The y-coordinate of the first point or the second coordinates/Spawn.
---@param y2 number: The y-coordinate of the second point (if using coordinates).
---@param z2 number: The z-coordinate of the second point (if using coordinates).
---@return number: The distance between the two points.
function math.Distance(x1, y1, z1, x2, y2, z2)
    local distanceSquared = math.DistanceSquared(x1, y1, z1, x2, y2, z2)

    return math.sqrt(distanceSquared)
end
