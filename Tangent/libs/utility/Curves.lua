--curves.lua
--[[ Sample JSON
[
  {
    "name": "customCurve1",
    "interpolation":"linear",
    "points": [
      [0,0],
      [1,1],
      [2,0]
    ]
  },
  {
    "name": "customCurve2",
    "interpolation":"bezier",
    "points": [
      [0,1],
      [1,0.5],
      [2,0]}
    ]
  }
]
]]

local cjson = require "rapidjson"

local Curves = {}

--- Linear curve
-- @param x Input value
-- @param m Slope
-- @param b Intercept
-- @return Resulting value
Curves.linear = function(x, m, b) return m * x + b end

--- Step function with base value
-- @param x Input value
-- @param threshold Threshold value where the step occurs
-- @param base The base y-value of the step before the threshold
-- @return Resulting y-value
Curves.step = function(x, threshold, base) return x < threshold and base or 1 end

--- Logarithmic curve
-- @param x Input value
-- @param base Logarithmic base (defaults to e)
-- @return Resulting value
Curves.logarithmic = function(x, base, clamp)
    local result = math.log(x + 1) / math.log(base or math.exp(1))
    if result < clamp then
        return clamp
    end
    return result
end

--- Exponential curve
-- @param x Input value
-- @param base Base of the exponential function
-- @return Resulting value
Curves.exponential = function(x, base) return base and base ^ x or math.exp(x) end

--- Quadratic curve
-- @param x Input value
-- @param a, b, c Coefficients
-- @return Resulting value
Curves.quadratic = function(x, a, b, c) return a * x ^ 2 + b * x + c end

--- Gaussian curve
-- @param x Input value
-- @param mean Mean value
-- @param sigma Standard deviation
-- @return Resulting value
Curves.gaussian = function(x, mean, sigma) return math.exp(-((x - mean) ^ 2) / (2 * sigma ^ 2)) end

--- Hyperbolic tangent curve
-- @param x Input value
-- @return Resulting value
Curves.tanh = function(x) return math.tanh(x) end

--- Inverse curve
-- @param x Input value
-- @return Resulting value
Curves.inverse = function(x) return 1 / x end

--- Cosine curve
-- @param x Input value
-- @param frequency Frequency
-- @param amplitude Amplitude
-- @return Resulting value
Curves.cosine = function(x, frequency, amplitude) return amplitude * math.cos(frequency * x) end

--- Sine curve
-- @param x Input value
-- @param frequency Frequency
-- @param amplitude Amplitude
-- @return Resulting value
Curves.sine = function(x, frequency, amplitude) return amplitude * math.sin(frequency * x) end

--- Cubic curve
-- @param x Input value
-- @param a, b, c, d Coefficients
-- @return Resulting value
Curves.cubic = function(x, a, b, c, d) return a * x ^ 3 + b * x ^ 2 + c * x + d end

--- Hyperbolic sine curve
-- @param x Input value
-- @return Resulting value
Curves.sinh = function(x) return math.sinh(x) end

--- Hyperbolic cosine curve
-- @param x Input value
-- @return Resulting value
Curves.cosh = function(x) return math.cosh(x) end

--- Power curve
-- @param x Input value
-- @param exponent Exponent
-- @return Resulting value
Curves.power = function(x, exponent) return x ^ exponent end

--- Absolute curve
-- @param x Input value
-- @return Resulting value
Curves.absolute = function(x) return math.abs(x) end

--- Logistic curve
-- @param x Input value
-- @param a Scaling factor
-- @return Resulting value
Curves.logistic = function(x, a) return 1 / (1 + math.exp(-a * x)) end

--- Smoothstep curve
-- @param x Input value
-- @param degree Degree of the polynomial
-- @return Resulting value
Curves.smoothstep = function(x, degree) return x ^ degree * (x * (x * (degree * 2 - degree * 3) + degree * 3) - degree) end

-- Function to read JSON file content
local function readJsonFile(filename)
    local file = assert(io.open(filename, "r"))
    local content = file:read("*all")
    file:close()
    return content
end


