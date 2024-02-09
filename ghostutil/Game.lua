---@meta Game
---@author GhostglowDev

---An addon to FunkinLua
---@class Game
local game = {}

local c = require "ghostutil.Color"
local d = require "ghostutil.Debug"
local o = require "ghostutil.OutdateHandler"
local m = require "ghostutil.lua-addons.math"

local didFix = false

function _gcall(func)
	if func ~= "destroy" then return end 
    if didFix then
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
    end
end

---Tweens an object's scale
---@param tags table<string>|string Two tags, {tag1, tag2}
---@param var string The object
---@param vals table<number>|number Values, {x, y}
---@param duration number The duration it takes to complete
---@param ease string FlxEase
---@author GhostglowDev, Flain
game.doTweenScale = function(tags, var, vals, duration, ease)
    doTweenX((type(tags) == "table" and tags[1] or tags .. "scalex"), var..".scale", (type(vals) == "table" and vals[1] or vals), duration, ease)
    doTweenY((type(tags) == "table" and tags[2] or tags .. "scaley"), var..".scale", (type(vals) == "table" and vals[2] or vals), duration, ease) 
end

---Tweens an object's position
---@param tags table<string>|string Two tags, {tag1, tag2}
---@param var string The object
---@param vals table<number>|number Values, {x, y}
---@param duration number The duration it takes to complete
---@param ease string FlxEase
---@author GhostglowDev, Flain
game.doTweenPosition = function(tags, var, vals, duration, ease)
    doTweenX((type(tags) == "table" and tags[1] or tags .. "x"), var, (type(vals) == "table" and vals[1] or vals), duration, ease)
    doTweenY((type(tags) == "table" and tags[2] or tags .. "y"), var, (type(vals) == "table" and vals[2] or vals), duration, ease)
end

