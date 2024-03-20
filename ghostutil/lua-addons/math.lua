---@meta math
---@author GhostglowDev, Execute

---@class mathlib
local mt = setmetatable({}, {
    __index = math,
})

local d = require "ghostutil.Debug"

---Used to account for floating-point inaccuracies.
mt.epsilon = 0.0000001
---Maximum value of an integer
mt.max_int = 0x7FFFFFFF
---Minimum value of an integer
mt.min_int = -mt.max_int

---Maximum value of a floating number
mt.max_float = 1.79e+308
---Minimum value of a floating number
mt.min_float = 0.0000000001

---Imaginary number, i
mt.imaginary = mt.sqrt(-1)

---Infinity
mt.infinity = mt.huge
---Negative Infnity
mt.negative_infinity = -mt.infinity

---Linear Interpolation
---@param a number Point A
---@param b number Point B
---@param r number Ratio
---@return number
mt.lerp = function(a, b, r)
    return a + (r * (60 / getPropertyFromClass("Main", "fpsVar.currentFPS"))) * (b - a)
end

---Positive to Negative and Negative to Positive.
---@param self number Value
---@return number
mt.invert = function(self)
    return self * -1
end

---Checks if the given number is a positive number (0 is not positive nor negative so it will return false.)
---@param self number Value
---@return boolean
mt.ispositive = function(self)
    return (self > 0)
end

---Checks if the given number is a negative number (0 is not positive nor negative so it will return false.)
---@param self number Value
---@return boolean
mt.isnegative = function(self)
    return (self < 0)
end

---Factorial of a number (Integers only)
---@param self number To be factored
---@return integer
---@author Execute
mt.fact = function(self)
    return self <= 1 and 1 or (self * mt.fact(self-1))
end

---Bound a number by a minimum and maximum. Ensures that this number is no smaller than the minimum, and no larger than the maximum
---@param self number Value
---@param mx number Maximum
---@param mn number Minimum
---@return number
mt.boundto = function(self, mx, mn)
    return mt.max(mn, mt.min(mx, self))
end

---Limits the amount of decimals
---@param self number Number
---@param dc number Target amount of decimals (Optional, default = 2)
---@return number
mt.floordecimal = function(self, dc)
    return tonumber(string.format('%.'..(dc or 2)..'f', self))
end

mt.round = function(self)
    return math.floor(self+0.5)
end

---Returns the midpoint of a certain distance
---@param x number Point 1
---@param y number Point 2
---@return number
mt.getmidpoint = function(x, y)
    return (x + y) / 2
end

return mt