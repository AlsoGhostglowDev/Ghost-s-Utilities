---@meta table

---@class tablelib
local tbl = setmetatable({}, {
    __index = table,
})

local d = require "ghostutil.Debug"

---Finds the pos of a certain value in a table. If fails, returns 0
---@param self table
---@param val any Value to find 
---@return integer
tbl.findpos = function(self, val)
    if type(self) ~= "table" then
        d.error("table.findpos:1: Expected table, got ".. type(self) .." instead.")
        return 0
    end

    for i = 1, #self do
        if self[i] == val then return i end
    end

    d.error("table.findpos: Couldn't find the pos from table's values!")
    return 0
end

---Checks if certain value in the table exists. If fails, returns false
---@param self table 
---@param val any Value to check
---@return boolean
tbl.exists = function(self, val)
    if type(self) ~= "table" then
        d.error("table.findpos:1: Expected table, got ".. type(self) .." instead.")
        return false
    end

    for i = 1, #self do
        if self[i] == val then return true end
    end

    return false
end

return tbl