---Fixes the shader coord when the game is resized
game.fixShaderCoord = function()
    didFix = true
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function() {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
end

---Returns the current health color of the target in hex
---@param char string Dad or Boyfriend
---@return string
game.getHealthColor = function(char)
    char = char:lower()
    if char == "bf" then char = "boyfriend" end
    if (char ~= "boyfriend" and char ~= "dad") then 
        d.error("game.getHealthColor:1: Unknown character: '"..char.."'")
        return ""
    else
        return c.rgbToHex(getProperty(char..".healthColorArray[0]"), getProperty(char..".healthColorArray[1]"), getProperty(char..".healthColorArray[2]"))
    end
end

---Changes the health bar colors
---@param left string Color
---@param right string Color
game.setHealthBarColors = function(left, right)
    if left == nil or right == nil then else
        if version >= "0.7.0" then setHealthBarColors(left, right) else
            runHaxeCode("game.healthBar.createFilledBar("..getColorFromHex(left)..", "..getColorFromHex(right)..")")
        end
    end
end

---Checks if a certain LUA object exists
---@param obj string LUA object
---@return boolean
game.luaInstanceExists = function(obj)
    local exists = false
    for i = 1, 3 do
        local checkExists = (i == 1 and luaSpriteExists or (i == 2 and luaSoundExists or luaTextExists))
        if checkExists(obj) then
            exists = true
            break
        end
    end

    return exists
end

---Fetches the current FPS
---@return string FPS
game.getFps = function()
    return getPropertyFromClass("Main", "fpsVar.currentFPS")
end

---Fetches the current memory
---@return number Memory 
game.getMemory = function()
    local r = ""
    if version >= "0.7.0" then
        r = getPropertyFromClass("Main", "fpsVar.memoryMegas")
    else
        addHaxeLibrary("System", "openfl.system")
        r = runHaxeCode("return System.totalMemory;")
    end
    return r
end

---Fetches the current accuracy
---@return number Accuracy
game.getAccuracy = function()
    return m.floordecimal(rating * 100)
end

---Sets the sprite's origin to its center - useful after adjusting `scale` to make sure rotations work as expected.
---@param obj string Object
game.centerOrigin = function(obj)
    setOrigin(getProperty(obj..".frameWidth") * 0.5, getProperty(obj..".frameHeight") * 0.5)
end

---Sets the sprite's origin position
---@param obj string Object
---@param newOri table New Origin
game.setOrigin = function(obj, newOri)
    setProperty(obj..".origin.x", newOri[1]) setProperty(obj..".origin.y", newOri[2])
end

---Returns the values of the origin position of the target object using a table
---@param obj string Object
---@return table
game.getOrigin = function(obj)
    return {
        x = getProperty(obj..".origin.x"),
        y = getProperty(obj..".origin.y")
    }
end

---Sets the sprite's position
---@param obj string Object
---@param newPos table<number> New Position
game.setPosition = function(obj, newPos)
    setProperty(obj..".x", newPos[1]) setProperty(obj..".y", newPos[2])
end

---Returns the values of the position of the target object using a table
---@param obj string Object
---@return table<number>
game.getPosition = function(obj)
    return {
        x = getProperty(obj..".x"),
        y = getProperty(obj..".y")
    }
end

game.getObjectScale = function(obj)
    return {x = getProperty(obj..".scale.x"), y = getProperty(obj..".scale.y")}
end

---Sets the camera target to the target character
---@param target string
---@author GhostglowDev, Flain
game.cameraSetTarget = function(target)
    target = target:lower()
    if target == "gf" or target == "girlfriend" then
        local camPos = {
            getMidpointX("gf") + getProperty("gf.cameraPosition[0]") + getProperty("girlfriendCameraOffset[0]"),
            getMidpointY("gf") + getProperty("gf.cameraPosition[1]") + getProperty("girlfriendCameraOffset[1]")
        }
        game.setPosition("camFollow", camPos)
        callOnLuas("onMoveCamera", {"gf"})
    else cameraSetTarget(target) end
end

---Calls a function from the PlayState instance
---@param funcToRun string The function to call
---@param args table<any> The arguments; can be as many as the function needs
game.callMethod = function(funcToRun, args)
    game.callMethodFromClass("PlayState", funcToRun, args)
end

---Calls a function from a `className` class
---@param className string The class
---@param funcToRun string The function to call
---@param args table<any> The arguments; can be as many as the function needs
---@author GhostglowDev, Laztrix, galactic_2005
game.callMethodFromClass = function(className, funcToRun, args)
    if version >= "0.7.0" then
        if className == "PlayState" then
            callMethod(funcToRun, args)
        else
            callMethodFromClass(className, funcToRun, args) 
        end
    else
        local function formatString(s)
            return type(s) == "string" and string.format("'%s'", s) or s
        end
        
        local function formatArrays(tbl)
            if type(tbl) ~= "table" then return tbl end
            local str = "["
            for i, v in ipairs(tbl) do
                str = str .. (type(v) == "table" and formatArrays(v) or formatString(v)) .. (i == #tbl and "]" or ",")
            end
            return str 
        end
    
        -- thanks laztrix and galactic_2005 for shortening this mess
        local argsStr = ""
        for i, v in ipairs(args) do
            argsStr = argsStr .. formatArrays(formatString(v))
            .. (i == #args and "" or ", ")
        end

        splitStr = stringSplit(className, ".")
        className = splitStr[#splitStr]
    
        local a = o.classBasedOnVersion(false, className)
        if className ~= "PlayState" then
            o.addHaxeLibrary(className)
        else a = "game" end

        runHaxeCode(a ..".".. funcToRun .."(".. argsStr ..");")
    end
end

---Starts.. a tween.
---@param tag string The tag used for cancelling the tween and callbacks
---@param var string The variable to tween
---@param values table<any> The values to tween
---@param duration? number The time it takes to complete
---@param options? table<any> The tween options
---@author GhostglowDev, galactic_2005
game.startTween = function(tag, var, values, duration, options)
    if version >= "0.7.0" then
        startTween(tag, var, values, duration, options)
        return
    end

    if type(tag) ~= "string" then d.error("Expected string, got ".. type(tag) .." instead.") end
    if type(var) ~= "string" then d.error("Expected string, got ".. type(var) .." instead.") end
    if type(values) ~= "table" then d.error("Expected table, got ".. type(tag) .." instead.") end

    duration = duration or 1
    options = options or {}

    local function serialize(v, t)
        if t == "string" then
            return type(v) == "string" and ("'%s'"):format(v) or v
        elseif t == "array" or t == "table" then
            if type(v) ~= "table" then return v end
            local str = "["
            for i, value in ipairs(v) do
                str = str .. serialize(value, type(value)) .. (i == #value and "]" or ",")
            end
            return str
        end
        return v
    end

    local function get_length(tbl)
        local len = 0
        for _ in pairs(tbl) do
            len = len + 1
        end
        return len
    end

    local function getFlxTweenType(ttype)
        local types = {
            oneshot = 8,
            looping = 2,
            backward = 16,
            persist = 1,
            pingpong = 4
        }

        for k, v in pairs(types) do
            if ttype == k or tonumber(ttype) == v then
                return v
            end
        end

        return "8"
    end

    local function getFlxEaseByString(ease)
        local eases = {
            ["back"] = "back", ["bounce"] = "bounce", ["circ"] = "circ", ["cube"] = "cube",
            ["elastic"] = "elastic", ["expo"] = "expo", ["quad"] = "quad", ["quart"] = "quart",
            ["quint"] = "quint", ["sine"] = "sine", ["smoothstep"] = "smoothStep", ["smootherstep"] = "smootherStep"
        }

        local easeEndings = {
            "InOut", "In", "Out"
        }

        local easeEnd = ""
        for _, value in ipairs(easeEndings) do
            if stringEndsWith(ease:lower(), value:lower()) then
                easeEnd = value
                break
            end
        end

        local easeNew = ease:sub(1, #ease - #easeEnd)
        if eases[easeNew:lower()] then
            easeNew = eases[easeNew:lower()]
            return "FlxEase." .. easeNew .. easeEnd
        end
        return "FlxEase.linear"
    end

    local function getOptionValue(key)
        for k, v in pairs(options) do
            if k == key then
                return v
            end
        end
        return "null"
    end

    local valueStr = ""
    local i = 0
    for k, v in pairs(values) do
        i = i + 1
        valueStr = (valueStr .. k .. ": " .. serialize(serialize(v, "string"), "array")
        ..(i == get_length(values) and "" or ", "))
    end

    if game.luaInstanceExists(var) then
        var = "game.getLuaObject(".. serialize(var, "string") ..");"
    end

    runHaxeCode([[
        game.modchartTweens.set(']].. tag ..[[',
            FlxTween.tween(]].. var ..[[, {]].. valueStr ..[[}, ]].. duration ..[[, {
                type: ]].. getFlxTweenType(getOptionValue("type")) ..[[,
                ease: ]].. getFlxEaseByString(getOptionValue("ease")) ..[[,
                startDelay: ]].. getOptionValue("startDelay") ..[[,
                loopDelay: ]].. getOptionValue("loopDelay") ..[[,

                onUpdate: function(twn:FlxTween) {
                    if (']].. getOptionValue("onUpdate") ..[[' != 'null') game.callOnLuas(']].. getOptionValue("onUpdate") ..[[', [']].. tag ..[[', ']].. var ..[[']);
                },
                onStart: function(twn:FlxTween) {
                    if (']].. getOptionValue("onStart") ..[[' != 'null') game.callOnLuas(']].. getOptionValue("onStart") ..[[', [']].. tag ..[[', ']].. var ..[[']);
                },
                onComplete: function(twn:FlxTween) {
                    if (']].. getOptionValue("onComplete") ..[[' != 'null') game.callOnLuas(']].. getOptionValue("onComplete") ..[[', [']].. tag ..[[', ']].. var ..[[']);
                    if (']].. getFlxTweenType(getOptionValue("type")) ..[[' != "8" || ]].. getFlxTweenType(getOptionValue("type")) ..[[ != "16")
                        game.modchartTweens.remove(']].. tag ..[[');
                }
            })
        );
    ]])
end

return game