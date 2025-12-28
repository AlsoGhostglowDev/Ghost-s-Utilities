local web = {}

local function printError(func, message)
    if version >= '0.7' then
        debugPrint(('GHOSTUTIL ERROR: %s: %s'):format(func, message), 'red')
    else
        runHaxeCode(("game.addTextToDebug('GHOSTUTIL ERROR: %s: %s', 0xFFFF0000);"):format(func, message))
    end
end

local function _addHaxeLibrary(library, package)
    luaDeprecatedWarnings = false
    addHaxeLibrary(library, package)
    luaDeprecatedWarnings = true
end

web.initialized = false
function web.init()
    if not web.initialized then
        _addHaxeLibrary('Http', 'sys')
        if version < '0.7' then 
            _addHaxeLibrary('CoolUtil')
        end
        web.initialized = true
    end
end

function web.getDataFromUrl(url)
	if url ~= nil and #url > 0 then
        web.init()
		return runHaxeCode([[
			var retVal = null;
			var http = new Http(']] ..url.. [[');
			http.headers.push({name: 'User-Agent', value: 'request'});

			http.onData = function(data:String) {
				retVal = data;
			}
			/* // TODO: Use this to locate new target url in-case current link is a redirect
			http.onStatus = function(s) {
				if(s == 301 // Moved Permanently
				|| s == 302 // Found, but Temporarily Moved
				|| s == 307 // Temporary Redirect
				|| s == 308 // Redirected Permanently
				) {
					retVal = _getUrlData(http.responseHeaders.get("Location"));
				}
			}
			*/
			http.onError = function (error:String) {
				retVal = "ERROR";
			}
			http.request();
			return retVal;
		]]);
	else
		printError('web.getDataFromUrl:1', 'bad argument #1 (value expected)');
	end
    return '';
end
web.getDataFromWeb = web.getDataFromUrl
web.getDataFromWebsite = web.getDataFromUrl

function web.loadBrowser(url)
    web.init()
    if url ~= nil then
        if version > '0.7' then
            return callMethodFromClass('backend.CoolUtil', 'browserLoad', {url})
        else
		    return runHaxeCode('return CoolUtil.browserLoad('.. url ..');')
        end
	else
		printError('web.loadBrowser:1', 'bad argument #1 (value expected)')
	end
end
web.loadURL = web.loadBrowser

return web