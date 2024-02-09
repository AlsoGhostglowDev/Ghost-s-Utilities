---@meta File
---@author GhostglowDev

---@class File
local file = {}

---Gets the content of a file
---@param f string The file to fetch
---@param root string The root. If it's from the mod folder. If you want to use the absolute path then use "" or "./"
---@param usingModFolder? boolean If the file is in the mod folder.
---@return string
---@nodiscard
file.getFileContent = function(f, root, usingModFolder) 
    usingModFolder = usingModFolder or false
    root = (root == "./" and "" or (root == nil and (usingModFolder and "mods/"..(currentModDirectory:gsub("/", ""))..root or "assets/"..root) or (usingModFolder and "mods/"..(currentModDirectory:gsub("/", "")).."/" or "assets/")))

    local c = ""
    local t = assert(io.open(root..f, "r"), "File '"..root..f.."' does not exist!")
    c = t:read("*all")
    t:close()

    return c
end

---Gets the absolute directory for the current file
---@return string
---@nodiscard
file.getCurrentDirectory = function()
    return io.popen("cd"):read('*all')
end

return file