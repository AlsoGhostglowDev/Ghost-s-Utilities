---@meta table

---@class tablelib
local tbl = setmetatable({}, {
    __index = table,
})

local d = require "ghostutil.Debug"

---Finds the pos of a certain value in a table. If fails, returns -1
---@param self table
---@param val any Value to find 
---@return integer
function tbl.indexOf(self, val)
    if type(self) ~= "table" then
        d.error("table.indexOf:1: Expected table, got ".. type(self) .." instead.")
        return -1
    end

    local i = 1
    for _, v in pairs(self) do
        if v == val then return i end
        i = i + 1
    end

    d.error("table.indexOf: Couldn't find the pos from table's values!")
    return -1
end

---Checks if certain value in the table exists. If fails, returns false
---@param self table 
---@param val any Value to check
---@return boolean
function tbl.exists(self, val)
    if type(self) ~= "table" then
        d.error("table.findpos:1: Expected table, got ".. type(self) .." instead.")
        return false
    end

    for i = 1, #self do
        if self[i] == val then return true end
    end

    return false
end

---Concatenates tables
---@vararg table Tables to concatenate
function tbl.concat(...)
    local ret, arg = {}, table.pack(...)
    for _, t in ipairs(arg) do for _, v in ipairs(t) do
            table.insert(ret, v)  
    end end
    return ret
end

return tbl