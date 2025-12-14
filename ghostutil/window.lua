local window = {}

local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'
local bcompat = require 'ghostutil.backwards-compat'
local util = require 'ghostutil.util'

window.defaultDimensions = {width = 1280, height = 720}
window.desktopDimensions = {width = 0, height = 0}

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
    axes = axes:lower() or 'xy'
    if axes:find('x') then 
        window.setProperty('x', (window.desktopDimensions.width - window.getProperty('width')) / 2)
    end
    if axes:find('y') then
        window.setProperty('y', (window.desktopDimensions.height - window.getProperty('height')) / 2)
    end
end

function window.resize(width, height)
    window.init()
    window.setProperty('width', width or window.defaultDimensions.width)
    window.setProperty('width', height or window.defaultDimensions.height)
end

function window.doTweenX(tag, value, duration, options)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'

        bcompat.startTween(tag, 'window', { x = value }, duration, options)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenX:1')
end

function window.doTweenY(tag, value, duration, options)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'
        
        bcompat.startTween(tag, 'window', { y = value }, duration, options)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenY:1')
end

function window.doTweenPosition(tag, x, y, duration, options)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'

        bcompat.startTween(tag, 'window', { x = x, y = y }, duration, options)
        return
    end
    debug.error('nil_param', {'tag'}, 'window.doTweenPosition:1')
end

function window.doTweenSize(tag, width, height, duration, options)
    window.init()
    if tag ~= nil then
        options = options or {}
        options['onComplete'] = options['onComplete'] or 'onTweenCompleted'
        
        bcompat.startTween(tag, 'window', { width = width, height = height }, duration, options)
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

        local position = {x = window.getProperty('x'), y = window.getProperty('y')}
        if axes:find('x') then 
            position.x = (window.desktopDimensions.width - window.getProperty('width')) / 2
        end
        if axes:find('y') then
            position.y = (window.desktopDimensions.height - window.getProperty('height')) / 2
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

function window.cancelTween(tag) 
    cancelTween(tag) 
end

function window.pauseTween(tag)
    helper.callMethod((version >= '1.0' and '' or 'modchartTweens.').. tag ..'.pause', {})
end

function window.resumeTween(tag)
    helper.callMethod((version >= '1.0' and '' or 'modchartTweens.').. tag ..'.pause', {})
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
    helper.callMethod('window.focus', {})
end

window.extraWindows = {}
function window.createWindow(tag, attributes)
    window.init()
    if version < '0.7' then
        if not helper.existsFromTable(window.extraWindows, tag) and not helper.variableExists(tag) then
            attributes = attributes or {{}, {}}
            attributes[1][1] = helper.resolveDefaultValue(attributes[1][1], 0)
            attributes[1][2] = helper.resolveDefaultValue(attributes[1][2], 0)
            attributes[2][1] = helper.resolveDefaultValue(attributes[2][1], 256)
            attributes[2][2] = helper.resolveDefaultValue(attributes[2][2], 256)
            attributes[3]    = helper.resolveDefaultValue(attributes[3], 'New Window')
            attributes[4]    = helper.resolveDefaultValue(attributes[4], true)
            attributes[5]    = helper.resolveDefaultValue(attributes[5], false)
            attributes[6]    = helper.resolveDefaultValue(attributes[6], false)
            attributes[7]    = helper.resolveDefaultValue(attributes[7], false)
            attributes[8]    = helper.resolveDefaultValue(attributes[8], false)
            attributes[9]    = helper.resolveDefaultValue(attributes[9], false)

            runHaxeCode([[
                setVar(]].. helper.serialize(tag, 'string') ..[[, FlxG.stage.application.createWindow({
                    x: ]].. attributes[1][1] ..[[,
                    y: ]].. attributes[1][2] ..[[,
                    width: ]].. attributes[2][1] ..[[,
                    height: ]].. attributes[2][2] ..[[,
                    title: ]].. helper.serialize(attributes[3], 'string') ..[[,
                    resizable: ]].. tostring(attributes[4]) ..[[,
                    minimized: ]].. tostring(attributes[5]) ..[[,
                    maximized: ]].. tostring(attributes[6]) ..[[,
                    fullscreen: ]].. tostring(attributes[7]) ..[[,
                    borderless: ]].. tostring(attributes[8]) ..[[,
                    alwaysOnTop: ]].. tostring(attributes[9]) ..[[
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
        callMethod(tag ..'.close', {})
        table.remove(window.extraWindows, helper.findIndex(window.extraWindows, tag))
    
        return
    end
    debug.error('unrecog_el', {tag, 'window.extraWindows'}, 'window.closeWindow:1')
end

window.close = os.exit

return window