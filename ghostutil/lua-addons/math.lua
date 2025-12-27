local util = require 'ghostutil.util'

--[=[
    ########################
        LUA ADDON - MATH
    ########################
]=]

math.epsilon = 1e-12
math.max_float = 1.79e308
math.max_int = 0x7FFFFFFF
math.min_float = 4.94e-324
math.min_int = -0x7FFFFFFF

math.infinity = math.huge
math.negative_infinity = -math.huge
math.nan = 0/0

function math.lerp(a, b, ratio)
    ratio = math.bound(ratio, 0, 1)
    return a + (ratio * (b - a))
end

function math.fpslerp(a, b, ratio)
    ratio = math.bound(ratio, 0, 1)
    return a + (ratio * (60 / util.getFps())) * (b - a)
end

function math.isfinite(n)
    return (n ~= math.infinity
            and n ~= math.negative_infinity
            and n ~= math.nan)
end

function math.isnan(n)
    return util.isnan(n)
end

function math.invert(n)
    return -n
end

function math.ispositive(n)
    return n > 0
end

function math.isnegative(n)
    return n < 0
end

function math.factorial(n)
    n = math.floor(n)
    return n <= 1 and 1 or (n * math.factorial(n - 1))
end

function math.bound(n, min, max)
    return math.max(math.min(n, min), max)
end
math.clamp = math.bound

function math.floordecimal(n, decimals)
    return tonumber(string.format('%.'.. (decimals or 2) ..'f', n))
end

function math.round(n)
    return math.floor(n + 0.5)
end

function math.midpoint(a, b)
    return (a + b) / 2
end

function math.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function math.distance3(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function math.dot(ax, ay, bx, by)
    return ax * bx + ay * by
end

function math.dot3(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end

function math.equals(a, b, diff)
    diff = diff or math.epsilon
    return math.abs(a - b) <= diff
end

function math.area(w, h)
    return w * h
end

function math.volume(w, h, l)
    return w * h * l
end

function math.inbounds(n, min, max)
    return n >= min and n <= max 
end

function math.iseven(n)
    return n % 2 == 0
end

function math.isodd(n)
    return n % 2 ~= 0
end

function math.boundedadd(n, a, min, max)
    return math.bound(n + a, min, max)
end

function math.samesign(a, b)
    return math.signof(a) == math.signof(b)
end

function math.signof(n)
    return n < 0 and -1 or 1
end

return math