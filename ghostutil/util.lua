local util = {}

local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'
local bcompat = require 'ghostutil.backwards-compat'
local color = require 'ghostutil.color'
local dkjson = require 'ghostutil.backend.dkjson'

util.initialized = false
function util.init()
    if not util.initialized then
        helper.addHaxeLibrary('FlxGradient', 'flixel.util')
        helper.addHaxeLibrary('FlxTextFormatMarkerPair', 'flixel.text')
        helper.addHaxeLibrary('FlxTextFormat', 'flixel.text')
        helper.addHaxeLibrary('FlxText', 'flixel.text')
        helper.addHaxeLibrary('System', 'openfl.system')
        helper.addHaxeLibrary('Type')
        helper.addHaxeLibrary('Reflect')

        util.initialized = true
    end
end

function util.doTweenNumber(tag, from, to, duration, options)
    if tag ~= nil then
        from = from or 0
        to = to or 0
        duration = duration or 1
        local _options = bcompat.__buildOptions(tag, nil, options)
        local tweenPre = bcompat.__getTweenPrefix()
        runHaxeCode(('%s("%s", FlxTween.num( %s, %s, %s, %s, n -> game.callOnLuas("onNumberTween", ["%s", n]) ) );'):format(
            version >= '1.0' and 'setVar' or 'game.modchartTweens.set',
            tweenPre .. tag, tostring(from), tostring(to), tostring(duration), _options, tag)
        )
        return
    end
    debug.error('nil_param', {'tag'}, 'util.doTweenNumber:1')
end

function util.doTweenScale(tag, var, values, duration, ease)
    values = helper.fillTable(values, 0, 2)
    bcompat.startTween(tag, var ..'.scale', {x = values[0], y = values[1]}, duration, {
        ease = ease,
        onComplete = 'onTweenCompleted'
    })
end

function util.doTweenPosition(tag, var, values, duration, ease)
    values = helper.fillTable(values, 0, 2)
    bcompat.startTween(tag, var, {x = values[0], y = values[1]}, duration, {
        ease = ease,
        onComplete = 'onTweenCompleted'
    })
end

function util.pauseTween(tag)
    helper.callMethod((version >= '1.0' and '' or 'modchartTweens.').. tag ..'.pause', {''})
end

function util.resumeTween(tag)
    helper.callMethod((version >= '1.0' and '' or 'modchartTweens.').. tag ..'.resume', {''})
end

function util.toboolean(value)
    value = tostring(value)
    return value == '1' or value == 'true'
end
util.toBoolean = util.toboolean
util.toBool = util.toboolean

function util.isnan(value)
    return type(value) == 'number' and value ~= value
end
util.isNaN = util.isnan

util.isOfType = helper.isOfType

function util.isnil(value)
    return type(value) == nil
end
util.isNil = util.isnil
util.isNull = util.isnil
util.isnull = util.isnil

function util.isbool(value)
    return type(value) == "boolean"
end
util.isBool = util.isbool

function util.isnumber(value)
    return type(value) == "number"
end
util.isNumber = util.isnumber

function util.isstring(value)
    return type(value) == "string"
end
util.isString = util.isstring

function util.istable(value)
    return type(value) == "table"
end
util.isTable = util.istable

function util.switch(case, cases)
    if (cases[case]) then return cases[case]()
    elseif (cases["default"]) then return cases["default"]() end
end

function util.makeGradient(sprite, width, height, colors, chunkSize, rotation, interpolate)
    util.init()
    if sprite ~= nil then
        width = width or 0
        height = height or 0
        chunkSize = chunkSize or 1
        rotation = rotation or 90
        interpolate = helper.resolveDefaultValue(interpolate, false)

        if colors ~= nil and #colors > 0 then
            for i, col in ipairs(colors) do
                if type(col) == 'string' then
                    col = tonumber((stringStartsWith(col, '0x') and '' or '0x').. col)
                end

                local _color = color.rgbToARGB(col)
                colors[i] = '0x'.. color.getHexString(_color)
            end

            runHaxeCode(([[
                var bmp = FlxGradient.createGradientBitmapData(%s, %s, %s, %s, %s, %s);
                %s.loadGraphic(bmp);
            ]]):format(width, height, helper.serialize(colors, 'array'):gsub("'", ''), chunkSize, rotation, tostring(interpolate), helper.parseObject(sprite)))
            return
        end
        debug.error('nil_param', {'colors'}, 'util.makeGradient:4')
        return
    end
    debug.error('nil_param', {'sprite'}, 'util.makeGradient:1')
