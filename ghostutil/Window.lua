---@meta Window
---@author GhostglowDev

---Window manipulation related
---@class Window
local window = {}

local d = require "ghostutil.Debug"
local u = require "ghostutil.Util"

local activeTweens = {}
local extraWindows = {}

window.defaultDimensions = {width = 1280, height = 720}
window.desktopDimensions = {width = 0, height = 0}

---@author GhostglowDev, galactic_2005
---@param ease string
---@return string FlxEase
local function getFlxEaseByString(ease)
    local eases = {
        ["back"] = "back", ["bounce"] = "bounce", ["circ"] = "circ", ["cube"] = "cube",
        ["elastic"] = "elastic", ["expo"] = "expo", ["quad"] = "quad", ["quart"] = "quart",
        ["quint"] = "quint", ["sine"] = "sine", ["smoothstep"] = "smoothStep", ["smootherstep"] = "smootherStep"
    }

    local easeEndings = {
        "InOut", "In", "Out"
    }

    local easeEnd = ''
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

function removeActiveWindowTween(t)
    debugPrint("window.removeActiveWindowTween")
    for i = 1, #activeTweens do
        if activeTweens[i][1] == t then 
            table.remove(activeTweens, i)
            return  
        end
    end
end

function _gcall(func)
    if func == "createpost" then
        addHaxeLibrary("Application", "lime.app")
        addHaxeLibrary("Lib", "openfl")
        addHaxeLibrary("Image", "lime.graphics")
        window.desktopDimensions = {
            width = getPropertyFromClass("openfl.Lib", "application.window.display.bounds.width"),
            height = getPropertyFromClass("openfl.Lib", "application.window.display.bounds.height")
        }
    elseif func == "destroy" then
        if #extraWindows < 1 then return end
        for i = 1, #extraWindows do
            if extraWindows[i][2] then
                runHaxeCode(
                    extraWindows[i][1].. [[.close();
                ]])
            end
        end
    end
end

---Sets the window position to the target value
---@param pos table<number>|number The new positions. {x, y}. If both values are the same then type in the value in the `number` type
window.setPosition = function(pos)
    window.setProperty("x", (u.isTable(pos) and pos[1] or pos)) window.setProperty("y", (u.isTable(pos) and pos[2] or pos))
end

---Closes the window
window.close = function()
    os.exit()
end

---Tweens the window X position to the target value
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`
---@param value number Target X position to tween to
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
window.windowTweenX = function(tag, value, duration, ease)
    if tag == nil or value == nil then d.error("window.windowTweenX:".. (tag == nil and "1" or ((tag == nil and value == nil) and "1-2" or "2")) ..": Value is null/nil") return else
        value, duration, ease = tostring(value), tostring(duration) or "1", ease or "linear"
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
                FlxTween.tween(Application.current.window, {x: ]]..value..[[}, ]]..duration..[[, {
                    ease: ]]..getFlxEaseByString(ease)..[[, 
                    onComplete: () -> { 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                    }
                })
            );
        ]])
    end

    table.insert(activeTweens, {tag, false})
end

---Tweens the window Y position to the target value
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`
---@param value number Target Y position to tween to
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
window.windowTweenY = function(tag, value, duration, ease)
    if tag == nil or value == nil then d.error("window.windowTweenY:".. (tag == nil and "1" or ((tag == nil and value == nil) and "1-2" or "2")) ..": Value is null/nil") return else
        value, duration, ease = tostring(value), tostring(duration) or "1", ease or "linear"
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
                FlxTween.tween(Application.current.window, {y: ]]..value..[[}, ]]..duration..[[, {
                    ease: ]]..getFlxEaseByString(ease)..[[, 
                    onComplete: () -> { 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", [']]..tag..[[']); 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", [']]..tag..[[']);

                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                    }
                })
            );
        ]])
    end

    table.insert(activeTweens, {tag, false})
end

