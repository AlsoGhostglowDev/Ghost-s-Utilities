local web = {}

local function printError(func, message)
    if version > '0.7' then
        debugPrint(('GHOSTUTIL ERROR: %s: %s'):format(func, message), 'red')
    else
        runHaxeCode(("game.addTextToDebug('GHOSTUTIL ERROR: %s: %s', 0xFFFF0000);"):format(func, message))
    end
end

function web.getDataFromWebsite(website)
    if website ~= nil and #website > 0 then
        addHaxeLibrary("Http", "sys")
        
        runHaxeCode([[
            setVar("websiteData", '');
            var http = new Http("]]..website..[[");
            http.onData = function (data:String) {
                setVar("__websiteData", data);
            }
            http.onError = function (error:String) {
                setVar("__websiteData", ['', '']);
            }
            http.request();
        ]])
        return getVar('__websiteData')
    else
        printError('web.getDataFromWebsite:1', 'bad argument #1 (value expected)')
    end

    return ""
end

function web.loadBrowser(website)
    if website ~= nil then
        if version > '0.7' then
            return callMethodFromClass('backend.CoolUtil', 'browserLoad', {website})
        else
            addHaxeLibrary('CoolUtil')
		    return runHaxeCode('CoolUtil.browserLoad('.. website ..');')
        end
	else
		printError('web.loadBrowser:1', 'bad argument #1 (value expected)')
	end
end

return web