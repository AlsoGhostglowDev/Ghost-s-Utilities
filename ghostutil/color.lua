---@meta color
---@author GhostglowDev

---@class Color
local color = {}

local d = require "ghostutil.debug"

local _h = require "ghostutil._backend.helper"

color.WHITE = "0xFFFFFFFF"
color.GRAY = "0xFF808080"
color.BLACK = "0xFF000000"

color.RED = "0xFFFF0000"
color.BLUE = "0xFF0000FF"
color.GREEN = "0xFF008000"
color.PINK = "0xFFFFC0CB"
color.MAGENTA = "0xFFFF00FF"
color.PURPLE = "0xFF800080"
color.LIME = "0xFF00FF00"
color.YELLOW = '0xFFFFFF00'
color.ORANGE = "0xFFFFA500"
color.CYAN = "0xFF00FFFF"

---Sets an object color to the target value
---@param spr string Object
---@param val string The target color. (RRGGBB)
function color.setSpriteColor(spr, val)
    if spr ~= nil or spr ~= '' then setProperty(spr..".color", getColorFromHex (val or "FFFFFF")) else
        d.error("color.setSpriteColor:1: Expected a value")
    end
end

---Sets an object's color transform to the target values
---@param spr string Object
---@param multipliers table<number> Values: {redMult, blueMult, greenMult, alphaMult}
---@param offsets table<number> Values: {redOffset, blueOffset, greenOffset, alphaOffset}
function color.setSpriteColorTransform(spr, multipliers, offsets)
    local isLuaSprite = luaSpriteExists(spr)
    local isVar = _h.variableExists(spr)

    if spr ~= nil then runHaxeCode("game."..(isLuaSprite and "getLuaObject("..spr..")" or (isVar and 'getVar("'.. spr ..'")' or spr))..".setColorTransform("..(multipliers[1] or 0)..", "..(multipliers[2] or 0)..", "..(multipliers[3] or 0)..", "..(multipliers[4] or 0)..", "..(offsets[1] or 0)..", "..(offsets[2] or 0)..", "..(offsets[3] or 0)..", "..(offsets[4] or 0)..");") else
        d.error("color.setSpriteColorTransform:1: Expected a value")
    end

    for i = 1, 4 do
        if multipliers[i] == nil then d.warning("color.setSpriteColorTransform:2["..i.."]: Given an empty value, nil -> 0") end
        if offsets[i] == nil then d.warning("color.setSpriteColorTransform:3["..i.."]: Given an empty value, nil -> 0") end
    end
end

---Returns an object color
---@param spr string
---@return string 
---@nodiscard
function color.getSpriteColor(spr)
    if spr ~= nil then 
        return getProperty(spr..".color") 
    end
    
    d.error("color.getSpriteColor:1: Expected a value")
    return ""
end

---Converts RGB to the Hex format (RRGGBB).
---@param r integer
---@param g integer
---@param b integer
---@return string
---@nodiscard
function color.rgbToHex(r, g, b)
    if r == nil or g == nil or b == nil then
        d.warning("color.rgbToHex: Given an empty value. nil -> 255")
    end
    
    return string.format("%02X%02X%02X", (r or 255), (g or 255), (b or 255))
end

return color