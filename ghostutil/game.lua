---@meta game
---@author GhostglowDev

---An addon to FunkinLua
---@class Game
local game = {}

local c = require "ghostutil.color"
local d = require "ghostutil.debug"
local o = require "ghostutil.outdate-handler"
local m = require "ghostutil.lua-addons.math"

local _h = require "ghostutil._backend.helper"

local function characterDance(forced)
    forced = (forced == nil) and false or forced
    for _, charData in ipairs(game.luaChars) do
        local tag = charData[1]
        if  (((not stringStartsWith(getProperty(tag .. ".animation.name"), 'sing')) 
            or (stringStartsWith(getProperty(tag .. '.animation.name'), 'sing') and 
            getProperty(tag .. '.animation.finished'))) and
            (curBeat % getProperty(tag .. ".danceEveryNumBeats") == 0)) or forced then
                runHaxeCode('getVar("'.. tag ..'").dance();') -- doing rhc for 0.6.3
        end
    end
end

local function characterSing(tag, id, data)
    if not getPropertyFromGroup('notes', id, 'noAnimation') then
        playAnim(tag, getProperty('singAnimations')[(data or 0)+1] .. getPropertyFromGroup('notes', id, 'animSuffix'), true)
        setProperty(tag ..'.holdTimer', 0)
    end
end

local function characterMiss(tag, id, data)
    if not getPropertyFromGroup('notes', id, 'noAnimation') 
       and getProperty(tag .. '.hasMissAnimations')
    then
        playAnim(tag, getProperty('singAnimations')[(data or 0)+1] .. 'miss' .. getPropertyFromGroup('notes', id, 'animSuffix'), true)
        setProperty(tag ..'.holdTimer', 0)
    end
end

game.didFix = false
game.luaChars = {} -- tag, isPlayer, noteType
game.customInstances = {} -- tag

function __game_gcall(func, args)
    if func == "createpost" then
        addHaxeLibrary('Timer', 'haxe')
    elseif func == "destroy" then
        if game.didFix then
            runHaxeCode([[
                FlxG.signals.gameResized.remove(fixShaderCoordFix);
                return;
            ]])
        end
    elseif func == "beathit" then
        characterDance()
    elseif func == "bfhit" or func == "dadhit" then
        for _, charData in ipairs(game.luaChars) do
            if (charData[3] == args[3]) and getPropertyFromGroup('notes', args[1], 'mustPress') == charData[2] then
                characterSing(charData[1], args[1], args[2])
            end
        end
    elseif func == "bfmiss" then
        for _, charData in ipairs(game.luaChars) do
            if (charData[3] == args[3]) then
                characterMiss(charData[1], args[1], args[2])
            end
        end
    elseif func == 'counttick' then
        characterDance(true)
    end
end

---Tweens an object's scale
---@param tags table<string>|string Two tags, {tag1, tag2}
---@param var string The object
---@param vals table<number>|number Values, {x, y}
---@param duration number The duration it takes to complete
---@param ease string FlxEase
---@author GhostglowDev, Flain
function game.doTweenScale(tags, var, vals, duration, ease)
    doTweenX(_h.retTbl(tags, 1, 'scalex'), var ..".scale", _h.retTbl(vals, 1), duration, ease)
    doTweenY(_h.retTbl(tags, 2, 'scaley'), var ..".scale", _h.retTbl(vals, 2), duration, ease) 
end

---Tweens an object's position
---@param tags table<string>|string Two tags, {tag1, tag2}
---@param var string The object
---@param vals table<number>|number Values, {x, y}
---@param duration number The duration it takes to complete
---@param ease string FlxEase
---@author GhostglowDev, Flain
function game.doTweenPosition(tags, var, vals, duration, ease)
    doTweenX(_h.retTbl(tags, 1, 'x'), var, _h.retTbl(vals, 1), duration, ease)
    doTweenY(_h.retTbl(tags, 2, 'y'), var, _h.retTbl(vals, 2), duration, ease)
end

function game.noteTweenScale(tags, note, vals, duration, ease)
    doTweenX(_h.retTbl(tags, 1, 'x'), "strumLineNotes.members[".. note .."].scale", _h.retTbl(vals, 1), duration, ease)
    doTweenY(_h.retTbl(tags, 2, 'y'), "strumLineNotes.members[".. note .."].scale", _h.retTbl(vals, 2), duration, ease)
end 

