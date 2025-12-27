local helper = {}
local debug = require 'ghostutil.debug'

luaDebugMode = true
helper.extensions = {}
helper.initialized = false
helper.throwError = true

function gcall_helper(fn, args)
    for name, extension in pairs(helper.extensions) do
        if extension['callback'] then
            extension.callback(fn, args)
        end
    end
end

function helper.init()
    if helper.legacyAvailable() then
        if not helper.initialized then
            debug.warnOutdate()
            
            helper.addHaxeLibrary('Lambda')
            helper.initialized = true
        end
    end
end

function helper.reflect()
    local exists, reflect = pcall(helper.connect, 'reflect')
    if helper.legacyAvailable() then
        if version < '1.0' and not exists and helper.throwError then
            runHaxeCode([[
                FlxG.stage.window.alert([
                    'COMPATIBILITY ERROR!', 
                    '',
                    "You're currently using Psych Engine version ]].. version ..[[!", 
                    "As of version 3.0, Ghost's Utilities no longer supports this version of Psych Engine.",
                    '',
                    'Either update to a later supported version (1.0 or higher), or install the "reflect" extension for a compatibility bridge.',
                    'It is recommended that you update to the latest version for the best and more optimized experience.'
                ].join("\n"), "Ghost's Utilities: Fatal Error");
            ]])
            return nil
        end
    end
    return reflect
end

function helper.legacyAvailable()
    if version < '0.7' then
        if makeLuaSprite == nil then 
            return false 
        end
    end
    return true
end

function resolveReflect(reffn, psychfn, args, minVer)
    minVer = minVer or '0.7'
    if version < minVer then
        if helper.reflect() == nil then
            debug.error(nil, nil, 'COMPAT ERROR', 'You\'re currently using Psych Engine '.. version ..'.\nExtension "reflect.lua" is needed for running function "'.. reffn ..'"!')
            return nil
        end
        return helper.reflect()[reffn](unpack(args))
    else
        if psychfn ~= nil then
            return psychfn(unpack(args))
        end
        return nil
    end
end

function helper.instanceArg(instance, class)
    return resolveReflect('instanceArg', instanceArg, {instance, class}, '1.0')
end

function helper.callMethod(method, args)
    return resolveReflect('callMethod', callMethod, {method, args}, '1.0')
end

function helper.callMethodFromClass(class, method, args)
    return resolveReflect('callMethodFromClass', callMethodFromClass, {class, method, args}, '1.0')
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
        else 
            debug.error('EXTENSION ERROR', 'Failed to load GhostUtil extension: "'.. name ..'"') 
            return nil
        end
    end
    return helper.extensions[name]
end

function helper.getCameraFromString(_camera)
    camera = _camera:lower()
    
        if camera:find('other')          then return 'camOther'
    elseif camera:find('hud')            then return 'camHUD' 
    elseif helper.variableExists(_camera) then return _camera
    else   return 'camGame'
    end
end

function helper.getType(result, structOverDict)
    return type(result) == 'table' and (helper.isDict(result) and (structOverDict and 'dictionary' or 'struct') or 'table') or type(result)
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
                arr = arr .. helper.serialize(v, helper.getType(v, true)) .. (i == #value and '' or ', ')
            end

            return arr ..']'
        end
    elseif t == 'map' or t == 'dictionary' or t == 'dict' then
        if type(value) == 'table' then
            local map = '['
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                map = map .. helper.serialize(k, type(k)) .. ' => ' .. helper.serialize(v, helper.getType(v, true)) .. (i == helper.getDictLength(value) and '' or ', ')
            end
            return map ..']'
        end
    elseif t == 'struct' or t == 'structure' or t == 'anonstruct' then
        if type(value) == 'table' then
            local struct = '{'
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                struct = struct .. k .. ': ' .. helper.serialize(v, helper.getType(v, true)) .. (i == helper.getDictLength(value) and '' or ', ')
            end
            return struct ..'}'
        end
    elseif t == 'bool' or t == 'boolean' then
        if type(value) == 'boolean' then
            return tostring(value)
        end
    elseif t == 'function' then
        if type(value) == 'function' then
            return '() -> {}'
        end
    end
    return value
end

function helper.addHaxeLibrary(library, package)
    luaDeprecatedWarnings = false
    addHaxeLibrary(library, package)
    luaDeprecatedWarnings = true
end

function helper.hgetKeys(map)
    helper.init()
    return runHaxeCode('return Lambda.array({ iterator: '.. helper.parseObject(map) ..'.keys });') or { }
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

function helper.isDict(tbl)
    if type(tbl) ~= 'table' then return false end

    for k, _ in pairs(tbl) do
        if type(k) ~= 'number' or k % 1 ~= 0 or k < 1 then
            return true
        end
    end
    return false
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
    return nil
end

function helper.existsFromTable(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

function helper.keyExists(tbl, key)
    if type(tbl) == 'table' then
        for k in pairs(tbl) do
            if k == key then return true end
        end
    end
    return false
end

-- from Stack Overflow:
-- https://stackoverflow.com/a/20100401
function helper.stringSplit(str, del)
    if not stringSplit then
        result = {}
        for match in (str..del):gmatch("([^".. del .."]+)") do
            table.insert(result, match)
        end
        return result
    else return stringSplit(str, del) end
end

function helper.ternary(statement, a, b)
    if statement then 
        return a
    else
        return b
    end
end

function helper.bound(c, a, b)
    return math.max(a, math.min(b, c))
end

function helper.rawsetDict(t, path, value)
    local cur = t
    local split = helper.stringSplit(path, '.')

    for i = 1, #split - 1 do
        local k = split[i]
        local next = rawget(cur, k)

        if type(next) ~= "table" then
            next = {}
            rawset(cur, k, next)
        end

        cur = next
    end

    rawset(cur, split[#split], value)
end

function helper.rawgetDict(t, path)
    local cur = t
    local split = helper.stringSplit(path, '.')

    for i, k in ipairs(split) do
        if type(cur) ~= "table" then
            return nil
        end

        cur = rawget(cur, k)
        if cur == nil then
            return nil
        end
    end

    return cur
end

function helper.getDictLength(dict)
    local len = 0
    if type(dict) == 'table' then
        for _ in pairs(dict) do 
            len = len + 1 
        end
    end

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

function helper.resolveNilInTable(tbl, fallbackValue)
    for i, v in ipairs(tbl) do
        if type(v) == nil then 
            tbl[i] = fallbackValue 
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

function helper.arrayComprehension(from, to, fn)
    local tbl = {}
    for i = from, to do
        tbl[i] = fn(i)
    end
    return tbl
end

function helper.mapComprehension(keys, fn)
    local tbl = {}
    for i, key in ipairs(keys) do
        tbl[key] = fn(key)
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

function helper.concatDict(d1, d2, override)
    override = helper.resolveDefaultValue(override, true)
    for k, v in pairs(d2) do
        if d1[k] ~= nil and not override then
            return
        end
        d1[k] = v
    end
    return d1
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
    or helper.callMethodFromClass('Reflect', 'hasField', {(version < '0.7' and 'PlayState' or 'states.PlayState').. '.instance', obj })
end

function helper.variableExists(var)
    return helper.callMethod('variables.exists', {var})
end

function helper.luaObjectExists(obj)
    return runHaxeCode(('return game.getLuaObject("%s"'.. (version > '0.7' and ', true' or '') ..') != null;'):format(obj))
end

return helper