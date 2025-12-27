local outdate = {}

local helper = require 'ghostutil.backend.helper'
local debug = require 'ghostutil.debug'
local file = require 'ghostutil.file'

outdate.classes = {}
local packages = { 
    'backend', 'cutscenes', 'debug',
    'flixel.addons.ui', 'objects', 'psychlua',
    'shaders', 'states.editors', 'states.stages.objects',
    'states', 'substates', 'unused' 
}

for i, package in ipairs(packages) do
    local classes = helper.stringSplit(file.read('ghostutil/outdate/classes/'.. package ..'.txt'), '\n')
    for i, class in ipairs(classes) do
        local actualClass = helper.stringSplit(class, '::')[1]
        outdate.classes[actualClass] = {package, class}
    end
end

function outdate.resolveClass(class, legacy, psychExclusive, avoidWarn)
    legacy = helper.resolveDefaultValue(legacy, version < '0.7')
    psychExclusive = helper.resolveDefaultValue(psychExclusive, true)
    avoidWarn = helper.resolveDefaultValue(avoidWarn, true)

    local splClass = helper.stringSplit(class, '.')
    local classToResolve = splClass[#splClass]
    local package = table.concat(helper.resizeTable(splClass, #splClass-1), '.') -- unused
    if helper.eqAny(classToResolve, {'Main', 'import'}) then return class else
        if helper.keyExists(outdate.classes, classToResolve) then
            local info = outdate.classes[classToResolve]
            local package, class = info[1], info[2]
            local leClass = helper.stringSplit(class, '::')
            return legacy and (leClass[2] or leClass[1]) or (package ..'.'.. leClass[1]) 
        end
        if psychExclusive then
            debug.error('unrecog_el', {class, 'outdate.classes,\nare you sure it\'s a class from Psych Engine?'}, 'outdate.resolveClass:1')
            return nil
        end
        if luaDebugMode and not avoidWarn then
            debug.warn('unrecog_el', {class, 'outdate.classes,\nReturning "'.. class ..'" back, this could be because it\'s not from Psych Engine'})
        end
        return class
    end
end

function outdate.addHaxeLibrary(libName, pkg, legacy, shouldWarn)
    helper.resolveDefaultValue(legacy, version < '0.7')
    helper.resolveDefaultValue(shouldWarn, false)
    pkg = (pkg == nil) and '' or pkg .. '.'
    local splClass = helper.stringSplit(outdate.resolveClass(pkg .. libName, legacy, false, not shouldWarn), '.')
    local class = splClass[#splClass]
    local package = table.concat(helper.resizeTable(splClass, #splClass-1), '.')

    debugPrint('added library: Class: '.. class .. ' | Package: '.. package)
    helper.addHaxeLibrary(class, package)
end

function outdate.setPropertyFromClass(class, prop, value, allowMaps, allowInstances, legacy)
    helper.resolveDefaultValue(legacy, version < '0.7')
    helper.setPropertyFromClass(outdate.resolveClass(class, legacy, false, true), prop, value, allowMaps, allowInstances)
end

function outdate.getPropertyFromClass(class, prop, allowMaps, legacy)
    helper.resolveDefaultValue(legacy, version < '0.7')
    helper.getPropertyFromClass(outdate.resolveClass(class, legacy, false, true), prop, allowMaps)
end

return outdate