local helper = {}
local debug = require 'ghostutil.debug'

luaDebugMode = true
helper.extensions = {}
helper.initialized = false
helper.throwError = true

function helper.init()
    if not helper.initialized then
        addHaxeLibrary('Lambda')
        if version >= '0.7' then
            createInstance('__gu_hscript__', 'psychlua.HScript', {nil, ''})
            -- prevent creating a bunch of HScript instances for simple haxe codes
            runHaxeCode([[
                function luaObjectExists(tag:String)
                    return game.getLuaObject(tag) != null;
            ]])
        end
        helper.initialized = true
    end
end

function helper.reflect()
    local exists, reflect = pcall(helper.connect, 'reflect')
    if version < '0.7' then
        if not exists then
            if helper.throwError then
                runHaxeCode([[
                    FlxG.stage.window.alert([
                        'COMPATIBILITY ERROR!', 
                        '',
                        "You're currently using Psych Engine version ]].. version ..[[!", 
                        "As of version 3.0.0, Ghost's Utilities no longer supports this version of Psych Engine.",
                        '',
                        'Either update to a later supported version (0.7 or higher), or install the "reflect" extension for a compatibility bridge.',
                        'It is recommended that you update to the latest version for the best and more optimized experience.'
                    ].join("\n"), "Ghost's Utilities: Fatal Error");
                ]])
            end
            return nil
        end
    end
    return reflect
end

function resolveReflect(reffn, psychfn, args, minVer)
    minVer = minVer or '0.7'
    if helper.reflect() == nil and version < minVer then
        debug.error(nil, nil, 'COMPAT ERROR', 'You\'re currently using Psych Engine '.. version ..'.\nExtension "reflect.lua" is needed for running function "'.. reffn ..'"!')
    else
        return version < tostring(minVer) and helper.reflect()[reffn](unpack(args)) or (psychfn ~= nil and psychfn(unpack(args)) or nil) 
    end
end

function helper.instanceArg(instance, class)
    return resolveReflect('instanceArg', instanceArg, {instance, class}, '0.7.2h')
end

function helper.callMethod(method, args)
    return resolveReflect('callMethod', callMethod, {method, args}, '0.7.2h')
end

function helper.callMethodFromClass(class, method, args)
    return resolveReflect('callMethodFromClass', callMethodFromClass, {class, method, args}, '0.7.2h')
end

function helper.createInstance(tag, className, args)
    return resolveReflect('createInstance', createInstance, {tag, className, args}, '1.0')
end

function helper.addInstance(instance, front)
    return resolveReflect('addInstance', addInstance, {instance, front})
end

function helper.setProperty(prop, value, allowMaps, allowInstances) 
    return resolveReflect('setProperty', setProperty, {prop, value, allowMaps, allowInstances}, '1.0')
end

function helper.setPropertyFromClass(class, prop, value, allowMaps, allowInstances)
    return resolveReflect('setPropertyFromClass', setPropertyFromClass, {class, prop, value, allowMaps, allowInstances}, '1.0')
end

function helper.setPropertyFromGroup(group, index, prop, value, allowMaps, allowInstances)
    return resolveReflect('setPropertyFromGroup', setPropertyFromGroup, {group, index, prop, value, allowMaps, allowInstances}, '1.0')
end

function helper.connect(name)
    helper.init()
    if not helper.extensions[name] then
        local exists, extension = pcall(require, 'ghostutil.extensions.'.. name)
        if exists then 
            helper.extensions[name] = extension 
        else debug.error('EXTENSION ERROR', 'Failed to load GhostUtil extension: "'.. name ..'"') end
    end
    return helper.extensions[name]
end

function helper.getCameraFromString(camera)
    camera = camera:lower()
    
        if camera:find('other')          then return 'camOther'
    elseif camera:find('hud')            then return 'camHUD' 
    elseif helper.variableExists(camera) then return camera
    else   return 'camGame'
    end
end

