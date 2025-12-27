local helper = require 'ghostutil.backend.helper'

table.isdictionary = helper.isDict
table.isdict = table.isdictionary
table.getkeys = helper.getKeys
table.keys = table.getkeys
table.indexof = helper.findIndex
table.keyof = helper.findKey
table.contains = helper.existsFromTable
table.exists = table.contains
table.has = table.contains
table.hasvalue = table.contains
table.containskey = helper.keyExists
table.keyexists = table.containskey
table.haskey = table.containskey
table.rawsetdict = helper.rawsetDict
table.rawgetdict = helper.rawgetDict
table.getdictlength = helper.getDictLength
table.getdictlen = table.getdictlength
table.fill = helper.fillTable
table.resize = helper.resizeTable
table.arraycomp = helper.arrayComprehension
table.dictcomp = helper.mapComprehension
table.merge = helper.concat
table.mergedict = helper.concatDict

function table.filter(t, filter)
    local ret = {}
    for k, v in pairs(t) do 
        if filter(k, v) then 
            ret[k] = v
        end
    end
    return ret
end

function table.pop(t)
    if #t > 0 then
        local lastEl = t[#t]
        table.remove(t, #t)
        return lastEl
    end
    return nil
end

function table.shift(t)
    if #t > 0 then
        local firstEl = t[1]
        table.remove(t, 1)
        return firstEl
    end
    return nil
end

function table.reverse(t)
    for i = 1, math.floor(#t) do
        t[i], t[n - i + 1] = t[n - i + 1], t[i]
    end
    return t
end

function table.clone(t)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = type(v) == 'table' and table.clone(v) or v
    end
    return ret
end
table.copy = table.clone

return table