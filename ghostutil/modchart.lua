local modchart = {}

local helper = require 'ghostutil.backend.helper'
local debug = require 'ghostutil.debug'
local util = require 'ghostutil.util'
local bcompat = require 'ghostutil.backwards-compat'

local function copyFrom(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = type(v) == 'table' and copyFrom(v) or v
    end
    return ret
end

local function randomFloat(a, b)
    if getRandomFloat then 
        return getRandomFloat(a, b)
    else 
        return a + math.random() * (b - a)
    end
end

local function random(a, b)
    if getRandomInt then
        return getRandomInt(a, b)
    else return math.random() end
end

modchart.ModFunctions = {
    SINE = math.sin,
    COSINE = math.cos,
    TAN = math.tan,
    LOG = math.log10,

    -- to be edited by users
    CUSTOM = math.sin
}

modchart.ScrollType = {
    UPSCROLL = 'up',
    DOWNSCROLL = 'down'
}

local basicPoint = { x = 0, y = 0}
local basicWiggleMod = {
    enabled = false,
    frequency = { x = 1, y = 1 },
    phase = copyFrom(basicPoint),
    magnitude = copyFrom(basicPoint),
    offset = copyFrom(basicPoint),
    func = { 
        x = modchart.ModFunctions.SINE,
        y = modchart.ModFunctions.SINE
    }
}
local basicShakeMod = {
    enabled = false,
    magnitude = copyFrom(basicPoint),
    func = {
        x = randomFloat,
        y = randomFloat
    }
}
local basicHiddenMod = {
    enabled = false,
    startStep = 5,
    startAlpha = 1,
    endAlpha = 0
}
local basicSuddenMod = {
    enabled = false,
    startStep = 5,
    startAlpha = 0,
    endAlpha = 1
}
local basicBoostMod = {
    enabled = false,
    startStep = 5,
    speed = 1.35
}
local basicBrakeMod = {
    enabled = false,
    startStep = 5,
    speed = 0.65
}

local basicStrumMods = {
    enabled = false,
    scroll = modchart.ScrollType.UPSCROLL,
    position = copyFrom(basicPoint),
    offset = copyFrom(basicPoint),
    wiggleMod = copyFrom(basicWiggleMod),
    shakeMod = copyFrom(basicShakeMod),
    hiddenMod = copyFrom(basicHiddenMod),
    suddenMod = copyFrom(basicSuddenMod),
    boostMod = copyFrom(basicBoostMod),
    brakeMod = copyFrom(basicBrakeMod),
    direction = 90,
    speed = 1
}

local modAliases = { 
    enabled = 'enabled',
    scroll = 'scroll',
    pos = 'position',
    position = 'position',
    offset = 'offset',
    offsets = 'offset',
    direction = 'direction',
    speed = 'speed',
}

local function getAliases(modAliases, modName, modSettings)
    local aliases = {}
    for setting, value in pairs(modSettings) do
        for _, alias in ipairs(modAliases) do
            aliases[(alias ..'.'.. setting):lower()] = modName ..'.'.. setting
            if type(value) == 'table' then
                for addField in pairs(value) do
                    aliases[(alias ..'.'.. setting ..'.'.. addField):lower()] = modName ..'.'.. setting ..'.'.. addField
                end
            end
        end
    end
    return aliases
end

local function addAliases(aliases, modName, mod)
    local aliasList = {modName:lower(), modName:sub(1, #modName-3):lower()}
    helper.concatDict(modAliases, getAliases(helper.concat(aliasList, aliases or {}), modName, mod))
end

local function getModFromAlias(alias)
    return modAliases[alias:lower()]
end

addAliases({}, 'wiggleMod', basicWiggleMod)
addAliases({}, 'shakeMod', basicShakeMod)
addAliases({}, 'hiddenMod', basicHiddenMod)
addAliases({}, 'suddenMod', basicSuddenMod)
addAliases({}, 'boostMod', basicBoostMod)
addAliases({}, 'brakeMod', basicBrakeMod)

modchart.enabled = false
modchart.strums = helper.arrayComprehension(1, 8, function(_) return copyFrom(basicStrumMods) end)
modchart.time = 0

modchart.defaultStrumData = copyFrom(modchart.strums)
modchart.trackedTweens = { }

function modchart.getModifier(index, data)
    index = index + 1
    if index <= #modchart.strums then
        if helper.keyExists(modAliases, data:lower()) then
            return helper.rawgetDict(modchart.strums[index], getModFromAlias(data))
        end
        debug.error('unrecog_el', {data, 'modAliases'}, 'modchart.getModifier')
        return nil
    end
    debug.error('wrong_type', {'0...7', index}, 'modchart.getModifier')
    return nil
end

function modchart.setModifier(index, data, value, axis)
    index = index + 1
    axis = axis and axis:lower() or axis
    if index <= #modchart.strums then
        if helper.keyExists(modAliases, data:lower()) then
            if helper.keyExists(helper.rawgetDict(modchart.strums[index], getModFromAlias(data)), 'x') and axis ~= nil then
                if axis == 'xy' or axis == 'yx' then
                    for _, axis in ipairs({'x', 'y'}) do 
                        helper.rawsetDict(modchart.strums[index], getModFromAlias(data)..'.'.. axis, value)
                    end 
                    return
                end
                helper.rawsetDict(modchart.strums[index], getModFromAlias(data)..'.'.. axis, value)
                return
            end
            helper.rawsetDict(modchart.strums[index], getModFromAlias(data), value)
            return
        end
        debug.error('unrecog_el', {data, 'modAliases'}, 'modchart.setModifier')
        return
    end
    debug.error('wrong_type', {'0...7', index}, 'modchart.setModifier')
    return
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

    local initialMod = axis ~= nil and modchart.getModifier(index, modifier)[axis:lower()] or modchart.getModifier(index, modifier)
    util.doTweenNumber(tag, initialMod, value, duration, {
        ease = ease,
        onComplete = '__removeTrackedTween'
    })
    modchart.trackedTweens[tag] = {index = index, mod = modifier, axis = axis:lower()}
end

function modchart.cancelTween(tag)
    local foundTween = false
    if helper.keyExists(modchart.trackedTweens, tag) then
        cancelTween(tag)
        modchart.trackedTweens[tag] = nil

        foundTween = true
    end
    
    if helper.keyExists(modchart.trackedScrollTweens, tag) then
        cancelTween(tag)
        cancelTween(tag ..'_spawnTime')
        cancelTween(tag ..'out_spawnTime')
        cancelTween(tag ..'_scrollSpeed')
        cancelTween(tag ..'out_scrollSpeed')
        modchart.trackedScrollTweens[tag] = nil

        foundTween = true
    end

    if not foundTween then
        debug.error('unrecog_el', {tag, 'modchart.trackedTweens and modchart.trackedScrollTweens'}, 'modchart.cancelTween')
    end
end

function modchart.resetStrumModifiers(index)
    if index <= 8 then
        modchart.strums[index + 1] = copyFrom(modchart.defaultStrumData[index])
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

function toSpeed(freq)
    return 2 * math.pi * freq
end

local function wiggleMod(wiggleData, dt)
    if wiggleData.enabled then
        wiggleData.phase.x = wiggleData.phase.x + toSpeed(wiggleData.frequency.x) * dt
        wiggleData.phase.y = wiggleData.phase.y + toSpeed(wiggleData.frequency.y) * dt
        return {
            x = wiggleData.func.x( wiggleData.phase.x + wiggleData.offset.x ) * wiggleData.magnitude.x,
            y = wiggleData.func.y( wiggleData.phase.y + wiggleData.offset.y ) * wiggleData.magnitude.y
        }
    else return copyFrom(basicPoint) end
end

local function shakeMod(shakeData, dt)
    if shakeData.enabled then 
        return {
            x = shakeData.func.x( shakeData.magnitude.x, -shakeData.magnitude.x ),
            y = shakeData.func.y( shakeData.magnitude.y, -shakeData.magnitude.y ),
        }
    else return copyFrom(basicPoint) end
end

function modchart.update(dt)
    modchart.time = modchart.time + dt
    for j, strumData in ipairs(modchart.strums) do
        local i = j - 1
        if strumData.enabled then
            local wiggle = wiggleMod(strumData.wiggleMod, dt)
            local shake = shakeMod(strumData.shakeMod, dt)
            setPropertyFromGroup('strumLineNotes', i, 'x', strumData.position.x + wiggle.x + shake.x + strumData.offset.x)
            setPropertyFromGroup('strumLineNotes', i, 'y', strumData.position.y + wiggle.y + shake.y + strumData.offset.y)
        end
    end
end

function getMultSpeed(index)
    return (getPropertyFromGroup('notes', i, 'extraData.multSpeed', true) or 1)
end

function getMultAlpha(index)
    return (getPropertyFromGroup('notes', i, 'extraData.multAlpha', 1) or 1)
end

function modchart.updateNoteModifiers(elapsed)
    for i = 0, getProperty('notes.length')-1 do
        local dataOffset = getPropertyFromGroup('notes', i, 'mustPress') and 5 or 1
        local strumData = modchart.strums[getPropertyFromGroup('notes', i, 'noteData') + dataOffset]
        local stepsLeft = (getPropertyFromGroup('notes', i, 'strumTime') - getSongPosition()) / stepCrochet
        
        setPropertyFromGroup('notes', i, 'multSpeed', getMultSpeed(i) * strumData.speed)
        setPropertyFromGroup('notes', i, 'multAlpha', getMultAlpha(i))

        if strumData.suddenMod.enabled then 
            local suddenMod = strumData.suddenMod

            if stepsLeft <= suddenMod.startStep then
                local progress = helper.bound((suddenMod.startStep - stepsLeft) / suddenMod.startStep, 0, 1)
                local targetAlpha = suddenMod.startAlpha + (progress * suddenMod.endAlpha * (1.5 - suddenMod.startAlpha))

                local minAlpha = math.min(suddenMod.startAlpha, suddenMod.endAlpha)
                local maxAlpha = math.max(suddenMod.startAlpha, suddenMod.endAlpha)
                setPropertyFromGroup('notes', i, 'multAlpha', helper.bound(targetAlpha, minAlpha, maxAlpha) * getMultAlpha(i))
            else
                setPropertyFromGroup('notes', i, 'multAlpha', suddenMod.startAlpha * getMultAlpha(i))
            end
        end
        
        if strumData.hiddenMod.enabled then
            local hiddenMod = strumData.hiddenMod
            local startStep = hiddenMod.startStep

            if startStep <= 0 then
                setPropertyFromGroup('notes', i, 'multAlpha', (stepsLeft <= 0) and hiddenMod.endAlpha or hiddenMod.startAlpha)
            elseif stepsLeft <= startStep then
                local progress = helper.bound(1 - (stepsLeft - (startStep / 1.25)) / startStep, 0, 1)
                local targetAlpha = hiddenMod.startAlpha + (hiddenMod.endAlpha - hiddenMod.startAlpha) * progress

                local minAlpha = math.min(hiddenMod.startAlpha, hiddenMod.endAlpha)
                local maxAlpha = math.max(hiddenMod.startAlpha, hiddenMod.endAlpha)
                setPropertyFromGroup('notes', i, 'multAlpha', helper.bound(targetAlpha, minAlpha, maxAlpha) * getMultAlpha(i))
            else
                setPropertyFromGroup('notes', i, 'multAlpha', hiddenMod.startAlpha * getMultAlpha(i))
            end
        end

        if strumData.boostMod.enabled then
            local boostMod = strumData.boostMod
            if (stepsLeft / 1.25) <= boostMod.startStep then
                local targetSpeed = 1 + (boostMod.speed - 1)
                                    * (1 - stepsLeft / (boostMod.startStep * 1.25))
                setPropertyFromGroup('notes', i, 'multSpeed', getMultSpeed(i) * targetSpeed * strumData.speed)
            end
        end

        if strumData.brakeMod.enabled then
            local brakeMod = strumData.brakeMod
            if stepsLeft <= brakeMod.startStep then
                local targetSpeed = 1 + (brakeMod.speed - 1)
                                    * (1 - stepsLeft / (brakeMod.startStep * 1.25))
                setPropertyFromGroup('notes', i, 'multSpeed', getMultSpeed(i) * targetSpeed * strumData.speed)
            end
        end
    end
end

modchart.trackedScrollTweens = {}
function modchart.tweenScroll(tag, isDownscroll, index, duration, ease, moveNotes)
    if tag ~= nil or isDownscroll ~= nil or index ~= nil then 
        isDownscroll = helper.ternary(downscroll, not isDownscroll, isDownscroll)
        duration = duration or 1

        if moveNotes then
            modchart.tweenModifier(tag, index, 'position', 'y', isDownscroll and 570 or 50, duration, ease)
        end

        local function getEaseName(ease) 
            local raw = helper.getTweenEaseByString(ease):gsub('FlxEase.', '')
            if stringEndsWith(raw, 'InOut') then ease = raw:sub(1, #raw-5)
            elseif stringEndsWith(raw, 'In') then ease = raw:sub(1, #raw-2)
            elseif stringEndsWith(raw, 'Out') then ease = raw:sub(1, #raw-3) end

            if ease == 'linear' then return 'sine' end
            return ease
        end

        local spawnTime = getProperty('spawnTime')
        util.doTweenNumber(tag.. '_spawnTime', spawnTime, spawnTime * 0.6, duration / 2, { ease = getEaseName(ease) ..'In' })
        util.doTweenNumber(tag.. 'out_spawnTime', spawnTime * 0.6, spawnTime, duration / 2, { 
            startDelay = duration / 2,
            onStart = '__setScroll',
            onComplete = '__removeTrackedScrollTween',
            ease = getEaseName(ease) ..'Out' 
        })

        util.doTweenNumber(tag.. '_scrollSpeed', modchart.strums[index+1].speed, 0, duration / 2, { ease = getEaseName(ease) ..'In' })
        util.doTweenNumber(tag.. 'out_scrollSpeed', 0, modchart.strums[index+1].speed, duration / 2, { 
            startDelay = duration / 2,
            ease = getEaseName(ease) ..'Out' 
        })

        modchart.trackedScrollTweens[tag] = { index = index, downscroll = isDownscroll }
        return
    end
    if tag == nil then debug.error('nil_param', {'tag'}, 'modchart.tweenScroll') end
    if isDownscroll == nil then debug.error('nil_param', {'isDownscroll'}, 'modchart.tweenScroll') end
    if index == nil then debug.error('nil_param', {'index'}, 'modchart.tweenScroll') end
end

function gcall_modchart(fn, args)
    if fn == 'onUpdatePost' then
        local elapsed = args[1]
        if modchart.enabled then
            modchart.update(elapsed)
            modchart.updateNoteModifiers(elapsed)
        end
    end

    if fn == 'onCreate' then
        for i = 0, getProperty('unspawnNotes.length')-1 do 
            setPropertyFromGroup('unspawnNotes', i, 'extraData.multSpeed', 1, true)
        end
    end

    if fn == 'onCreatePost' then
        math.randomseed(os.time())
        modchart.setDefaultOffsets()

        for i = 0, getProperty('strumLineNotes.length')-1 do
            modchart.setModifier(i, 'scroll', getPropertyFromGroup('strumLineNotes', i, 'downScroll') and modchart.ScrollType.DOWNSCROLL or modchart.ScrollType.UPSCROLL)
        end
    end

    if fn == 'onNumberTween' then
        local tag = args[1]
        local num = args[2]
        if helper.keyExists(modchart.trackedTweens, tag) then
            local trackerData = modchart.trackedTweens[tag]
            modchart.setModifier(trackerData.index, trackerData.mod, num, trackerData['axis'])
        end

        if stringEndsWith(tag, '_spawnTime') then 
            setProperty('spawnTime', num)
        end

        if stringEndsWith(tag, '_scrollSpeed') then 
            if num == 0 then return end
            local index = modchart.trackedScrollTweens[tag:gsub('out_scrollSpeed', ''):gsub('_scrollSpeed', '')].index
            modchart.strums[index+1].speed = num
        end
    end
end

function __removeTrackedTween(tag)
    modchart.trackedTweens[tag] = nil
end

function __removeTrackedScrollTween(tag)
    modchart.trackedScrollTweens[tag:gsub('out_scrollSpeed', '')] = nil
end

function __setScroll(tag)
    local scrTwn = modchart.trackedScrollTweens[tag:gsub('out_spawnTime', '')]
    setPropertyFromGroup('strumLineNotes', scrTwn.index, 'downScroll', scrTwn.downscroll)
    for i = 0, getProperty('notes.length')-1 do 
        if getPropertyFromGroup('notes', i, 'isSustainNote') and getPropertyFromGroup('notes', i, 'noteData') == (scrTwn.index % 4) and getPropertyFromGroup('notes', i, 'mustPress') == (scrTwn.index > 3) then
            setPropertyFromGroup('notes', i, 'flipY', scrTwn.downscroll)
        end
    end

    modchart.setModifier(scrTwn.index, 'scroll', scrTwn.downscroll and modchart.ScrollType.DOWNSCROLL or modchart.ScrollType.UPSCROLL)

    for i = 0, getProperty('unspawnNotes.length')-1 do 
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') and getPropertyFromGroup('unspawnNotes', i, 'noteData') == (scrTwn.index % 4) and getPropertyFromGroup('unspawnNotes', i, 'mustPress') == (scrTwn.index > 3) then
            setPropertyFromGroup('unspawnNotes', i, 'flipY', scrTwn.downscroll)
        end
    end
end

return modchart