---Tweens the window position to the target values
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`.
---@param values table<number>|number The values. {x, y}. If both are same just type in the value in the `number` type
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
window.windowTweenPosition = function(tag, values, duration, ease) 
    if tag == nil or values[1] == nil or values[2] == nil then d.error("window.windowTweenPosition:".. (tag == nil and "1" or ((tag == nil and (values[1] == nil or values[2] == nil)) and "1-2" or "2")) ..": Value is null/nil") return else
        duration, ease = tostring(duration) or "1", ease or "linear"
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
                FlxTween.tween(Application.current.window, {x: ]]..tostring(values[1])..[[, y: ]]..tostring(values[2])..[[}, ]]..duration..[[, {
                    ease: ]]..getFlxEaseByString(ease)..[[, 
                    onComplete: () -> { 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                    }
                })
            );
        ]])
    end
end

---Pauses an active window tween
---@param t string Window tween tag
window.pauseTween = function(t)
    local exists = false
    if #activeTweens < 1 then
        d.error("window.pauseTween: There's no active window tweens.")
        return
    end

    for i = 1, #activeTweens do
        if activeTweens[i][1] == t then
            exists = true
            if activeTweens[i][2] == true then
                d.warning("window.pauseTween: The tween '"..t.."' is already paused.")
                return
            end
            activeTweens[i][2] = true
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
window.resumeTween = function(t)
    local exists = false
    if #activeTweens < 1 then
        d.error("window.resumeTween: There's no active window tweens.")
        return
    end

    for i = 1, #activeTweens do
        if activeTweens[i][1] == t then
            exists = true
            if activeTweens[i][2] == false then
                d.warning("window.resumeTween: The tween '"..t.."' is already playing.")
                return
            end
            activeTweens[i][2] = false
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
window.cancelTween = function(t)
    local exists = false
    if #activeTweens < 1 then
        d.error("window.cancelTween: There's no active window tweens.")
        return
    end

    for i = 1, #activeTweens do
        if activeTweens[i][1] == t then
            exists = true
            table.remove(activeTweens, i)
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
window.screenCenter = function(xy)
    xy = xy or "xy"
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
window.tweenToCenter = function(tag, xy, duration, ease)
    xy, onCompleteTag = xy or "xy", onCompleteTag or "WindowCenter"
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
window.resizeTo = function(values)
    window.setProperty("width", ((u.isTable(values) and values[1] or values) or window.defaultDimensions.width)) window.setProperty("height", ((u.isTable(values) and values[1] or values) or window.defaultDimensions.height))
end

---Resizes the window using tweens
---@param tag string For pausing/resuming, cancelling and for `onTweenCompleted`.
---@param values table<number>|number The values. {width, height}. If both values are the same then type in the value in `number` type
---@param duration? number The time it takes to complete
---@param ease? string FlxEase
window.tweenResizeTo = function(tag, values, duration, ease)
    if tag == nil or values == nil then d.error("window.windowTweenResize:".. (tag == nil and "1" or ((tag == nil and value == nil) and "1-2" or "2")) ..": Value is null/nil") return else
        duration, ease = tostring(duration) or "1", ease or "linear"
        runHaxeCode(
            (version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.set(']]..tag..[[', 
                FlxTween.tween(Application.current.window, {width: ]]..(u.isTable(values) and values[1] or values)..[[, height: ]]..(u.isTable(values) and values[2] or values)..[[}, ]]..duration..[[, {
                    ease: ]]..getFlxEaseByString(ease)..[[, 
                    onComplete: () -> { 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("onTweenCompleted", ["]]..tag..[["]); 
                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.callOnLuas("removeActiveWindowTween", ["]]..tag..[["]);

                        ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartTweens.remove(']]..tag..[[');
                    }
                })
            );
        ]])
    end

    table.insert(activeTweens, {tag, false})
end

---Image must be located in mods/images or assets/images
---@param img string Image
window.setIcon = function(img)
    runHaxeCode([[
        Application.current.window.setIcon(Image.fromFile(Paths.image(']]..img..[[')));
    ]])
end

---Creates a alert window
---@param title string Alert window title
---@param msg string Alert window message
window.alert = function(title, msg)
    runHaxeCode("Application.current.window.alert('"..tostring((msg or (scriptName..":GhostUtil: window.alert:2: Expected a value"))).."', '"..tostring((title or "GhostUtil Error")).."');")
end

---Changes the application title
---@param title? string Application title
window.changeTitle = function(title)
    window.setProperty("title", (title or "Friday Night Funkin': Psych Engine"))
end

---Focuses the current window
window.focus = function()
    runHaxeCode("Application.current.window.focus();")
end

---Creates a window
---@param winName string The "tag" for the window name
---@param attributes? table<any> The new window attributes {x, y, width, height, title, resizable, minimized, maximized, fullscreen, borderless, alwaysOnTop} All arguments are optional.
---@param closeOnDestroy? boolean Closes the extra windows on destroy
window.createWindow = function(winName, attributes, closeOnDestroy)
    if winName == nil then
        d.error("window.createWindow:1: Expected string, got null.")
        return
    end

    resizable = resizable == nil and true or resizable
    runHaxeCode([[
        ]]..winName..[[ = Application.current.createWindow({
            x: ]]..(attributes[1][1] or 0)..[[,
            y: ]]..(attributes[1][2] or 0)..[[,
            width: ]]..(attributes[2][1] or 1280)..[[,
            height: ]]..(attributes[2][2] or 720)..[[,
            title: ]]..(attributes[3] or "New Window")..[[,
            resizable: ]]..(attributes[4])..[[,
            minimized: ]]..(attributes[5] or false)..[[,
            maximized: ]]..(attributes[6] or false)..[[,
            fullscreen: ]]..(attributes[7] or false)..[[,
            borderless: ]]..(attributes[8] or false)..[[,
            alwaysOnTop: ]]..(attributes[9] or false)..[[,
        });
    ]])

    closeOnDestroy = closeOnDestroy == nil and true or closeOnDestroy
    table.insert(extraWindows, {winName, (closeOnDestroy)})
end

---Sets a certain property of the current window
---@param var string Target property to set
---@param val any New value
window.setProperty = function(var, val)
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
window.getProperty = function(var)
    local vars = {"borderless", "height", "width", "x", "y", "fullscreen", "title", "resizable"}
    for i = 1, #vars do if var == vars[i] then return getPropertyFromClass("lime.app.Application", "current.window."..var); end end
    d.error("window.getProperty:1: Attempt to get an "..(var == nil and "nil" or "unknown").." window property")
end

return window