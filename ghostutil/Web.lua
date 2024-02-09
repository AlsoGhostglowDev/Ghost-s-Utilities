---@meta Web
---@author T-Bar, GhostglowDev

---@class Web
local web = {}

---Gets the data from a website
---@param website string
---@return string
web.getDataFromWebsite = function(website)
    if website ~= nil then
        addHaxeLibrary("Http", "sys")
        
        runHaxeCode([[
            game.variables["websiteData"] = '';
            var http = new Http("]]..website..[[");
            http.onData = function (data:String) {
                game.variables["websiteData"] = data;
            }
            http.onError = function (error:String) {
                data = ['', ''];
            }
            http.request();
        ]])
        return runHaxeCode("return game.variables['websiteData'];")
    else
        -- Debug uses this class so can't require it
        runHaxeCode([[game.addTextToDebug('web.getDataFromWebsite:1: The argument "website" is not defined!', 0xFFFF0000);]])
    end

    return ""
end

---Loads a link from the argument 
---@param website string
web.browserLoad = function(website)
    addHaxeLibrary("CoolUtil", version >= "0.7.0" and "backend" or "")
    if website ~= nil then
		return runHaxeCode([[CoolUtil.browserLoad("]]..website..[[");]])
	else
		runHaxeCode("game.addTextToDebug('web.browserLoad:1: the website argument is not defined', 0xFFFF0000);")
	end
end

return web