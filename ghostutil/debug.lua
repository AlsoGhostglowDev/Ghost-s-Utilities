---@meta debug
---@author GhostglowDev

---@class Debug
local debug = {}

local w = require "ghostutil.web"

-- https://stackoverflow.com/a/20100401
---@nodiscard
local function split(str, del)
    result = {}
    for match in (str..del):gmatch("(.-)"..del) do
        table.insert(result, match)
    end
    return result
end

---Contains all the messages from the function `log`
debug.logs = {}
---Show warnings when this GhostUtil version is outdated.
debug.checkForUpdates = true

local vf = assert(io.open("ghostutil/ghostutil.version", "r"))

---A table splitted into two, {version, stage}
debug.ver = split(vf:read("*all"), "\n")
table.remove(debug.ver, 3)
---The current version of GhostUtil
debug.version = debug.ver[1]
--- The current stage of GhostUtil
debug.stage = debug.ver[2]

vf:close()

function __debug_gcall(func, _)
	if func ~= "createpost" then return end 
    if (debug.checkOutdate()) and debug.checkForUpdates then
        debug.warning("This version of GhostUtil is outdated!\nTo turn off this warning, set debug.checkForUpdates to false.", false)
    end

    if version == "0.7.1h" then
        debug.error("GLOBAL: This version can cause this class and potentially\nall of GhostUtil to break.\nSOLUTION: Please update to a newer version or downgrade to 0.6.3", false) 
    end
end

---Fetches the latest version/stage of GhostUtil
---@param balls integer 
---@return string
---@nodiscard
function debug.getLatest(balls)
    balls = math.floor(math.max(1, math.min(2, balls)))
    local a = stringSplit(w.getDataFromWebsite("https://raw.githubusercontent.com/AlsoGhostglowDev/Ghost-s-Utilities-Alt/main/ghostutil/ghostutil.version"), "\n")[balls]
    if a == "" then
        debug.error("debug.getLatest: User is offline")
        return ""
    end
    return a
end

---Fetches the latest version of GhostUtil
---@return string
---@nodiscard
function debug.getLatestVersion() local a = debug.getLatest(1) if a == "" then debug.error("debug.getLatestVersion: Failed to fetch latest version: User is offline") return end return a end
---Fetches the latest stage of GhostUtil
---@return string
---@nodiscard
function debug.getLatestStage() local a = debug.getLatest(2) if a == "" then debug.error("debug.getLatestVersion: Failed to fetch latest stage: User is offline") return end return a end

---Returns if the current ghostutil version is outdated
---@return table<boolean, table<string>, table<string>> 
---@nodiscard
function debug.checkOutdate()
    -- string sub my savior
    return ((debug.version):sub(1, 3) ~= (debug.getLatestVersion()):sub(1, 3)) and (debug.stage ~= debug.getLatestStage())
end

---Prints out a GhostUtil error message
---@param message string The error message
---@param ifDebug boolean Is it visible only when `luaDebugMode` is turned on?
function debug.error(message, ifDebug)
    ifDebug = ifDebug == nil and true or ifDebug

    if ifDebug then
        if luaDebugMode then
            if version >= "0.7.0" then 
                callMethod("addTextToDebug", {'ERROR: '.. scriptName ..':GhostUtil: '..message, getColorFromHex "FF0000"}) 
            else runHaxeCode("game.addTextToDebug('ERROR: ".. scriptName ..":GhostUtil: "..message.."', 0xFFFF0000);")
            end
        end
    else
        if version >= "0.7.0" then
            callMethod("addTextToDebug", {'ERROR: '..scriptName..':GhostUtil: '..message, getColorFromHex "FF0000"})
        else runHaxeCode("game.addTextToDebug('ERROR: "..scriptName..":GhostUtil: "..message.."', 0xFFFF0000);")
        end
    end
end

---Prints out a GhostUtil warning message
---@param message string The warning message
---@param ifDebug boolean Is it visible only when `luaDebugMode` is turned on?
function debug.warning(message, ifDebug)
    -- basically the same as error message but with orange text instead of red
    ifDebug = ifDebug == nil and true or ifDebug
    if ifDebug then
        if luaDebugMode then
            if version >= "0.7.0" then
                callMethod("addTextToDebug", {'WARNING: '..scriptName..':GhostUtil: '..message, getColorFromHex "FFC803"})
            else runHaxeCode("game.addTextToDebug('WARNING: "..scriptName..":GhostUtil: "..message.."', 0xFFFFC803);")
            end
        end
    else
        if version >= "0.7.0" then
            callMethod("addTextToDebug", {'WARNING: '..scriptName..':GhostUtil: '..message, getColorFromHex "FFC803"})
        else runHaxeCode("game.addTextToDebug('WARNING: "..scriptName..":GhostUtil: "..message.."', 0xFFFFC803);")
        end
    end
end

---Prints out a log message and stores it in a table called "logs"
---@param message string Message to log
---@param ifDebug boolean Is it visible only when `luaDebugMode` is turned on?
function debug.log(message, ifDebug)
    -- basically the same as error message but with green text instead of red
    ifDebug = ifDebug == nil and true or ifDebug
    if ifDebug then
        if luaDebugMode then
            if version >= "0.7.0" then
                callMethod("addTextToDebug", {'LOG: '..scriptName..':GhostUtil: '..message, getColorFromHex "00FF00"})
            else runHaxeCode("game.addTextToDebug('LOG: "..scriptName..":GhostUtil: "..message.."', 0xFF00FF00);")
            end
        end
    else
        if version >= "0.7.0" then
            callMethod("addTextToDebug", {'LOG: '..scriptName..':GhostUtil: '..message, getColorFromHex "00FF00"})
        else runHaxeCode("game.addTextToDebug('LOG: "..scriptName..":GhostUtil: "..message.."', 0xFF00FF00);")
        end
    end

    table.insert(debug.logs, message)
end

return debug