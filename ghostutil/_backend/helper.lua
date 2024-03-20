local helper = {}
local debug = require 'ghostutil.Debug'

function helper.getCameraFromString(cam)
    if cam:lower() == "hud" or cam:lower() == "camhud" then return "camHUD"
    elseif cam:lower() == "other" or cam:lower() == "camother" then return "camOther"
    else return "camGame" end
end

function helper.serialize(v, t)
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

function helper.retTbl(t, i, x)
    return (type(t) == 'table' and t[i] or (type(t) == 'string' and (t .. (x or '')) or t))
end

function helper.resolveAlternative(t, l)
    local _t = {}
    if type(t) ~= 'table' then
        for _ = 1, l do
            table.insert(_t, t)
        end
    end

    return type(t) == 'table' and t or _t
end

function helper.validate(params, types)
    local ret = true
    for i, v in ipairs(params) do
        if type(v) == nil then return false end
        if type(v) ~= types[i] then
            local t = ''
            if (type(types[i]) == 'table') then
                for i, t2 in ipairs(types[i]) do
                    t = t .. t2 .. (i == #types[i] and '' or ' or ')
                end
            else t = types[i] end

            debug.error("Expected ".. t .. ", got ".. type(v) .." instead.")
            ret = false
        end
    end
    return ret
end

function helper.resolveDefaultValue(param, default)
    return (
        type(param) == nil and param or default
    )
end

function helper.getFlxEaseByString(ease)
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

function helper.instanceExists(insTbl, instance)
    local exists = false
    for _, v in ipairs(insTbl) do
        if v == instance then
            exists = true
            break
        end
    end

    return exists
end

function helper.variableExists(var) 
    return runHaxeCode("return game.variables.exists('".. var .."');")
end

return helper