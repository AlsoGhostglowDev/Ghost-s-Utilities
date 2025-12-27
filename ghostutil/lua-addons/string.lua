local helper = require 'ghostutil.backend.helper'
local debug = require 'ghostutil.debug'

--[=[
    ##########################
        LUA ADDON - STRING
    ##########################
]=]

function string.split(s, delimiter)
    return helper.stringSplit(s, delimiter or '')
end

function string.shuffle(s)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.shuffle')
        return s
    end

    local letters = {}
    for letter in s:gmatch'.[\128-\191]*' do
       table.insert(letters, {letter = letter, rnd = math.random()})
    end
    table.sort(letters, function(a, b) return a.rnd < b.rnd end)
    for i, v in ipairs(letters) do letters[i] = v.letter end
    return table.concat(letters)
end

function string.ltrim(s)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.ltrim')
        return s
    end

    return (s:gsub('^%s*(.-)', '%1'))
end

function string.rtrim(s)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.ltrim')
        return s
    end

    return (s:gsub('(.-)%s*$', '%1'))
end

function string.trim(s)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.trim')
        return s
    end

    return string.ltrim(string.rtrim(s))
end

function string.startswith(s, startsWith)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.startswith')
        return false
    end

    if #startsWith > #s then
        return false
    end

    return s:sub(1, #startsWith) == startsWith
end

function string.endswith(s, endsWith)
    if type(s) ~= 'string' then
        debug.error('wrong_type', {'string', type(s)}, 'string.endswith')
        return false
    end

    if #endsWith > #s then
        return false
    end

    return s:sub(#s - #endsWith) == endsWith
end

function string.contains(s, pattern)
    return s:find(pattern) ~= nil
end

function string.replace(s, pattern, to)
    return s:gsub(pattern, to)
end

return string