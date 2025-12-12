local reflect = {}

reflect.dev = false -- set to true for fuckton of informational debugPrints
reflect.name = 'reflect' -- for GhostUtil 
reflect.version = '1.1.0-GUSE'
local _instancePre = '##REFLECT_STRINGTOOBJ'
local _importedClasses = {}
local _refreshedOnce = false

--[[
    ########################
            INTERNAL        
    ########################
]]--

local function _getDictLength(dict)
    local len = 0
    for _ in pairs(dict) do len = len + 1 end

    return len
end

local function _serialize(value, t)
    if t == 'string' then
        if type(value) == 'string' then
            return ("'%s'"):format(value:gsub('\'', '\\\''))
        end  
    elseif t == 'array' or t == 'table' then
        if type(value) == 'table' then
            local arr = '['
            for i, v in ipairs(value) do
                arr = arr .. _serialize(v, type(v)) .. (i == #value and '' or ', ')
            end

            return arr ..']'
        end
    elseif t == 'map' or t == 'dictionary' or t == 'dict' then
        if type(value) == 'table' then
            local map = '['
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                map = map .. _serialize(k, type(k)) .. ' => ' .. _serialize(v, type(v)) .. (i == _getDictLength(value) and '' or ', ')
            end
            return map ..']'
        end
    elseif t == 'struct' or t == 'structure' or t == 'anonstruct' then
        if type(value) == 'table' then
            local struct = '{'
            local i = 0
            for k, v in pairs(value) do
                i = i + 1
                struct = struct .. k .. ': ' .. _serialize(v, type(v)) .. (i == _getDictLength(value) and '' or ', ')
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

local function _refreshImports()
    if version < '0.7' then
        if not _refreshedOnce then
            addHaxeLibrary('Type') ; addHaxeLibrary('Class') ; addHaxeLibrary('FunkinLua')
        end
        _importedClasses = runHaxeCode([[
            var imports = [];
            var interp = FunkinLua.hscript.interp;
            for (key in interp.variables.keys()) {
                switch (Type.typeof(interp.variables[key])) {
                    case Type.resolveEnum('ValueType').TClass():
                        imports.push(key);
                        game.addTextToDebug(key, -1);        
                }
            }
            return imports;
        ]])

        _refreshedOnce = true
    end
end

local function _getSepClass(class) 
    local sep = stringSplit(class, '.')
    local actualClass, package = sep[#sep], ''
    if #sep > 1 then
        for i = 1, #sep-1 do
            package = package.. (i == 1 and '' or '.') ..sep[i]
        end
    end

    --if _dev then debugPrint('_getSepClass: Seperated Class: '.. actualClass ..' | Package: '.. package) end
    return {class = actualClass, package = package}
end

local function _isImported(class) 
    --_refreshImports()
    for _, iClass in ipairs(_importedClasses) do
        if iClass == _getSepClass(class).class then return true end
    end
    return false
end

local function _addLib(class) 
    if not _isImported(class) then
        local sep = _getSepClass(class)
        table.insert(_importedClasses, sep.class)
        addHaxeLibrary(sep.class, sep.package)

        if reflect.dev then debugPrint('_addLib: addHaxeLibrary("'.. sep.class ..'", "'.. sep.package ..'") : '.. class) end
    end
    --_refreshImports()
end

local function _classExists(class)
    _addLib(class)
    return runHaxeCode('return '.. _getSepClass(class).class ..' != null;')
end

local function _indexOf(str, of, iteration)
    return select(iteration or 1, str:find(of))
end

local function _parseSingleInstance(arg)
    if tostring(arg):find(_instancePre) ~= nil then
        local ret = 'null'
        local _instance = arg:sub(arg:find('::') + 2)
        local class = 'PlayState'
        if (_instance:find('::')) then
            class = _instance:sub(_instance:find('::')+2)
            _instance = _instance:sub(1, _instance:find('::')-1)
        end
        local instanceSplit = stringSplit(_instance, '.')
        local instance = instanceSplit[1]
        local classSplit = stringSplit((#class < 1 and 'PlayState' or class), '.')
        if reflect.dev then debugPrint('_parseSingleInstance: "'.. instance ..'" .. from Class: '.. class) end

        local className = classSplit[#classSplit]
        
        if reflect.dev then
            debugPrint('_parseSingleInstance: Instance Name: '.. instance)
            debugPrint('_parseSingleInstance: Class (Split): '.. _serialize(classSplit, 'array'))
        end

        if not _isImported(className) then
            _addLib(class)
        end

        if className == 'PlayState' then
            local checks = {
                {'game.%s', true},
                {'PlayState.%s', true},
                {'game.getLuaObject("%s"'.. (version > '0.7' and '' or ', true') ..')', true},
                {'game.variables.exists("%s")', false, 'getVar("%s")'}
            }

            for _, check in ipairs(checks) do
                --[=[
                    debugPrint('['.. _ ..'] CHECK: '.. check[1])
                    debugPrint('CODE: return '.. check[1]:format(instance) ..(check[2] and ' != null;' or ';'))
                    debugPrint('RESULT: '.. tostring(runHaxeCode('return '.. check[1]:format(instance) ..(check[2] and ' != null;' or ';'))))
                    debugPrint('-----------------------')
                ]=]

                if runHaxeCode('return '.. check[1]:format(instance) ..(check[2] and ' != null;' or ';')) then
                    ret = check[3] or check[1]
                    break
                end
            end
        else
            if runHaxeCode('return '.. className ..'.'.. instance ..' != null;') then
                ret = className ..'.%s'
            end

            -- instance exception
            if runHaxeCode('return '.. className ..'.instance != null;') then
                if runHaxeCode('return '.. className ..'.instance.'.. instance ..' != null;') then
                    ret = className ..'.instance.%s'
                end
            end
        end

        local trailingProps = ''
        if #instanceSplit > 1 then
            trailingProps = '.'
            for i = 2, #instanceSplit do
                trailingProps = trailingProps .. instanceSplit[i] .. (i == #instanceSplit and '' or '.')
            end
        end

        if reflect.dev then debugPrint('_parseSingleInstance: ('.. tostring(arg) ..') -> Returns: '.. ret:format(instance) .. trailingProps) end
        return ret:format(instance) .. trailingProps
    end
    return arg
end

local function _parseInstances(args, serializeNonInstance, argsType)
    local ret = {}
    for i, arg in ipairs(args) do
        if type(arg) == 'table' then
            ret[i] = _parseInstances(arg, serializeNonInstance)

            local _temp = #ret[i] > 0 and '[' or '[]'
            for j, v in ipairs(ret[i]) do
                _temp = _temp .. v .. (j == #ret[i] and ']' or ', ')
            end

            ret[i] = _temp
        else
            if tostring(arg):find(_instancePre) then
                if type(arg) == 'string' then
                    ret[i] = _parseSingleInstance(arg)
                end
            else
                if serializeNonInstance then
                    ret[i] = _serialize(arg, (argsType or {})[i] or type(arg))
                end
            end
        end
    end

    return ret
end

--[[
    ####################################
            BASE FUNCTIONS (RAW)        
    ####################################
]]--

local function _baseCallMethod(class, method, args, callInstanceMethod)
    args = args or {}
    _addLib(class)

    local methodSplit = stringSplit(method, '.')
    local instance, fromInstance = '', false
    if (#methodSplit > 1) then
        instance = _parseSingleInstance(reflect.instanceArg(methodSplit[1], class, true))
        fromInstance = true

        method = ''
        for i = 2, #methodSplit do
            method = method .. methodSplit[i] .. (i == #methodSplit and '' or '.')
        end
    end

    local parsedArgs, stringArgs = _parseInstances(args, true), ''
    for i, arg in ipairs(parsedArgs) do
        stringArgs = stringArgs .. arg ..(i == #args and '' or ', ')
    end

    if (fromInstance and instance ~= 'null') or not fromInstance then
        return runHaxeCode([[
            var method = ]].. (fromInstance and instance..'.' or (_getSepClass(class).class..(callInstanceMethod and '.instance.' or '.'))) .. method ..[[;
            if (method != null)
                return method(]].. stringArgs ..[[);
            game.addTextToDebug('callMethod: "]].. (fromInstance and methodSplit[1] or _getSepClass(class).class) ..[[" does not have method ]].. method ..[[', 0xFFFF0000);
            return null;
        ]])
    end
    reflect.callMethod('addTextToDebug', {'callMethod: Instance named "'.. methodSplit[1] ..'" doesn\'t exist!' , 0xFF0000})
end

local function _baseSetProperty(prop, value, allowMaps, allowInstances, className)
    if type(value) == 'table' then
        value = (allowInstances and _parseInstances or _serialize)(value, (allowInstances and true or 'table'))
        if allowInstances then
            local _temp = '['
            for j, v in ipairs(value) do
                _temp = _temp .. v .. (j == #value and ']' or ', ')
            end

            value = _temp
        end
    else
        if allowInstances then 
            value = _parseSingleInstance(value)
        else
            value = _serialize(value, type(value))
        end
    end
    local instance, instanceProp = '', ''
    local instanceSplit = stringSplit(prop, '.')
    if #instanceSplit >= 2 then
        for i = 2, #instanceSplit do
            instanceProp = instanceProp .. instanceSplit[i] .. (i == #instanceSplit and '' or '.')
        end
    end
    instance = _parseSingleInstance(reflect.instanceArg(instanceSplit[1], className, true))
    prop = _parseSingleInstance(reflect.instanceArg(prop, className, true))

    if reflect.dev then 
        debugPrint('_baseSetProperty: [prop: '.. prop .. ' | value: '.. value ..']') 
        debugPrint('_baseSetProperty: allowMaps: '.. tostring(allowMaps) .. ', allowInstances: '.. tostring(allowInstances))
    end

    local code = ((allowMaps and '%s.set("%s", %s);' or '%s = %s;').. ' return;')
    runHaxeCode(code:format(
        (allowMaps and instance or prop), (allowMaps and instanceProp or value), (allowMaps and value or '')
    ))
end

--[[
    ################################
            REFLECT FUNCTIONS              
    ################################
]]--

function reflect.instanceArg(instance, class, forceReflectInstanceArg) 
    class = class or 'PlayState'

    if version >= '0.7.2h' and not forceReflectInstanceArg then
        return instanceArg(instance, class)
    else
        local arg = _instancePre.. '::'.. instance ..(class ~= 'PlayState' and '::'..class or '')
        return arg
    end
end

function reflect.callMethod(method, args, forceReflectCallMethod) 
    if version < '0.7.2h' or forceReflectCallMethod then
        return _baseCallMethod('PlayState', method, args, true)
    else
        return callMethod(method, args)
    end
end

function reflect.callMethodFromClass(class, method, args, forceReflectCallMethod) 
    if version < '0.7.2h' or forceReflectCallMethod then
        return _baseCallMethod(class, method, args, false) 
    else
        return callMethodFromClass(class, method, args)
    end
end

function reflect.createInstance(tag, className, args)
    if version < '1.0' then -- createInstance was added in 0.7 but instanceArg support was only when 1.0 was released
        if (tag ~= nil and #tag > 0) and (tag ~= nil and #className > 0) then
            local classSplit = _getSepClass(className)
            args = _parseInstances(args or {}, true)
            _addLib(className)

            local stringArgs = ''
            for i, arg in ipairs(args) do
                stringArgs = stringArgs .. arg ..(i == #args and '' or ', ')
            end

            if _classExists(className) then
                return runHaxeCode([[ 
                    var newInstance = new ]].. classSplit.class ..[[(]].. stringArgs ..[[); 
                    if (game.variables.exists(']].. tag ..[['))
                        game.addTextToDebug("createInstance: Cannot override existing instance: ']].. tag ..[['!", 0xFFFF0000);
                    else
                        setVar(']].. tag ..[[', newInstance);
                    return newInstance;
                ]])
            end
            debugPrint('createInstance: Class "'.. className ..'" doesn\'t exist!')
        end

        debugPrint('createInstance: tag / className is nil / empty!')
        return 
    else
        return createInstance(tag, className, args)
    end
end

function reflect.addInstance(instance, front)
    local addFunc = (front and 'game.add' or 'game.addBehindGF')
    runHaxeCode([[
        if (game.variables.exists(']].. instance ..[['))
            ]].. addFunc ..[[(getVar(']].. instance ..[['));
        else
            game.addTextToDebug('addInstance: Cannot add an instance ("]].. instance ..[[") that doesn\'t exist! :3', 0xFFFF0000);
    ]])
end

function reflect.setProperty(prop, value, allowMaps, allowInstances, forceReflectFn)
    if version > '1.0' and not forceReflectFn then
        setProperty(prop, value, allowMaps, allowInstances)
    else
        _baseSetProperty(prop, value, allowMaps, allowInstances)
    end
end

function reflect.setPropertyFromClass(class, prop, value, allowMaps, allowInstances) 
    if version > '1.0' and not forceReflectFn then
        setPropertyFromClass(class, prop, value, allowMaps, allowInstances)
    else
        _addLib(class)
        _baseSetProperty(prop, value, allowMaps, allowInstances, class) 
    end
end
function reflect.setPropertyFromGroup(group, index, prop, value, allowMaps, allowInstances) 
    if version > '1.0' and not forceReflectFn then
        setPropertyFromGroup(group, index, prop, value, allowMaps, allowInstances)
    else
        _addLib('Array') ; _addLib('Std')

        local _prop = (runHaxeCode('return Std.isOfType('.._parseSingleInstance(reflect.instanceArg(group, nil, true))..', Array);')) and '%s[%s]' or '%s.members[%s]'
        _baseSetProperty(_prop:format(group, index) ..'.'.. prop, value, allowMaps, allowInstances)
    end
end

return reflect