---@meta window
---@author GhostglowDev

---Window manipulation related
---@class Window
local window = {}

local d = require "ghostutil.debug"
local u = require "ghostutil.util"

local _h = require "ghostutil._backend.helper"

window.activeTweens = {}
window.extraWindows = {}

window.defaultDimensions = {width = 1280, height = 720}
window.desktopDimensions = {width = 0, height = 0}

function removeActiveWindowTween(t)
    for i, tweenData in ipairs(window.activeTweens) do
        if tweenData[1] == t then 
            table.remove(window.activeTweens, i)
            return  
        end
    end
end

function __window_gcall(func, _)
    if func == "createpost" then
        addHaxeLibrary("Application", "lime.app")
        addHaxeLibrary("Lib", "openfl")
        addHaxeLibrary("Image", "lime.graphics")
        window.desktopDimensions = {
            width = getPropertyFromClass("openfl.Lib", "application.window.display.bounds.width"),
            height = getPropertyFromClass("openfl.Lib", "application.window.display.bounds.height")
        }
    elseif func == "destroy" then
        if #window.extraWindows < 1 then return end
        for _, windowData in ipairs(window.extraWindows) do
            if windowData[2] then
                runHaxeCode(
                    windowData[1].. [[.close();
                ]])
            end
        end
    end
end

---Sets the window position to the target value
---@param pos table<number>|number The new positions. {x, y}. If both values are the same then type in the value in the `number` type
function window.setPosition(pos)
    pos = _h.resolveAlternative(pos, 2)
    window.setProperty("x", pos[1]) window.setProperty("y", pos[2])
end

---Closes the window
function window.close()
    os.exit()
end

---Tweens the window X position to the target value
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`
---@param value number Target X position to tween to
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
function window.windowTweenX(tag, value, duration, ease)
    if not _h.validate({tag, value}, {'string', 'number'}) then return end
    duration, ease = _h.resolveDefaultValue(duration, 1), _h.resolveDefaultValue(ease, 'linear')
    value, duration = tostring(value), tostring(duration)
    runHaxeCode(
        (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
            FlxTween.tween(Application.current.window, {x: ]]..value..[[}, ]]..duration..[[, {
                ease: ]].._h.getFlxEaseByString(ease)..[[, 
                onComplete: () -> { 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                }
            })
        );
    ]])

    table.insert(window.activeTweens, {tag, false})
end

---Tweens the window Y position to the target value
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`
---@param value number Target Y position to tween to
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
function window.windowTweenY(tag, value, duration, ease)
    if not _h.validate({tag, value}, {'string', 'number'}) then return end
    duration, ease = _h.resolveDefaultValue(duration, 1), _h.resolveDefaultValue(ease, 'linear')
    value, duration = tostring(value), tostring(duration)
    runHaxeCode(
        (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
            FlxTween.tween(Application.current.window, {y: ]]..value..[[}, ]]..duration..[[, {
                ease: ]].._h.getFlxEaseByString(ease)..[[, 
                onComplete: () -> { 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", [']]..tag..[[']); 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", [']]..tag..[[']);

                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                }
            })
        );
    ]])

    table.insert(window.activeTweens, {tag, false})
end

