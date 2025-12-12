local bcompat = {}

local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'

function bcompat.__buildFunction(args, code)
    return string.format('(%s) -> { %s }', table.concat(args or {}, ', '), code or '')
end

function bcompat.__buildTweenCallback(callback, args)
    return string.format('game.callOnLuas("%s", [%s]);', callback or '', table.concat(args or {}, ', '))
end

function bcompat.__buildOptions(tag, object, options, onUpdate, onStart, onComplete)
    local _twnType = helper.getTweenType(options.type)
    return ('{%s, %s, %s, %s, %s, %s, %s}'):format(
        'type: '.. tostring(_twnType),
        'startDelay: '.. tostring(options.startDelay or 0),
        'loopDelay: '.. tostring(options.loopDelay or 0),
        'ease: '.. helper.getTweenEaseByString(options.ease),
        'onUpdate: '.. bcompat.__buildFunction({'twn'}, bcompat.__buildTweenCallback(options.onUpdate, {'"tween_'.. tag ..'"', '"'.. tostring(object or 'null') ..'"'}) .. (onUpdate or '')),
        'onStart: '.. bcompat.__buildFunction({'twn'}, bcompat.__buildTweenCallback(options.onStart, {'"tween_'.. tag ..'"', '"'.. tostring(object or 'null') ..'"'}) .. (onStart or '')),
        'onComplete: '.. bcompat.__buildFunction({'twn'}, ('%s%s'):format(
            (_twnType >= 8) and 'game.modchartTweens.remove("'.. tag ..'"); ' or '',
            bcompat.__buildTweenCallback(options.onComplete, {'"tween_'.. tag ..'"', '"'.. tostring(object or 'null') ..'"'}) .. (onComplete or '')
        ))
    )
end

function bcompat.startTween(tag, object, values, duration, options) 
    if version < '0.7' then
        local extraFields = {}
        local varsToRemove = {}
        for var, value in pairs(values) do
            local sepVar = stringSplit(var, '.')
            if #sepVar > 1 then
                local actualVar = sepVar[#sepVar]
                local parentField = table.concat(helper.resizeTable(sepVar, #sepVar-1), '.')
                if helper.keyExists(extraFields, parentField) then
                    extraFields[parentField][actualVar] = value
                else
                    extraFields[parentField] = {[actualVar] = value}
                end
                table.insert(varsToRemove, var)
            end
        end

        for _, var in ipairs(varsToRemove) do
            values[var] = nil
        end

        -- for keys that has extra fields like 'velocity.x'
        for field, values in pairs(extraFields) do
            local _tag = tag or ''
            bcompat.startTween(_tag ..'_'.. field, object ..'.'.. field, values, duration, options)
        end

        duration = duration or 1
        local _options = bcompat.__buildOptions(tag, object, options)
        runHaxeCode(('%s("%s", FlxTween.tween( %s, %s, %s, %s ) );'):format(
            tag == nil and '' or 'game.modchartTweens.set', 
            tag, helper.parseObject(object), helper.serialize(values, 'struct'), tostring(duration), _options
        ))
    else
        startTween(tag, object, values, duration, options)
    end
end

bcompat.instanceArg = helper.instanceArg
bcompat.callMethod = helper.callMethod
bcompat.callMethodFromClass = helper.callMethodFromClass
bcompat.createInstance = helper.createInstance
bcompat.addInstance = helper.addInstance
bcompat.setProperty = helper.setProperty
bcompat.setPropertyFromClass = helper.setPropertyFromClass
bcompat.setPropertyFromGroup = helper.setPropertyFromGroup

return bcompat