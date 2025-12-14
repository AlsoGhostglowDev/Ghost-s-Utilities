local file = {}

local helper = require 'ghostutil.backend.helper'
local debug = require 'ghostutil.debug'

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

local function open(filePath, mode, fn)
    local file = assert(io.open(filePath, mode))
    local ret = fn(file)
    file:close()
    return ret
end

function file.write(filePath, content)
    if not saveFile then
        open(filePath, 'w', function(file)
            file:write(content)
        end)
        return
    end
    saveFile(filePath, content, true)
end

function file.append(filePath, content)
    if not saveFile then
        open(filePath, 'a', function(file)
            file:read(content)
        end)
        return
    end
    saveFile(filePath, file.read(filePath) .. content)
end

function file.read(filePath)
    return open(filePath, 'r', function(file)
        return file:read('*a')
    end)
end

function file.exists(filePath)
    local exists = false
    if not checkFileExists then
        if helper.legacyAvailable() then
            exists = helper.callMethodFromClass('sys.FileSystem', 'exists', {filePath})
        else
            exists = open(filePath, 'r', function(file)
                if not file then return false end
                return true
            end)
            if not exists then
                debug.warn('', {}, 'file.exists', 'Result might not be accurate,\nplease run this in an appropriate callback.')
            end
        end
        return exists
    end
    return checkFileExists(filePath, true)
end

function file.isDirectory(filePath)
    if file.exists(filePath) then
        if helper.legacyAvailable() then
            local isDir = helper.callMethodFromClass('sys.FileSystem', 'isDirectory', {filePath})
            return isDir
        end
        debug.warn('', {}, 'file.isDirectory', 'This function is unavailable outside a function.\nPlease run this in an appropriate callback')
    end
    return false
end

function file.readDirectory(filePath)
    if file.exists(filePath) then
        if not directoryFileList then
            if helper.legacyAvailable() then
                local dir = helper.callMethodFromClass('sys.FileSystem', 'readDirectory', {filePath})
                return dir
            end
            debug.warn('', {}, 'file.readDirectory', 'Result might not be accurate,\nplease run this in an appropriate callback.')
            return
        end
        return directoryFileList(filePath, true) 
    end
    return {}
end

function file.move(filePath, newPath)
    filePath = filePath:gsub('\\', '/')
    newPath = newPath:gsub('\\', '/')
    local splPath = split(filePath, '/')
    local file = splPath[#splPath]
    os.rename(filePath, newPath ..'/'.. file)
end

return file