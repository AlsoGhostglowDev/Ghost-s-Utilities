---@meta outdate-handler
---@author GhostglowDev, galactic_2005, Laztrix

---Thanks to galactic_2005 for letting me use his idea from PEModUtils
---@class apicompatible
local outdate = {}

local f = require "ghostutil.file"
local d = require "ghostutil.debug"

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
function outdate.classBasedOnVersion(zeroSeven, className, doErr)
    if doErr == nil then doErr = true end
    if zeroSeven == nil or zeroSeven == "" then if doErr then d.error("outdate.classBasedOnVersion: ZeroSeven is ".. (zeroSeven == nil and "nil" or "empty")) end return "fail" end
    if className == nil or className == "" then if doErr then d.error("outdate.classBasedOnVersion: Class is ".. (className == nil and "nil" or "empty")) end return "fail" end

    local debugMode = false
    if debugMode then 
        debugPrint([[
            outdate.classBasedOnVersion, Arguments:
            [
                zeroSeven:Bool = ]].. tostring(zeroSeven) ..[[,
                className:String = ']].. className ..[[',
                ?doErr:Bool = ]].. tostring(doErr) ..[[

            ]
        ]]) 
    end

    if className == "Main" or className == "import" then return className else
        for lib, classes in pairs(outdate.classes) do
            classes = stringSplit(classes, "\n") -- making it an actual table
            for _, class in ipairs(classes) do -- iterates over all of the classes
                if className == (string.find(class, "-") and stringSplit(class, "-")[1] or class) then -- checks if the current class is the target class
                    if debugMode then 
                        debugPrint("CLASS FOUND!: ".. class ..", FROM LIBRARY: ".. lib .." ... FINDING CLASS BASED ON VERSION ".. (zeroSeven and "0.7" or "BELOW 0.7") .."...")
                        debugPrint("RESULT FOR CLASS FOR VERSION ".. (zeroSeven and "0.7" or "BELOW 0.7") .. ": " ..
                        (zeroSeven and 
                            lib .. "." .. (string.find(class, "-") and stringSplit(class, "-")[1] or class) -- for 0.7.x
                        or 
                            (string.find(class, "-") and stringSplit(class, "-")[2] or class) -- for below 0.7
                        ) .. " // ORIGINAL className INPUTTED: ".. className) 
                    end

                    return (
                        zeroSeven and 
                            lib .. "." .. (string.find(class, "-") and stringSplit(class, "-")[1] or class) -- for 0.7.x
                        or 
                            (string.find(class, "-") and stringSplit(class, "-")[2] or class) -- for below 0.7
                    )
                end
            end
        end
    end

    if doErr then
        d.error("outdate.returnBasedOnVersion: Failed to return class '".. className .."'")
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
                for i, lib in ipairs(libs) do
                    package = package .. lib .. (i == #libs and "" or ".")
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