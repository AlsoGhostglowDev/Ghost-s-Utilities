---@meta web
---@author T-Bar, GhostglowDev

---@class Web
local web = {}

---Gets the data from a website
---@param website string
---@return string
function web.getDataFromWebsite(website)
    if website ~= nil then
        addHaxeLibrary("Http", "sys")
        
        runHaxeCode([[
            setVar("websiteData", '');
            var http = new Http("]]..website..[[");
            http.onData = function (data:String) {
                setVar("websiteData", data);
            }
            http.onError = function (error:String) {
                setVar("websiteData", ['', '']);
            }
            http.request();
        ]])
        return runHaxeCode("return getVar('websiteData')")
    else
        -- Debug uses this class so can't require it
        runHaxeCode([[game.addTextToDebug('web.getDataFromWebsite:1: The argument "website" is not defined!', 0xFFFF0000);]])
    end

    return ""
end

---Loads a link from the argument 
---@param website string
function web.browserLoad(website)
    addHaxeLibrary("CoolUtil", version >= "0.7.0" and "backend" or "")
    if website ~= nil then
		return runHaxeCode([[CoolUtil.browserLoad("]]..website..[[");]])
	else
		runHaxeCode("game.addTextToDebug('web.browserLoad:1: the website argument is not defined', 0xFFFF0000);")
	end
end

return web