---Fixes the shader coord when the game is resized
function game.fixShaderCoord()
    game.didFix = true
    runHaxeCode([[
        var resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        var fixShaderCoordFix = function() {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
end

function game.setCamFilters(camera, filters, shaderVals)
    local m = [[

        ]]
    local filterVars, itime = "", ""
    local main = "game.".. getCameraFromString(camera) .. (version >= '0.7.2' and ".filters = [" or '._filters = [')
    for i, filter in ipairs(filters) do
        initLuaShader(filter)
        filterVars = filterVars .. "var shader".. i .." = game.createRuntimeShader('".. filter .."');" .. m
        main = main .. "new ShaderFilter(shader".. i ..")" .. (i == #filters and "" or ",")
        itime = itime .. 'shader'.. i ..'.setFloat("iTime", Timer.stamp());' .. m .. "    "
    end
    main = main .. ("];")

    local shaderV = ''
    for s, shader in ipairs(shaderVals) do
        for _, v in ipairs(shader) do
            local atyp = ''
            local typ, prp, val = v[1]:lower(), v[2], v[3]

            local thing = {'Bool', 'Int', 'Float'}
            for _, v in ipairs(thing) do
                if atyp == '' then
                    atyp = (
                        (typ == v:lower()) and v
                        or ((type == (v:lower() .. 'array')) and (v .. 'Array') or '')
                    )
                end
            end

            shaderV = shaderV .. 'shader'.. s ..'.set'.. atyp ..'("'.. prp ..'", '.. tostring(val) ..'); ' .. m
        end
    end

    runHaxeCode([[
        ]].. filterVars .. shaderV ..
        main .. [[

        FlxG.signals.postUpdate.add(() -> {
            ]].. itime ..[[

        });
    ]])
end

function game.removeCamFilters(camera)
    runHaxeCode("game.".. getCameraFromString(camera) ..(version >= '0.7.2' and ".filters = [];" or '.setFilters();'))
end

function game.makeGradient(spr, dimensions, colors, chunkSize, rotation, interpolate) 
    if type(dimensions) ~= 'number' or type(dimensions) ~= 'table' then
        d.error("game.makeGradient:2: Expected table or number, got ".. type(dimensions) .." instead.")
        return
    end

    if type(colors) ~= "table" then
        d.error("game.makeGradient:3: Expected table, got ".. type(colors) .."instead.")
        return 
    end

    if colors[1] == colors[2] then
        d.error("game.makeGradient:3: Both values cannot be the same!")
        return
    end

    interpolate = _h.resolveDefaultValue(interpolate, false)
    dimensions = _h.resolveAlternative(dimensions, 2)

    local luaSpr = game.luaInstanceExists(spr)
    local varSpr = _h.variableExists(spr)
    local obj = luaSpr and "game.getLuaObject('".. spr .."')" or (varSpr and "getVar('".. spr .."')" or "game.".. spr)

    for i, color in ipairs(colors) do
        if not stringStartsWith(color, '0x') then 
            colors[i] = '0xFF'.. color 
        end
    end

    addHaxeLibrary('FlxGradient', 'flixel.util')
    addHaxeLibrary('FlxMath', 'flixel.math')
    runHaxeCode([[
        var dumbGrad = FlxGradient.createGradientBitmapData(]].. dimensions[1] ..[[, ]].. dimensions[2] ..[[,[]].. (colors[1]) ..[[, ]].. (colors[2]) ..[[], ]].. (chunkSize or 1) ..[[, ]].. (rotation or 90) ..[[, ]].. (tostring(interpolate)) ..[[);
        ]].. obj .. [[.pixels = dumbGrad;
    ]])
end

---Makes a new lua character
function game.makeLuaCharacter(tag, json, position, noteType, isPlayer)
    if not _h.validate({tag, json, noteType}, {'string', 'string', 'string'}) then
        return
    end

    position = _h.resolveAlternative(position, 2)
    o.addHaxeLibrary("Character")
    runHaxeCode([[
        setVar(']].. tag ..[[', 
            new Character(]].. (position[1] or '0') ..[[, ]].. (position[2] or '0') ..[[, ']].. json ..[[', ]].. tostring(isPlayer) ..[[)
        );
        getVar(']].. tag ..[[').recalculateDanceIdle();
		getVar(']].. tag ..[[').dance();
        game.add(getVar(']].. tag ..[['));
    ]])

    table.insert(game.luaChars, {tag, isPlayer, noteType})
end

---Applies markup to a text (no shit)
function game.applyTextMarkups(tag, text, colors, seperators)
    addHaxeLibrary("FlxTextFormat", "flixel.text")
    addHaxeLibrary("FlxTextFormatMarkerPair", 'flixel.text')

    if not _h.validate({colors, seperators}, {'string', 'string'}) then
        return
    end

    if #colors ~= #seperators then
        d.error("game.applyTextMarkups:3/4: Argument color and seperator must have the same length!")
    end

    local markups = ""
    for i, color in ipairs(colors) do
        markups = markups .. "new FlxTextFormatMarkerPair(new FlxTextFormat(".. (stringStartsWith(color, "0xFF") and color or "0xFF"..color) .."), '".. seperators[i] .."')" .. (i == #colors and "" or ",")
    end

    local obj = game.luaTextExists(tag) and "game.getLuaObject('".. tag .."')" or (_h.variableExists(tag) and "getVar('".. tag .."')" or "game.".. tag)
    runHaxeCode([[
        ]].. obj ..[[.applyMarkup("]].. text ..[[", 
            []].. markups ..[[]
        );
    ]])
end

---Creates a new instance of `class`.
function game.createInstance(variable, class, args) 
    if _h.instanceExists(game.customInstances, variable) then
        d.error("game.createInstance:1: The instance named '".. variable .. "' already exists! Cannot override the said instance.")
        return
    end

    if _h.variableExists(variable) then
        d.error("game.createInstance:1: Another variable is already using the name '".. variable .."', Try another name.")
        return
    end

    local actualArgs = ""
    for i, v in ipairs(args) do
        actualArgs = actualArgs .. tostring(_h.serialize(v, type(v))) .. (i == #args and "" or ",")
    end

    local actualClass, package = '', ''
    local temp = stringSplit(class, '.')
    if #temp > 2 then
        for i, v in ipairs(temp) do if i ~= #temp then
                package = package .. v .. (i == #temp-1 and '' or '.')
        end end
    else
        package = temp[1]
    end

    actualClass = temp[#temp]

    addHaxeLibrary(actualClass, package)
    runHaxeCode([[ 
        game.variables.set(']].. variable ..[[',
            new ]].. actualClass ..[[(]].. actualArgs ..[[)
        );
    ]])
    table.insert(game.customInstances, variable)
end

---Adds a FlxObject to the stage.
function game.addInstance(instance)
    if _h.instanceExists(game.customInstances, instance) then
        runHaxeCode("game.add(getVar('".. instance .."'));")
    else d.error("game.addInstance:1: You can't add something that doesn't exist~") end
end

function game.callFromInstance(instance, call, args)
    if _h.instanceExists(game.customInstances, instance) then
        local actualArgs = ""
        for i, v in ipairs(args) do
            actualArgs = actualArgs .. tostring(_h.serialize(v, type(v))) .. (i == #args and "" or ",")
        end

        runHaxeCode("game.variables.get('".. instance .."').".. call .."(".. actualArgs ..");")
    else d.error("game.callFromInstance:1: Instance doesn't exist!") end
end

---Returns the current health color of the target in hex
---@param char string Dad or Boyfriend
---@return string
function game.getHealthColor(char)
    char = char:lower()
    if char == "bf" then char = "boyfriend" end
    if (char ~= "boyfriend" and char ~= "dad") then 
        d.error("game.getHealthColor:1: Unknown character: '"..char.."'")
        return ""
    else
        return c.rgbToHex(getProperty(char ..".healthColorArray[0]"), getProperty(char ..".healthColorArray[1]"), getProperty(char ..".healthColorArray[2]"))
    end
end

---Changes the health bar colors
---@param left string Color
---@param right string Color
function game.setHealthBarColors(left, right)
    if left ~= nil or right ~= nil then
        if version >= "0.7.0" then setHealthBarColors(left, right) else
            runHaxeCode("game.healthBar.createFilledBar(".. getColorFromHex(left) ..", ".. getColorFromHex(right) ..")")
        end
    end
end

---Checks if a certain LUA object exists
---@param obj string LUA object
---@return boolean
function game.luaInstanceExists(obj)
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
function game.getFps()
    return getPropertyFromClass("Main", "fpsVar.currentFPS")
end

---Fetches the current memory
---@return number Memory 
function game.getMemory()
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
function game.getAccuracy()
    return m.floordecimal(rating * 100)
end

---Sets the sprite's origin to its center - useful after adjusting `scale` to make sure rotations work as expected.
---@param obj string Object
function game.centerOrigin(obj)
    setOrigin(getProperty(obj..".frameWidth") * 0.5, getProperty(obj..".frameHeight") * 0.5)
end

---Sets the sprite's origin position
---@param obj string Object
---@param newOri table New Origin
function game.setOrigin(obj, newOri)
    setProperty(obj..".origin.x", newOri[1]) setProperty(obj..".origin.y", newOri[2])
end

---Returns the values of the origin position of the target object using a table
---@param obj string Object
---@return table
function game.getOrigin(obj)
    return {
        x = getProperty(obj..".origin.x"),
        y = getProperty(obj..".origin.y")
    }
end

---Sets the sprite's position
---@param obj string Object
---@param newPos table<number> New Position
function game.setPosition(obj, newPos)
    setProperty(obj ..".x", newPos[1]) setProperty(obj ..".y", newPos[2])
end

---Returns the values of the position of the target object using a table
---@param obj string Object
---@return table<number>
function game.getPosition(obj)
    return {
        x = getProperty(obj ..".x"),
        y = getProperty(obj ..".y")
    }
end

---Returns the current scale of the target object using a table
---@param obj string Object
---@return table<number>
---@nodiscard
function game.getObjectScale(obj)
    return {x = getProperty(obj ..".scale.x"), y = getProperty(obj ..".scale.y")}
end

---Sets the camera target to the target character
---@param target string
---@author GhostglowDev, Flain
function game.cameraSetTarget(target)
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
function game.callMethod(funcToRun, args, forcedVer)
    game.callMethodFromClass("PlayState", funcToRun, args, forcedVer)
end

---Calls a function from a `className` class
---@param className string The class
---@param funcToRun string The function to call
---@param args table<any> The arguments; can be as many as the function needs
---@author GhostglowDev, Laztrix, galactic_2005
function game.callMethodFromClass(className, funcToRun, args, forcedVer)
    forcedVer = _h.resolveDefaultValue(forcedVer, false)
    if version >= "0.7.0" and not forcedVer then
        if className == "PlayState" then
            callMethod(funcToRun, args)
        else
            callMethodFromClass(className, funcToRun, args) 
        end
    else
        -- thanks laztrix and galactic_2005 for shortening this mess
        local argsStr = ""
        for i, v in ipairs(args) do
            argsStr = argsStr .. _h.serialize(v, type(v))
            .. (i == #args and "" or ", ")
        end

        local splitStr = stringSplit(className, ".")
        className = splitStr[#splitStr]
    
        local a = o.classBasedOnVersion(false, className)
        if className ~= "PlayState" then
            o.addHaxeLibrary(className)
        else a = "game" end

        runHaxeCode(a ..".".. funcToRun .."(".. argsStr ..");")
    end
end

---Starts.. a tween.
---@param tag string The tag used for cancelling the tween
---@param var string The variable to tween
---@param values table<any> The values to tween
---@param duration? number The time it takes to complete
---@param options? table<any> The tween options
---@author GhostglowDev, galactic_2005
function game.startTween(tag, var, values, duration, options, forcedVer)
    forcedVer = _h.resolveDefaultValue(forcedVer, false)
    if version >= "0.7.0" and not forcedVer then
        startTween(tag, var, values, duration, options)
        return
    end

    if forcedVer then 
        d.warning("Running startTween using GhostUtil's method by force!")
    end

    if not _h.validate({tag, var, values}, {'string', 'string', 'table'}) then
        return
    end

    duration = _h.resolveDefaultValue(duration, 1)
    options = _h.resolveDefaultValue(options, {})

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
            if ttype:lower() == k or tonumber(ttype) == v then
                return v
            end
        end

        return "8"
    end

    local function getOptionValue(key)
        for k, v in pairs(options) do
            if k == key then
                return v
            end
        end
        return "null"
    end

    -- chokolily jumpscare

    local valueStr = ""
    local i = 0
    for k, v in pairs(values) do
        i = i + 1
        valueStr = (valueStr .. k .. ": " .. _h.serialize(v, type(v))
        ..(i == get_length(values) and "" or ", "))
    end

    if game.luaInstanceExists(var) then
        var = "game.getLuaObject(".. _h.serialize(var, "string") ..");"
    else
        var = (_h.variableExists(var) and "getVar('".. var .."')" or "game." .. var) 
    end

    runHaxeCode([[
        game.modchartTweens.set(']].. tag ..[[',
            FlxTween.tween(]].. var ..[[, {]].. valueStr ..[[}, ]].. duration ..[[, {
                type: ]].. getFlxTweenType(getOptionValue("type")) ..[[,
                ease: ]].. _h.getFlxEaseByString(getOptionValue("ease")) ..[[,
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
                    if (']].. getFlxTweenType(getOptionValue("type")) ..[[' != "4" || ]].. getFlxTweenType(getOptionValue("type")) ..[[ != "16")
                        game.modchartTweens.remove(']].. tag ..[[');
                }
            })
        );
    ]])
end

return game
