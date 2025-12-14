local color = {}
local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'

color.TRANSPARENT = 0x000000
color.WHITE = 0xFFFFFF
color.GRAY = 0x808080
color.BLACK = 0x000000

color.RED = 0xFF0000
color.BLUE = 0x0000FF
color.GREEN = 0x008000
color.PINK = 0xFFC0CB
color.MAGENTA = 0xFF00FF
color.PURPLE = 0x800080
color.LIME = 0x00FF00
color.YELLOW = 0xFFFF00
color.ORANGE = 0xFFA500
color.CYAN = 0x00FFFF

function color.getHexString(int, digits)
    return helper.callMethodFromClass('StringTools', 'hex', {int, digits})
end

function color.rgbToHex(rgb)
    for i, channel in ipairs(rgb) do
        if channel == nil then
            debug.warn('nil_param', {'rgb, defaulted to 0'}, 'color.rgbToHex:1:'.. i)
            rgb[i] = helper.resolveDefaultValue(channel, 0)
        elseif channel < 0 then
            rgb[i] = math.abs(rgb)
        end
    end

    return tonumber('0x'.. string.format('%02X%02X%02X', unpack(rgb)))
end

function color.argbToRGB(argb) 
    if color.usingARGB(argb) then
        return bit.band(argb, 0xFFFFFF)
    end
    return argb
end

function color.rgbToARGB(rgb, alpha)
    if color.usingRGB(rgb) then
        alpha = alpha or 1
        return bit.bor(bit.lshift(alpha * 255, 24), rgb)
    end
    return rgb
end

function color.usingARGB(int)
    return #color.getHexString(int) > 6
end

function color.usingRGB(int)
    return not color.usingARGB(int)
end

function color.extractChannels(int)
    local alpha = color.usingARGB(int) and bit.band(bit.rshift(int, 24), 0xFF) or 0
    return {
        alpha = alpha,
        red = bit.band(bit.rshift(int, 16),  0xFF),
        green = bit.band(bit.rshift(int, 8), 0xFF),
        blue = bit.band(int, 0xFF)
    }
end

function color.getAlpha(int)
    return color.extractChannels(int).alpha
end

function color.getRed(int)
    return color.extractChannels(int).red
end

function color.getBlue(int)
    return color.extractChannels(int).blue
end

function color.getGreen(int)
    return color.extractChannels(int).green
end

function color.setColor(tag, col)
    setProperty(tag ..'.color', color.argbToRGB(col))
end

function color.setColorTransform(tag, mult, offset)
    if tag ~= nil then
        mult = helper.resizeTable(helper.fillTable(mult or {}, 1, 4), 4)
        offset = helper.resizeTable(helper.fillTable(offset or {}, 1, 4), 4)
        args = helper.concat(mult, offset) 
        helper.callMethod(tag ..'.setColorTransform', args)
        
        return
    end
    debug.error('nil_param', {'tag'}, 'color.setColorTransform:1')
end

return color