--- Function to interpolate a linear curve with boundary handling through extrapolation
-- @param x Input value
-- @param points Table of points defining the curve
-- @return Resulting value
local function linearInterpolation(x, points)
    -- Find the interval
    for i = 1, #points - 1 do
        local x1, y1 = points[i][1], points[i][2]
        local x2, y2 = points[i + 1][1], points[i + 1][2]

        if x >= x1 and x <= x2 then
            return y1 + (y2 - y1) * ((x - x1) / (x2 - x1))
        end
    end

    -- Extrapolation for left boundary
    if x < points[1][1] then
        local x1, y1 = points[1][1], points[1][2]
        local x2, y2 = points[2][1], points[2][2]
        local m = (y2 - y1) / (x2 - x1)
        return y1 + m * (x - x1)
    end

    -- Extrapolation for right boundary
    if x > points[#points][1] then
        local x1, y1 = points[#points - 1][1], points[#points - 1][2]
        local x2, y2 = points[#points][1], points[#points][2]
        local m = (y2 - y1) / (x2 - x1)
        return y1 + m * (x - x1)
    end
end

--- Function to interpolate a cubic Bezier curve (3 control points)
-- @param t Parameter ranging from 0 to 1
-- @param points Control points defining the curve
-- @return Resulting value
local function bezierInterpolation3(t, points)
    local u = 1 - t
    return u * u * points[1][2] + 2 * u * t * points[2][2] + t * t * points[3][2]
end
--- Function to interpolate a cubic Bezier curve (4 control points)
-- @param t Parameter ranging from 0 to 1
-- @param points Control points defining the curve
-- @return Resulting value
local function bezierInterpolation4(t, points)
    local u = 1 - t
    return u * u * u * points[1][2] + 3 * u * u * t * points[2][2] + 3 * u * t * t * points[3][2] +
        t * t * t * points[4][2]
end
--- Function to interpolate a cubic Bezier curve (5 control points)
-- @param t Parameter ranging from 0 to 1
-- @param points Control points defining the curve
-- @return Resulting value
local function bezierInterpolation5(t, points)
    local u = 1 - t
    return u ^ 4 * points[1][2] + 4 * u ^ 3 * t * points[2][2] + 6 * u ^ 2 * t ^ 2 * points[3][2] + 4 * u * t ^ 3 *
        points[4][2] + t ^ 4 * points[5][2]
end
--- Function to interpolate a cubic Bezier curve (6 control points)
-- @param t Parameter ranging from 0 to 1
-- @param points Control points defining the curve
-- @return Resulting value
local function bezierInterpolation6(t, points)
    local u = 1 - t
    return u ^ 5 * points[1][2] + 5 * u ^ 4 * t * points[2][2] + 10 * u ^ 3 * t ^ 2 * points[3][2] +
        10 * u ^ 2 * t ^ 3 * points[4][2] + 5 * u * t ^ 4 * points[5][2] + t ^ 5 * points[6][2]
end
--- Function to interpolate a cubic Bezier curve (8 control points)
-- @param t Parameter ranging from 0 to 1
-- @param points Control points defining the curve
-- @return Resulting value
local function bezierInterpolation8(t, points)
    local u = 1 - t
    return u ^ 7 * points[1][2] + 7 * u ^ 6 * t * points[2][2] + 21 * u ^ 5 * t ^ 2 * points[3][2] +
        35 * u ^ 4 * t ^ 3 * points[4][2] + 35 * u ^ 3 * t ^ 4 * points[5][2] + 21 * u ^ 2 * t ^ 5 * points[6][2] +
        7 * u * t ^ 6 * points[7][2] + t ^ 7 * points[8][2]
end

--- Function to add a custom curve to the Curves table
-- @param name Name of the custom curve
-- @param curveType Type of the curve (e.g., "linear", "bezier")
-- @param points Control points defining the curve
local function addCustomCurve(name, curveType, points)
    if curveType == "linear" then
        Curves[name] = function(x) return linearInterpolation(x, points) end
    elseif curveType == "bezier" then
        local n = #points
        if n == 3 then
            Curves[name] = function(t) return bezierInterpolation3(t, points) end
        elseif n == 4 then
            Curves[name] = function(t) return bezierInterpolation4(t, points) end
        elseif n == 5 then
            Curves[name] = function(t) return bezierInterpolation5(t, points) end
        elseif n == 6 then
            Curves[name] = function(t) return bezierInterpolation6(t, points) end
        elseif n == 8 then
            Curves[name] = function(t) return bezierInterpolation8(t, points) end
        else
            error("Unsupported number of control points: " .. n)
        end
    end
end

-- Method to load custom curves from a JSON file
-- @param jsonFile Path to the JSON file containing custom curve definitions
function Curves.loadCustomCurves(jsonFile)
    local content = readJsonFile(jsonFile)
    local curvesData = cjson.decode(content)

    -- Process and add each custom curve
    for _, curve in ipairs(curvesData) do
        addCustomCurve(curve.name, curve.interpolation, curve.points)
    end
end

return Curves
