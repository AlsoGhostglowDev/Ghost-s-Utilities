local modchart = {}

local helper = require 'ghostutil.backend.helper'
local util = require 'ghostutil.util'
local bcompat = require 'ghostutil.backwards-compat'

local function copyFrom(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = type(v) == 'table' and copyFrom(v) or v
    end
    return ret
end

modchart.ModFunctions = {
    SINE = math.sin,
    COSINE = math.cos,
    TAN = math.tan,
    LOG = math.log10,

    -- to be edited by users
    CUSTOM = math.sin
}

local basicPoint = { x = 0, y = 0}
local basicStrumMod = {
    enabled = false,
    position = copyFrom(basicPoint),
    modDistance = copyFrom(basicPoint),
    modOffset = copyFrom(basicPoint),
    modTimeOffset = copyFrom(basicPoint),
    modSpeed = { x = 1, y = 1 },
    modFunc = { 
        x = modchart.ModFunctions.SINE, 
        y = modchart.ModFunctions.SINE
    }
}

local modAliases = { 
    enabled = 'enabled',
    pos = 'position',
    position = 'position',
    distance = 'modDistance',
    speed = 'modSpeed',
    offset = 'modOffset',
    timeoffset = 'modTimeOffset',
    time = 'modTimeOffset',
    func = 'modFunc',
    ['function'] = 'modFunc'
}

modchart.enabled = false
modchart.strums = helper.arrayComprehension(1, 8, function(_)
    return copyFrom(basicStrumMod)
end)
modchart.time = 0

modchart.defaultStrumData = copyFrom(modchart.strums)
modchart.trackedTweens = { }

function modchart.getModifier(index, data)
    index = index + 1
    if index <= #modchart.strums then
        return modchart.strums[index][modAliases[data:lower()]]
    end
    debug.error('wrong_type', {'0...7', index}, 'modchart.getModifier')
    return nil
end

function modchart.setModifier(index, data, value, axis)
    index = index + 1
    if index <= #modchart.strums then
        if helper.keyExists(modchart.strums[index][modAliases[data:lower()]], 'x') then
            modchart.strums[index][modAliases[data:lower()]][axis:lower()] = value
            return
        end
        modchart.strums[index][modAliases[data:lower()]] = value
        return
    end
    debug.error('wrong_type', {'0...7', index}, 'modchart.setModifier')
    return nil
end

function modchart.setDefaultOffsets()
    for j, strumData in ipairs(modchart.strums) do
        local index = j - 1
        local varName = ('default%sStrum%s%s'):format(index <= 3 and 'Opponent' or 'Player', '%s', index % 4)
        for i, axis in ipairs({'X', 'Y'}) do 
            modchart.setModifier(index, 'position', _G[varName:format(axis)], axis:lower())
            modchart.setModifier(index, 'offset', 0, axis:lower())
        end
    end
end

function modchart.toggle()
    modchart.enabled = not modchart.enabled
end

function modchart.toggleStrums()
    for i, strumData in ipairs(modchart.strums) do
        modchart.strums[i].enabled = not strumData.enabled
    end
end

function modchart.tweenModifier(tag, index, modifier, axis, value, duration, ease)
    if helper.keyExists(modchart.trackedTweens, tag) then
        modchart.cancelTween(tag)
    end

    local initialMod = axis ~= nil and getModifier(index, modifier)[axis:lower()] or getModifier(index, modifier)
    util.doTweenNumber(tag, initialMod, value, duration, {
        ease = ease,
        onComplete = 'removeTrackedTween'
    })
    modchart.trackedTweens[tag] = {index = index, mod = modifier, axis = axis:lower()}
end

function modchart.cancelTween(tag)
    if helper.keyExists(modchart.trackedTweens, tag) then
        local tweenPre = bcompat.__getTweenPrefix()
        helper.callMethod(tweenPre .. tag ..'.cancel', {''})
        helper.callMethod((version >= '1.0' and 'variables' or 'modchartTweens') ..'.remove', {tweenPre .. tag})
        modchart.trackedTweens[tag] = nil
    end
end

function modchart.resetModifiers()
    for i, strumData in ipairs(modchart.strums) do
        modchart.strums[i] = copyFrom(modchart.defaultStrumData[i])
    end
end

function modchart.setTime(newTime)
    modchart.time = newTime
end

function modchart.resetTime()
    modchart.setTime(0)
end

function modchart.update(elapsed)
    modchart.time = modchart.time + elapsed
    for j, strumData in ipairs(modchart.strums) do
        local i = j - 1
        if strumData.enabled then
            setPropertyFromGroup('strumLineNotes', i, 'x', strumData.position.x + strumData.modFunc.x( (modchart.time + strumData.modTimeOffset.x ) * strumData.modSpeed.x ) * strumData.modDistance.x + strumData.modOffset.x)
            setPropertyFromGroup('strumLineNotes', i, 'y', strumData.position.y + strumData.modFunc.y( (modchart.time + strumData.modTimeOffset.y ) * strumData.modSpeed.y ) * strumData.modDistance.y + strumData.modOffset.y)
        end
    end
end

function gcall_modchart(fn, args)
    if fn == 'onUpdatePost' then
        local elapsed = args[1]
        if modchart.enabled then
            modchart.update(elapsed)
        end
    end

    if fn == 'onCreatePost' then
        modchart.setDefaultOffsets()
    end

    if fn == 'onNumberTween' then
        local tag = args[1]
        if helper.keyExists(modchart.trackedTweens, tag) then
            local num = args[2]
            local trackerData = modchart.trackedTweens[tag]
            modchart.setModifier(trackerData.index, trackerData.mod, num, trackerData['axis'])
        end
    end
end

function removeTrackedTween(tag)
    modchart.trackedTweens[tag:gsub('tween_', '')] = nil
end

return modchart