end

function util.applyTextMarkup(tag, text, markerPair)
    util.init()
    if tag ~= nil then
        text = text or getTextString(tag)
        if markerPair == nil or helper.getDictLength(markerPair) <= 0 then
            debug.error('nil_param', {'markerPair'}, 'util.applyTextMarkup:3')
            return
        end

        local markups = {}
        for seperator, col in pairs(markerPair) do
            if type(col) == 'string' then
                col = tonumber((stringStartsWith(col, '0x') and '' or '0x').. col)
            end

            local _color = color.rgbToARGB(col)
            _color = '0x'.. color.getHexString(_color)
            table.insert(markups, ('new FlxTextFormatMarkerPair(new FlxTextFormat(%s), %s)'):format(_color, helper.serialize(seperator, 'string')))
        end

        local instance = helper.parseObject(tag)
        return runHaxeCode(('if (Std.isOfType(%s, FlxText)) %s.applyMarkup(%s, [%s]); return;'):format(instance, instance, helper.serialize(text, 'string'), table.concat(markups, ', ')))
    end
    debug.error('nil_param', {'tag'}, 'util.applyTextMarkup:1')
end

function util.getHealthColor(character)
    character = character:lower()
    if character == 'bf' or character == 'player' then character = 'boyfriend' end
    if character == 'opponent' or character == 'opp' then character = 'dad' end
    if character == 'bopper' then character = 'gf' end
    if helper.eqAny(character, {'boyfriend', 'dad', 'gf'}) then
        return color.rgbToHex(getProperty(character ..'.healthColorArray'))
    end
    debug.error('wrong_type', {'bf, dad or gf', character}, 'util.getHealthColor:1')
    return nil
end

function util.getFps()
    return getPropertyFromClass("Main", "fpsVar.currentFPS")
end

function util.getMemory()
    util.init()
    if version >= "0.7" then
        return getPropertyFromClass("Main", "fpsVar.memoryMegas")
    else
        return runHaxeCode("return System.totalMemory;")
    end
end

function util.centerOrigin(object)
    if helper.objectExists(object) then
        return util.setOrigin(object,
            getProperty(object ..'.frameWidth') / 2,
            getProperty(object ..'.frameHeight') / 2
        )
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.setOrigin(object, x, y)
    if helper.objectExists(object) then
        setProperty(object ..'.origin.x', x or 0)
        setProperty(object ..'.origin.y', y or 0)
        return
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.getOrigin(object)
    if helper.objectExists(object) then
        return {
            x = getProperty(object ..'.origin.x'),
            y = getProperty(object ..'.origin.y')
        }
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.setPosition(object, x, y)
    if helper.objectExists(object) then
        setProperty(object ..'.x', x or 0)
        setProperty(object ..'.y', y or 0)
        return
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.getPosition(object)
    if helper.objectExists(object) then
        return {
            x = getProperty(object ..'.x'),
            y = getProperty(object ..'.y')
        }
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.setVelocity(object, x, y)
    if helper.objectExists(object) then
        helper.setProperty(object ..'.velocity.x', x or 0)
        helper.setProperty(object ..'.velocity.y', y or 0)
        return
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.getVelocity(object)
    if helper.objectExists(object) then
        return {
            x = getProperty(object ..'.velocity.x'),
            y = getProperty(object ..'.velocity.y')
        }
    end
    debug.error('unrecog_el', {object, 'game'})
end

function util.parseJSON(str)
	local obj, pos, err = dkjson.decode(str, 1, nil)
    if err then
		debug.error('nil_param', {}, 'util.safeParseJSON', tostring(err))
		return {}
	end
	return obj
end

function util.stringifyJSON(dict, useIndent)
	return dkjson.encode(dict, {indent = useIndent})
end

return util