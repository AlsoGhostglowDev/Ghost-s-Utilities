---@meta string
---@author GhostglowDev, Laztrix, galactic_2005

---@class stringlib
local str = setmetatable({}, {
    _index = string,
})

local d = require "ghostutil.Debug"

---Splits the string with the `delimeter` to a table of strings. If fails, returns an empty table
---@param self string Value
---@param delimeter string The string that splits the string
---@return table<string>
---@author Laztrix
str.split = function(self, delimeter)
    if self ~= nil then
        local tbl = {}
        for s in string.gmatch(self, '[^'.. delimeter ..']+') do
            tbl[#tbl+1] = s
        end
        return tbl
    end
    return {}
end

---Shuffles the given string. If fails, returns the original string
---@param self string 
---@return string
str.shuffle = function(self)
    if type(self) ~= "string" then
        d.error("string.shuffle: Expected string, got ".. type(self) .." instead.")
        return self
    end

    local letters = {}
    for letter in self:gmatch'.[\128-\191]*' do
       table.insert(letters, {letter = letter, rnd = math.random()})
    end
    table.sort(letters, function(a, b) return a.rnd < b.rnd end)
    for i, v in ipairs(letters) do letters[i] = v.letter end
    return table.concat(letters)
end

---Removes the spaces from the left ends. If fails, returns the original string
---@param self string
---@return string
---@author galactic_2005
---@nodiscard
str.ltrim = function(self)
    if type(self) ~= "string" then
        d.error("string.ltrim: Expected string, got ".. type(self) .." instead.")
        return self
    end

    return (self:gsub("^%s*(.-)", "%1"))
end

---Removes the spaces from the right ends. If fails, returns the original string
---@param self string
---@return string
---@author galactic_2005
---@nodiscard
str.rtrim = function(self)
    if type(self) ~= "string" then
        d.error("string.rtrim: Expected string, got ".. type(self) .." instead.")
        return self
    end

    return (self:gsub("(.-)%s*$", "%1"))
end

---Removes the spaces from both ends. If fails, returns the original string
---@param self string
---@return string
---@author galactic_2005
---@nodiscard
str.trim = function(self)
    if type(self) ~= "string" then
        d.error("string.trim: Expected string, got ".. type(self) .." instead.")
        return self
    end

    return (self:gsub("^%s*(.-)%s*$", "%1"))
end

---Checks if the given string starts with `startsWith`, If fails returns false
---@param self string Value
---@param startsWith string The string to check it starts with
---@return boolean|nil
str.startswith = function(self, startsWith)
    if type(self) ~= "string" then
        d.error("string.startswith: Expected string, got ".. type(self) .." instead.")
        return false
    end

    return self:sub(1, #startsWith) == startsWith
end

---Checks if the given string ends with `endsWith`, If fails returns false
---@param self string Value
---@param endsWith string The string to check it ends with
---@return boolean|nil
str.endswith = function(self, endsWith)
    if type(self) ~= "string" then
        d.error("string.endswith: Expected string, got ".. type(self) .." instead.")
        return false
    end

    return self:sub(#self - #endsWith) == endsWith
end

return str