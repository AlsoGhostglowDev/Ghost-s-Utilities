local shader = {}

local debug = require 'ghostutil.debug'
local helper = require 'ghostutil.backend.helper'
local bcompat = require 'ghostutil.backwards-compat'

shader.filters = {}

local function getFiltersField()
    return version >= '0.7.2' and '.filters' or '._filters'
end

shader.initialized = false
function shader.init()
    if not shader.initialized then
        runHaxeCode([[
            var resetCamCache = function(?spr) {
                if (spr == null || spr.filters == null) return;
                spr.__cacheBitmap = null;
                spr.__cacheBitmapData = null;
            }
            
            var fixShaderCoord = function() {
                resetCamCache(game.camGame.flashSprite);
                resetCamCache(game.camHUD.flashSprite);
                resetCamCache(game.camOther.flashSprite);
            }

            FlxG.signals.gameResized.add(fixShaderCoord);
        ]])
        shader.initialized = true
    end
end

function shader.fixShaderCoord()
    shader.init()
end

function shader.addCameraFilter(camera, filter, floats, tag)
    camera = helper.getCameraFromString(camera)
    tag = tag or filter

    local filtersField = getFiltersField()
    if getProperty(camera .. filtersField) == nil then
        helper.setProperty(camera .. filtersField, {''})
        helper.callMethod(camera .. filtersField ..'.remove', {''})
    end
    
    makeLuaSprite(tag)
    setSpriteShader(tag, filter)
    helper.createInstance(tag ..'_filter', 'openfl.filters.ShaderFilter', {helper.instanceArg(tag ..'.shader')})
    helper.callMethod(camera .. filtersField ..'.push', { helper.instanceArg(tag ..'_filter') })

    for uniform, value in pairs(floats) do
        local setShaderFn = type(value) == 'table' and setShaderFloatArray or setShaderFloat
        setShaderFn(tag, uniform, value)
    end

    shader.filters[tag] = filter
end

function shader.removeCameraFilter(camera, filter, tag, destroy)
    camera = helper.getCameraFromString(camera)
    tag = tag or filter
    if helper.keyExists(shader.filters, tag) then
        helper.callMethod(camera .. getFiltersField() ..'.remove', { helper.instanceArg(tag ..'_filter') })
        shader.filters[tag] = nil
        
        if helper.resolveDefaultValue(destroy, true) then
            removeLuaSprite(tag)
            helper.callMethod('variables.remove', {tag ..'_filter'})
        end

        return
    end
    debug.error('unrecog_el', {tag .. '('.. filter ..')', 'shader.filters, \nHave you tried adding the filter from shader.addCameraFilter?'}, 'shader.removeCameraFilter:2/3')
end

function shader.clearCameraFilters(camera)
    camera = helper.getCameraFromString(camera)
    helper.setProperty(camera .. getFiltersField(), {''})
    helper.callMethod(camera .. getFiltersField() ..'.remove', {''})

    for tag, filter in pairs(shader.filters) do
        removeLuaSprite(tag)
        helper.callMethod('variables.remove', {tag ..'_filter'})
        shader.filters[tag] = nil
    end
end

function shader.tweenShaderFloat(tag, float, to, duration, options)
    if helper.objectExists(tag) then
        local _options = bcompat.__buildOptions(tag, nil, options)
        runHaxeCode(([[
            var object = %s;
            var shader = object.shader;
            var float = %s;
            setVar("%s", FlxTween.num(shader.getFloat(float), %s, %s, %s, n -> shader.setFloat(float, n)));
        ]]):format(helper.parseObject(tag), helper.serialize(float, 'string'), 'tween_'..tag, tostring(to), tostring(duration), _options))
        return
    end
    debug.error('unrecog_el', {tag, 'game'}, 'shader.tweenShaderFloat:1')
end

function shader.clearRuntimeShader(shaderName)
    local fn = shaderName ~= nil and 'runtimeShaders.remove' or 'runtimeShaders.clear'
    if version >= '0.7' then
        if getPropertyFromClass('psychlua.FunkinLua', 'runtimeShaders') ~= nil then
            helper.callMethodFromClass('psychlua.FunkinLua', fn, {shaderName})
        end
    else
        if getProperty('runtimeShaders') ~= nil then
            helper.callMethod(fn, {shaderName})
        end
    end
end

return shader