---Tweens the window position to the target values
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`.
---@param values table<number>|number The values. {x, y}. If both are same just type in the value in the `number` type
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
function window.windowTweenPosition(tag, values, duration, ease) 
    if not _h.validate({tag}, {'string'}) then return end
    if type(values) ~= 'table' or type(values) ~= 'number' then return d.error('Expected table/number, got '.. type(values) ..' instead.') end

    values = _h.resolveAlternative(values, 2)
    duration, ease = _h.resolveDefaultValue(duration, '1'), _h.resolveDefaultValue(ease, 'linear')
    runHaxeCode(
        (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
            FlxTween.tween(Application.current.window, {x: ]]..tostring(values[1])..[[, y: ]]..tostring(values[2])..[[}, ]]..duration..[[, {
                ease: ]].._h.getFlxEaseByString(ease)..[[, 
                onComplete: () -> { 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                }
            })
        );
    ]])
end

---Pauses an active window tween
---@param t string Window tween tag
function window.pauseTween(t)
    local exists = false
    if #window.activeTweens < 1 then
        d.error("window.pauseTween: There's no active window tweens.")
        return
    end

    for _, tweenData in ipairs(window.activeTweens) do
        if tweenData[1] == t then
            exists = true
            if tweenData[2] == true then
                d.warning("window.pauseTween: The tween '"..t.."' is already paused.")
                return
            end
            tweenData[2] = true
            break
        end
    end

    if exists then
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.get(']].. t ..[[').active = false;
        ]])
    end
end

---Resumes a paused window tween
---@param t string Window tween tag
function window.resumeTween(t)
    local exists = false
    if #window.activeTweens < 1 then
        d.error("window.resumeTween: There's no active window tweens.")
        return
    end

    for _, tweenData in ipairs(window.activeTweens) do
        if tweenData[1] == t then
            exists = true
            if tweenData[2] == false then
                d.warning("window.resumeTween: The tween '"..t.."' is already playing.")
                return
            end
            tweenData[2] = false
            break
        end
    end

    if exists then
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.get(']].. t ..[[').active = true;
        ]])
        return
    end
    d.error("window.resumeTween:1: The tween with tag '"..t.."' doesn't exist.")
end

---Cancels a window tween
---@param t string Window tween tag
function window.cancelTween(t)
    local exists = false
    if #window.activeTweens < 1 then
        d.error("window.cancelTween: There's no active window tweens.")
        return
    end

    for _, tweenData in ipairs(window.activeTweens) do
        if tweenData[1] == t then
            exists = true
            table.remove(window.activeTweens, i)
            break
        end
    end

    if exists then
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.get(']].. t ..[[').cancel();
            ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.get(']].. t ..[[').destroy();
            ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']].. t ..[[');
        ]])
        return
    end
    d.error("window.cancelTween:1: The tween with tag '".. t .."' doesn't exist.")
end

---Centers the window 
---@param xy? string x, y or xy
function window.screenCenter(xy)
    xy = _h.resolveDefaultValue(xy, 'xy')

    if xy == "xy" then
        window.setPosition({
            (window.desktopDimensions.width - window.getProperty("width")) / 2,
            (window.desktopDimensions.height - window.getProperty("height")) / 2
        })
    elseif xy == "x" then
        window.setProperty("x", (window.desktopDimensions.width - window.getProperty("width")) / 2)
    elseif xy == "y" then
        window.setProperty("y", (window.desktopDimensions.height - window.getProperty("height")) / 2)
    else
        d.error("window.screenCenter:1: Unknown value '"..xy.."'")
    end
end

---Tweens the window to the center of the desktop
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`
---@param xy? string x, y or xy (Default: "xy")
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
function window.tweenToCenter(tag, xy, duration, ease)
    xy = _h.resolveDefaultValue(xy, 'xy')

    if xy == "xy" then
        window.windowTweenPosition(tag, {
            (window.desktopDimensions.width - window.getProperty("width")) / 2, 
            (window.desktopDimensions.height - window.getProperty("height")) / 2
        }, duration, ease)
    elseif xy == "x" then
        window.windowTweenX(tag, (window.desktopDimensions.width - window.getProperty("width")) / 2, duration, ease)
    elseif xy == "y" then
        window.windowTweenY(tag, (window.desktopDimensions.height - window.getProperty("height")) / 2, duration, ease)
    end
end

---Resizes the window
---@param values table<number>|number The values. {width, height}. If both values are the same then type in the value in `number` type
function window.resizeTo(values)
    values = _h.resolveAlternative(values, 2)
    window.setProperty("width", (values[1] or window.defaultDimensions.width)) window.setProperty("height", (values[2] or window.defaultDimensions.height))
end