function helper.serialize(value, t)
    if t == 'string' then
        if type(value) == 'string' then
            return ("'%s'"):format(value:gsub('\'', '\\\''))
        end  
    elseif t == 'array' or t == 'table' then
        if type(value) == 'table' then
            local arr = '['
            for i, v in ipairs(value) do
                arr = arr .. helper.serialize(v, type(v)) .. (i == #value and '' or ', ')
            end

            return arr ..']'
        end
    elseif t == 'map' or t == 'dictionary' or t == 'dict' then
        if type(value) == 'table' then
            local map = '['
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                map = map .. helper.serialize(k, type(k)) .. ' => ' .. helper.serialize(v, type(v)) .. (i == helper.getDictLength(value) and '' or ', ')
            end
            return map ..']'
        end
    elseif t == 'struct' or t == 'structure' or t == 'anonstruct' then
        if type(value) == 'table' then
            local struct = '{'
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                struct = struct .. k .. ': ' .. helper.serialize(v, type(v)) .. (i == helper.getDictLength(value) and '' or ', ')
            end
            return struct ..'}'
        end
    elseif t == 'bool' or t == 'boolean' then
        if type(value) == 'boolean' then
            return tostring(value)
        end
    end
    return value
end

function helper.hgetKeys(map)
    helper.init()
    return runHaxeCode('return Lambda.array({ iterator: '.. helper.parseObject(map) ..'.keys });')
end

function helper.getKeys(dict)
    local keys = {}
    for key in pairs(dict) do
        table.insert(keys, key)
    end
    return keys
end

function helper.eqAny(val, toCheck)
    for _, check in ipairs(toCheck) do
        if val == check then
            return true
        end
    end
    return false
end

function helper.isInt(number)
    if type(number) == 'number' then
        return number % 1 == 0
    end
    return false
end

function helper.isFloat(number)
    return not helper.isInt(number)
end

function helper.findIndex(tbl, el) 
    for i, v in ipairs(tbl) do
        if v == el then return i end
    end
    return 0
end

function helper.findKey(tbl, value) 
    for k, v in pairs(tbl) do
        if v == value then return k end
    end
    return 0
end

function helper.existsFromTable(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

function helper.keyExists(tbl, key)
    for k in pairs(tbl) do
        if k == key then return true end
    end
    return false
end

function helper.getDictLength(dict)
    local len = 0
    for _ in pairs(dict) do len = len + 1 end

    return len
end

function helper.pack(value, length)
    local ret = {}
    for _ = 1, length do table.insert(ret, value) end

    return ret
end

function helper.fillTable(tbl, value, length)
    if length > #tbl then
        for i = #tbl + 1, length do
            table.insert(tbl, value)
        end
    end
    return tbl
end

function helper.resizeTable(tbl, length)
    while #tbl > length do
        table.remove(tbl, #tbl)
    end
    return tbl
end

function helper.resolveAlt(value, length)
    if type(value) ~= 'table' then
        return helper.pack(value, length)
    end
    return value
end

function helper.validate(params, types)
    local ret = true
    for i, t in ipairs(types) do
        local param = params[i]
        if (helper.isOfType(t, 'table')) then
            local passed = false
            local types = ''
            for i2, t2 in ipairs(t) do
                types = types .. t2 .. (i2 == #t and '' or ' or ')
                if helper.isOfType(param, t2) then
                    passed = true 
                    break
                end                
            end

            if not passed then
                ret = false
                debug.exception('wrong_type', 'error', {helper.serialize(types, 'table'), type(param)})
            end
        else
            if not helper.isOfType(param, t) then
                ret = false
                debug.exception('wrong_type', 'error', {t, type(param)})
            end
        end
    end

    return ret
end

function helper.parseObject(obj)
    local ret = 'game.%s'
    if helper.variableExists(obj) then
        ret = 'getVar("%s")'
    elseif helper.luaObjectExists(obj) then
        ret = 'game.getLuaObject("%s"'.. (version >= '0.7' and '' or ', true') ..')'
    end
    return ret:format(obj)
end

-- from Stack Overflow:
-- https://stackoverflow.com/a/15278426/29508255
function helper.concat(t1, t2)
    for i=1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function helper.concatDict(d1, d2)
    for k, v in pairs(d2) do
        d1[k] = v
    end
end

function helper.isOfType(self, t)
    return type(self) == t;
end

-- why not ternary? booleans don't work with it
function helper.resolveDefaultValue(value, default)
    if helper.isOfType(value, 'nil') then return default
    else return value end
end

function helper.getTweenEaseByString(ease)
    if ease ~= nil and #ease >= 1 then
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
    end
    return "FlxEase.linear"
end

function helper.getTweenType(twnType)
    if type(twnType) == 'number' then
        if helper.existsFromTable({1, 2, 4, 8, 16}, twnType) then
            return twnType
        end
    elseif type(twnType) == 'string' then
        twnType = twnType:lower()
        if twnType == 'persist'  then return 1  end
        if twnType == 'looping'  then return 2  end
        if twnType == 'pingpong' then return 4  end
        if twnType == 'oneshot'  then return 8  end
        if twnType == 'backward' then return 16 end
    end
    return 8
end

function helper.objectExists(obj)
    return helper.variableExists(obj) 
    or helper.luaObjectExists(obj) 
    or helper.callMethodFromClass('Reflect', 'hasField', { helper.instanceArg('instance', version < '0.7' and 'PlayState' or 'states.PlayState'), obj })
end

function helper.variableExists(var)
    return helper.callMethod('variables.exists', {var})
end

function helper.luaObjectExists(obj)
    helper.init()
    if version >= '0.7' then
        return runHaxeFunction('luaObjectExists', {obj})
    else
        return runHaxeCode(('return game.getLuaObject("%s", true) != null;'):format(obj))
    end
end

return helper