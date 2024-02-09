---@meta OutdateHandler
---@author GhostglowDev, galactic_2005, Laztrix

---Thanks to galactic_2005 for letting me use his idea from PEModUtils
---@class apicompatible
local outdate = {}

local f = require "ghostutil.File"
local d = require "ghostutil.Debug"

-- thanks to laztrix for optimizing these.. there were literally like a hundred f.getFileContent i swear
-- - ghost
local classFiles = {
    "backend", "cutscenes", "debug", "flixel.addons.ui", "objects",
    "psychlua", "states.editors", "states.stages.objects", "states",
    "shaders", "substates", "unused"
}

outdate.classes = {}

for _, className in ipairs(classFiles) do
    local path = string.format("ghostutil/outdate/classes/%s.txt", className)
    outdate.classes[className] = f.getFileContent(path, "./")
end

---Returns the class (with the packages) based on said version 
---@param zeroSeven boolean Above 0.7.0? 
---@param class string The class. The package shouldn't be added
---@param doErr boolean Should it print an error on fail?
---@return string
function outdate.classBasedOnVersion(zeroSeven, class, doErr)
    if zeroSeven == nil then if doErr then d.error("outdate.classBasedOnVersion: ZeroSeven is nil") end return "fail" end
    if class == nil then if doErr then d.error("outdate.classBasedOnVersion: Class is nil") end return "fail" end
    if doErr == nil then doErr = true end

    if class == "Main" or class == "import" then return class else
        for k, v in pairs(outdate.classes) do
            v = stringSplit(v, "\n")
            for p = 1, #v do
                if class == (string.find(v[p], "-") and stringSplit(v[p], "-")[1] or v[p]) then
                    return (zeroSeven and 
                        k .. "." .. (string.find(v[p], "-") and stringSplit(v[p], "-")[1] or v[p]) or 
                        (string.find(v[p], "-") and stringSplit(v[p], "-")[2] or v[p])
                    )
                end
            end
        end
    end

    if doErr then
        d.error("outdate.returnBasedOnVersion: Failed to return class '"..class.."' based on version!")
    end
    return "fail"
end

---`addHaxeLibrary` that adds the library based on the current version (Psych Engine's libraries only)
---@param libName string The library name (without the package)
function outdate.addHaxeLibrary(libName)
    if libName == "" and libName == nil then
        d.error("outdate:addHaxeLibrary:1: The argument 'libName' is " .. (libName == "" and "empty" or "nil") .. "!")
        return
    end

    local actualLib = outdate.classBasedOnVersion(version >= "0.7.0", libName, false)
    local funkinClass = (actualLib ~= "fail")
    if funkinClass then 
        local libs = stringSplit(actualLib, ".")
        local class = (#libs >= 1 and libs[#libs] or actualLib)
        local package = ""
        if #libs >= 1 then
            table.remove(libs, (#libs))
            if #libs >= 2 then
                for i = 1, #libs do
                    package = package .. libs[i] .. (i == #libs and "" or ".")
                end
            elseif #libs == 1 then
                package = libs[1]
            end
        end

        addHaxeLibrary(class, package)
        return
    end
    d.error("outdate:addHaxeLibrary:1: The library is not from Psych Engine source code!")
end

---Fetches a variable from a class
---@param classVar string
---@param variable string
---@param allowMaps boolean
---@return any
---@nodiscard
function outdate.getPropertyFromClass(classVar, variable, allowMaps)
    return getPropertyFromClass(outdate.classBasedOnVersion(version >= "0.7.0", classVar), variable, allowMaps or false)
end

---Sets a the variable's value from a class
---@param classVar string
---@param variable string
---@param value any
---@param allowMaps boolean
function outdate.setPropertyFromClass(classVar, variable, value, allowMaps)
    setPropertyFromClass(outdate.classBasedOnVersion(version >= "0.7.0", classVar), variable, value, allowMaps or false)
end

return outdate