local window = {}

local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'
local bcompat = require 'ghostutil.backwards-compat'
local util = require 'ghostutil.util'

window.defaultDimensions = {width = 1280, height = 720}
window.desktopDimensions = {width = 0, height = 0}

function gcall_window(fn, args)
    if fn == 'onStartCountdown' then 
        window.init()
    end
end

window.initialized = false
function window.init()
    if not window.initialized then
        helper.setProperty('variables.window', helper.instanceArg('stage.window', 'flixel.FlxG'), true, true)

        window.desktopDimensions = {
            width = getProperty('window.display.bounds.width'),
            height = getProperty('window.display.bounds.height')
        }
        window.initialized = true
    end
end

function window.setProperty(prop, value, allowMaps, allowInstances)
    window.init()
    helper.setProperty('window.'.. prop, value, allowMaps, allowInstances)

    return value
end

function window.getProperty(prop, allowMaps)
    window.init()
    return getProperty('window.'.. prop, allowMaps)
end

function window.setPosition(x, y)
    window.init()
    util.setPosition('window', x, y)
end

function window.screenCenter(axes)
    window.init()
    axes = axes or 'xy'
    axes = axes:lower()
    if axes:find('x') then 
        window.setProperty('x', (window.desktopDimensions.width - window.getProperty('width')) / 2)
    end
    if axes:find('y') then
        window.setProperty('y', (window.desktopDimensions.height - window.getProperty('height')) / 2)
    end
end

function window.resize(width, height)
    window.init()
    window.setProperty('width', math.floor(width) or window.defaultDimensions.width)
    window.setProperty('height', math.floor(height) or window.defaultDimensions.height)
end

function window.doTweenX(tag, value, duration, ease)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'
        duration = duration or 1

        doTweenX(tag, 'window', value, duration, ease)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenX:1')
end

function window.doTweenY(tag, value, duration, ease)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'
        
        doTweenY(tag, 'window', value, duration, ease)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenY:1')
end

function window.doTweenPosition(tag, x, y, duration, ease)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'

        bcompat.startTween(tag, 'window', { x = x, y = y }, duration, {ease = ease})
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenPosition:1')
end

function window.doTweenSize(tag, width, height, duration, ease)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'
        
        bcompat.startTween(tag, 'window', { width = math.floor(width), height = math.floor(height) }, duration, {ease = ease})
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenSize:1')
end

function window.tweenToCenter(tag, axes, duration, options)
    window.init()
    if tag ~= nil then
        axes = axes or 'xy'
        axes = axes:lower()
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'

        local position = {}
        if axes:find('x') then 
            position['x'] = (window.desktopDimensions.width - window.getProperty('width')) / 2
        end
        if axes:find('y') then
            position['y'] = (window.desktopDimensions.height - window.getProperty('height')) / 2
        end

        bcompat.startTween(tag, 'window', position, duration, options)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.tweenToCenter:1')
end

function window.startTween(tag, values, duration, options)
    window.init()
    bcompat.startTween(tag, 'window', values, duration, options)
end

function window.setIcon(image)
    window.init()
    runHaxeCode('getVar("window").setIcon(Paths.image('.. helper.serialize(image, 'string') ..'))')
end

function window.alert(title, message)
    window.init()
    if title ~= nil and messsage ~= nil then
        helper.callMethod('window.alert', {message, title})
        return
    end
    local _missingParam = (title == nil and message == nil) and 'title & message:1&2' or (title == nil and 'title:1' or 'message:2')
    local _sepMissing = stringSplit(_missingParam, ':')
    debug.error('nil_param', { _sepMissing[1] }, 'window.alert:'.. _sepMissing[2])
end

function window.setTitle(title)
    window.init()
    window.setProperty('title', title or "Friday Night Funkin': Psych Engine")
end

function window.focus()
    window.init()
    helper.callMethod('window.focus', {''})
end

window.extraWindows = {}
function window.createWindow(tag, attributes)
    window.init()
    if version < '0.7' then
        if not helper.existsFromTable(window.extraWindows, tag) and not helper.variableExists(tag) then
            local function fetchAttr(attribute, default)
                if attributes[attribute] ~= nil then
                    return tostring(attributes[attribute])
                end
                return tostring(default)
            end

            runHaxeCode([[
                setVar(]].. helper.serialize(tag, 'string') ..[[, FlxG.stage.application.createWindow({
                    x: ]].. fetchAttr('x', 0) ..[[,
                    y: ]].. fetchAttr('y', 0) ..[[,
                    width: ]].. fetchAttr('width', 256) ..[[,
                    height: ]].. fetchAttr('height', 256) ..[[,
                    title: ]].. helper.serialize(fetchAttr('title', 'New Window'), 'string') ..[[,
                    resizable: ]].. fetchAttr('resizable', true) ..[[,
                    minimized: ]].. fetchAttr('minimized', false) ..[[,
                    maximized: ]].. fetchAttr('maximized', false)  ..[[,
                    fullscreen: ]].. fetchAttr('fullscreen', false) ..[[,
                    borderless: ]].. fetchAttr('borderless', false) ..[[,
                    alwaysOnTop: ]].. fetchAttr('alwaysOnTop', false) ..[[
                }));
            ]])

            table.insert(window.extraWindows, tag)
            return
        end
        debug.error('no_eq', {'tag ('.. tag ..')', 'an existing tag'}, 'window.createWindow:1')
        return
    end
    debug.error('', {}, 'window.createWindow', 'This function is not supported for this version.')
end

function window.closeWindow(tag)
    if helper.existsFromTable(window.extraWindows, tag) then
        helper.callMethod(tag ..'.close', {''})
        table.remove(window.extraWindows, helper.findIndex(window.extraWindows, tag))
    
        return
    end
    debug.error('unrecog_el', {tag, 'window.extraWindows'}, 'window.closeWindow:1')
end

window.close = os.exit

return window