---Resizes the window using tweens
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`.
---@param values table<number>|number The values. {width, height}. If both values are the same then type in the value in `number` type
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
function window.tweenResizeTo(tag, values, duration, ease)
    if not _h.validate({tag}, {'string'}) then return end
    if type(values) ~= 'table' or type(values) ~= 'number' then return end

    values = _h.resolveAlternative(values, 2)
    duration, ease = _h.resolveDefaultValue(duration, '1'), _h.resolveDefaultValue(ease, 'linear')

    runHaxeCode(
        (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
            FlxTween.tween(Application.current.window, {width: ]]..(u.isTable(values) and values[1] or values)..[[, height: ]]..(u.isTable(values) and values[2] or values)..[[}, ]]..duration..[[, {
                ease: ]].._h.getFlxEaseByString(ease)..[[, 
                onComplete: () -> { 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                    ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                }
            })
        );
    ]])

    table.insert(window.activeTweens, {tag, false})
end

---Image must be located in mods/images or assets/images
---@param img string Image
function window.setIcon(img)
    runHaxeCode([[
        Application.current.window.setIcon(Image.fromFile(Paths.image(']]..img..[[')));
    ]])
end

---Creates a alert window
---@param title string Alert window title
---@param msg string Alert window message
function window.alert(title, msg)
    runHaxeCode("Application.current.window.alert('"..tostring((msg or (scriptName..":GhostUtil: window.alert:2: Expected a value"))).."', '"..tostring((title or "GhostUtil Error")).."');")
end

---Changes the application title
---@param title? string Application title
function window.changeTitle(title)
    window.setProperty("title", (title or "Friday Night Funkin': Psych Engine"))
end

---Focuses the current window
function window.focus()
    runHaxeCode("Application.current.window.focus();")
end

---Creates a window
---@param winName string The "tag" for the window name
---@param attributes? table<any> The new window attributes {x, y, width, height, title, resizable, minimized, maximized, fullscreen, borderless, alwaysOnTop} All arguments are optional.
---@param closeOnDestroy? boolean Closes the extra windows on destroy
function window.createWindow(winName, attributes, closeOnDestroy)
    if winName == nil then
        d.error("window.createWindow:1: Expected string, got null.")
        return
    end

    attributes[1][1] = _h.resolveDefaultValue(attributes[1][1], 0)
    attributes[1][2] = _h.resolveDefaultValue(attributes[1][2], 0)
    attributes[2][1] = _h.resolveDefaultValue(attributes[2][1], 256)
    attributes[2][2] = _h.resolveDefaultValue(attributes[2][2], 256)
    attributes[3] = _h.resolveDefaultValue(attributes[3], 'New Window')
    attributes[4] = _h.resolveDefaultValue(attributes[4], true)
    attributes[5] = _h.resolveDefaultValue(attributes[5], false)
    attributes[6] = _h.resolveDefaultValue(attributes[6], false)
    attributes[7] = _h.resolveDefaultValue(attributes[7], false)
    attributes[8] = _h.resolveDefaultValue(attributes[8], false)
    attributes[9] = _h.resolveDefaultValue(attributes[9], false)

    runHaxeCode([[
        ]]..winName..[[ = Application.current.createWindow({
            x: ]].. attributes[1][1] ..[[,
            y: ]].. attributes[1][2] ..[[,
            width: ]].. attributes[2][1] ..[[,
            height: ]].. attributes[2][2] ..[[,
            title: ]].. attributes[3] ..[[,
            resizable: ]].. attributes[4] ..[[,
            minimized: ]].. attributes[5] ..[[,
            maximized: ]].. attributes[6] ..[[,
            fullscreen: ]].. attributes[7] ..[[,
            borderless: ]].. attributes[8] ..[[,
            alwaysOnTop: ]].. attributes[9] ..[[,
        });
    ]])

    closeOnDestroy = closeOnDestroy == nil and true or closeOnDestroy
    table.insert(window.extraWindows, {winName, (closeOnDestroy)})
end

---Sets a certain property of the current window
---@param var string Target property to set
---@param val any New value
function window.setProperty(var, val)
    if val == nil or (val == "" and not var == "title") then
        d.error("window.setProperty:2: "..(val == nil and "Value is nil" or "Unknown value: '"..val.."'"))
    else
        local vars = {"borderless", "height", "width", "x", "y", "fullscreen", "title", "resizable"}
        for i = 1, #vars do if var == vars[i] then setPropertyFromClass("lime.app.Application", "current.window."..var, val); return end end
        d.error("window.setProperty:1: Attempt to set the application's "..(var == nil and "nil" or "unknown").." value")
    end
end

---Gets the specified property of the current window
---@param var string Target property to return
---@return any property Object Property
function window.getProperty(var)
    local vars = {"borderless", "height", "width", "x", "y", "fullscreen", "title", "resizable"}
    for i = 1, #vars do if var == vars[i] then return getPropertyFromClass("lime.app.Application", "current.window."..var); end end
    d.error("window.getProperty:1: Attempt to get an "..(var == nil and "nil" or "unknown").." window property")
end

return window