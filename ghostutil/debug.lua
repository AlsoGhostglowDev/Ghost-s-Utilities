local dbg = {}
local web = require 'ghostutil.web'

dbg.dev = false

-- from Stack Overflow:
-- https://stackoverflow.com/a/20100401
local function split(str, del)
    if not stringSplit then
        result = {}
        for match in (str..del):gmatch("(.-)"..del) do
            table.insert(result, match)
        end
        return result
    else return stringSplit(str, del) end
end

local function getTopLevelInfo(mode, max)
    for i = 1, (max or 10) do
        local info = debug.getinfo(i, mode)
        if info == nil then
            return debug.getinfo(i-2, mode)
        end
    end
end

local verFile = assert(io.open("ghostutil/ghostutil.version", "r"))
dbg.verFile = split(verFile:read("*all"), "\n")
dbg.version = dbg.verFile[1]
dbg.stage = dbg.verFile[2] 
verFile:close()

dbg.logs = {}
dbg.checkForUpdates = true

function dbg.getCurrentVersion() return dbg.version end
function dbg.getCurrentStage() return dbg.stage end

function dbg.isOutdated()
    return (dbg.getLatestVersion() ~= dbg.getCurrentVersion()) or (dbg.getLatestStage() ~= dbg.getCurrentStage())
end

function dbg.getLatest(index)
    index = math.floor(math.max(1, math.min(2, index)))
    local ret = stringSplit(web.getDataFromWebsite("https://raw.githubusercontent.com/AlsoGhostglowDev/Ghost-s-Utilities-Alt/main/ghostutil/ghostutil.version"), "\n")[index]
    if ret == '' then dbg.error("debug.getLatest: User is offline") ; return nil end
    return ret
end
function dbg.getLatestVersion() 
    local ret = dbg.getLatest(1) 
    if ret == '' then dbg.error("debug.getLatestVersion: User is offline") ; return 'N/A' end 
    return ret 
end
function dbg.getLatestStage() 
    local ret = dbg.getLatest(2) 
    if ret == "" then dbg.error("debug.getLatestVersion: User is offline") ; return 'N/A' end 
    return ret 
end

function dbg.exception(exception, excType, formattedText, func, exceptionMsg, level)
    local cols = {
        ['deprecated'] = 'ff8800',
        ['warning']    = 'ffbb00',
        ['error']      = 'ff0000'
    }

    local exceptions = {
        ['nil_param']  = 'Expected a value for parameter %s.',
        ['no_eq']      = 'Parameter %s can\'t be the same as %s!',
        ['no_eq_tbl']  = 'Values in table from parameter %s cannot be the same!',
        ['wrong_type'] = 'Expected %s, got %s instead.',
        ['less_len']   = 'Insufficient table length in parameter %s.\nExpected length to be %s, got %s instead',
        ['over_len']   = 'Too much elements in table in parameter %s.\nExpected length to be %s, got %s instead',
        ['missing_el'] = 'Missing element "%s" from %s.',
        ['unrecog_el'] = 'Unrecognized element "%s" from %s.'
    }
    
    local exceptionType = {
        'deprecated',
        'warning',
        'error'
    }
    
    -- level 3 for calling in regular scripts,
    -- level 4 is for calling debug.error in ghostutil
    local info = getTopLevelInfo('Sln', level)
    local exceptionSource = string.format('%s:%s', info.source:sub(2), info.currentline)

    -- 1: Exception Source, 2: Parent function, 3: Exception Message 
    local errFormat = 'GHOSTUTIL ERROR: %s: '.. (func or '') .. ((func == '' or func == nil) and '' or ': ')..'%s'
    local errMsg = errFormat:format(exceptionSource, exceptionMsg or exceptions[exception]:format(unpack(formattedText)))

    if version >= '0.7' then
        debugPrint(errMsg, cols[excType or 'error'])
    else
        runHaxeCode('game.addTextToDebug("'.. errMsg ..'", 0x'.. cols[excType or 'error'] ..');')
    end
end

function dbg.error(exception, args, func, forcedMsg, level)
    if luaDebugMode or dbg.dev then 
        dbg.exception(exception, 'error', args, func, forcedMsg, level)
    end
end

function dbg.warn(exception, args, func, forcedMsg, level)
    if luaDebugMode or dbg.dev then 
        dbg.exception(exception, 'warning', args, func, forcedMsg, level)
    end
end

function dbg.log(msg, printLog) 
    table.insert(dbg.logs, msg)
    if printLog and dbg.dev then 
        runHaxeCode('game.addTextToDebug("GHOSTUTIL: Log: '.. msg ..'", 0xFF00FF00);') 
    end
end

return dbg