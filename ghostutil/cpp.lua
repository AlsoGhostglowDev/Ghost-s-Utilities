local cpp = {}

local debug = require "ghostutil.debug"
local helper = require "ghostutil.backend.helper"

local ffi = require("ffi")
local user32 = ffi.load("user32")
local dwmapi = ffi.load("dwmapi")
local kernel = ffi.load("kernel32")
local zlib = ffi.load(ffi.os == "Windows" and "zlib1" or "z")
ffi.cdef([[
	enum{
		MB_ABORTRETRYIGNORE = 0x00000002L,
		MB_OK = 0x00000000L,
		MB_CANCELTRYCONTINUE = 0x00000006L,
		MB_HELP = 0x00004000L,
		MB_OKCANCEL = 0x00000001L,
		MB_RETRYCANCEL = 0x00000005L,
		MB_YESNO = 0x00000004L,
		MB_YESNOCANCEL = 0x00000003L,
		MB_ICONINFORMATION = 0x00000040L,
		MB_ICONWARNING = 0x00000030L,
		MB_ICONERROR = 0x00000010L,
		MB_ICONQUESTION = 0x00000020L
	};

	typedef void* HANDLE;
	typedef HANDLE HWND;
	typedef const char* LPCSTR;
	typedef unsigned UINT;
	typedef int BOOL;
	
	typedef void* CONST;
    typedef unsigned long DWORD;
	typedef DWORD COLORREF;
	typedef unsigned char BYTE;
	typedef const void *LPCVOID;
	typedef long LONG;
	typedef LONG HRESULT;
	
	typedef int ULONGLONG;
	typedef ULONGLONG *PULONGLONG;
	
	HWND GetActiveWindow();
	void UpdateWindow(HWND hWnd);
	
	BOOL DestroyWindow(HWND hWnd);
	BOOL ShowWindow(HWND hWnd, int nCmdShow);
	BOOL IsWindow(HWND hWnd);
	HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);
	BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);
	BOOL IsWindowEnabled(HWND hWnd);
	
	BOOL SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha, DWORD dwFlags);
	LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);
	LONG GetWindowLongA(HWND hWnd, int nIndex);
	int MessageBoxA(HWND, LPCSTR, LPCSTR, UINT);

	int system (const char* command);

	HRESULT DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
	BOOL SetProcessDPIAware();

	int GetSystemMetrics(int nIndex);
	UINT SetErrorMode(UINT uMode);

	unsigned long compressBound(unsigned long sourceLen);
	int compress2(uint8_t *dest, unsigned long *destLen, const uint8_t *source, unsigned long sourceLen, int level);
	int uncompress(uint8_t *dest, unsigned long *destLen, const uint8_t *source, unsigned long sourceLen);
]])

---------------------------------------------------------------------
--                            Variables                            --
---------------------------------------------------------------------

cpp.SWP_NOMOVE = 0x0002
cpp.SWP_NOSIZE = 0x0001

cpp.S_OK = 0x00000000
cpp.DWMWA_COLOR_NONE = 0xFFFFFFFE
cpp.DWMWA_COLOR_DEFAULT = 0xFFFFFFFF
cpp.windowColorMode = {
	DARK = 1,
	LIGHT = 1
}

cpp.windowCornerType = {
	DEFAULT = 0,
	DONOTROUND = 1,
	ROUND = 2,
	ROUNDSMALL = 3
}

cpp.windowcolormode_address = {
	DARK = 0x7ffec8f410bf,
	LIGHT = 000000
}

-- Message Formats --
cpp.ABORTRETRYIGNORE = ffi.C.MB_ABORTRETRYIGNORE
cpp.CANCELTRYCONTINUE = ffi.C.MB_CANCELTRYCONTINUE
cpp.HELP = ffi.C.MB_HELP
cpp.OKCANCEL = ffi.C.MB_OKCANCEL
cpp.RETRYCANCEL = ffi.C.MB_RETRYCANCEL
cpp.YESNO = ffi.C.MB_YESNO
cpp.YESNOCANCEL = ffi.C.MB_YESNOCANCEL
cpp.OK = ffi.C.MB_OK

-- Message Icons --
cpp.INFORMATION = ffi.C.MB_ICONINFORMATION
cpp.QUESTION = ffi.C.MB_ICONQUESTION
cpp.WARNING = ffi.C.MB_ICONWARNING
cpp.ERROR = ffi.C.MB_ICONERROR

-- Message Box Answers --
cpp.messageAnswer = {
	ABORT = 3,
	CANCEL = 2,
	CONTINUE = 11,
	IGNORE = 5,
	OK = 1,
	YES = 6,
	NO = 7,
	RETRY = 4,
	TRYAGAIN = 10
}

cpp.activeWindow = ffi.C.GetActiveWindow()

cpp.os = ffi.os

cpp.arch = ffi.arch

---------------------------------------------------------------------
---                           Functions                           ---
---------------------------------------------------------------------

function cpp.makeMessageBox(title, message, msgForm, msgIcon)
	if message == nil or title == nil then
		debug.error("cpp.makeMessageBox: the parameter \"" ..(title == nil and "title" or "message").. "\" is nil.")
	else
		return user32.MessageBoxA(nil, tostring(message), tostring(title), ((msgForm ~= nil) and msgForm or 0) + ((msgIcon ~= nil) and msgIcon or 0))
	end
end

function cpp.setWindowZPos(zPos)
	ffi.C.SetWindowPos(ffi.C.GetActiveWindow(), getZFromString(zPos), 0, 0, 0, 0, cpp.SWP_NOMOVE + cpp.SWP_NOSIZE)
end

function cpp.getActiveWindow()
	return ffi.C.GetActiveWindow()
end

function cpp.findWindow(windowName)
	return ffi.C.FindWindowA(nil, tostring(windowName))
end

function cpp.isWindowEnabled(windowHWND)
	return (ffi.C.IsWindowEnabled(windowHWND) == 1)
end

function cpp.windowExists(windowHWND)
	return (ffi.C.IsWindow(windowHWND) == 1)
end

function cpp.disableCrashHandler()
	kernel.SetErrorMode(0x0001 + 0x0002)
end

function cpp.destroyWindow(windowHWND)
	if windowHWND ~= nil then 
		if cpp.windowExists(windowHWND) then user32.DestroyWindow(windowHWND) else 
			debug.error("cpp.destroyWindow: no window was found. Does the specified window exist?") 
		end
	else 
		debug.error("cpp.destroyWindow: the parameter \"windowHWND\" is nil.")
	end
end

function cpp.registerDPICompatible()
	ffi.C.SetProcessDPIAware()
end

function cpp.getMoniterCount()
	return ffi.C.GetSystemMetrics(80)
end

function cpp.setWindowLayered()
	local window = ffi.C.GetActiveWindow()
	user32.SetWindowLongA(window, -20, user32.GetWindowLongA(window, -20) + 0x00080000)
end

function cpp.setWindowAlpha(alpha)
	local window = ffi.C.GetActiveWindow()
	local a = alpha

	if alpha > 1 then a = 1 end
	if alpha < 0 then a = 0 end
    
    if ffi.C.SetWindowLongA(window, -20, 0x00080000) ~= 0 then
		ffi.C.SetLayeredWindowAttributes(window, 0, (255 * (a * 100)) / 100, 0x00000002)
    end
end

function cpp.setWindowTransparency(win, chroma)
	local hWnD = win
    if hWnD == nil then
		hWnD = ffi.C.GetActiveWindow()
		debug.warn("cpp.setWindowTransparency: no window was found. Using the active window instead.")
    end
    if ffi.C.SetWindowLongA(hWnD, -20, 0x00080000) == 0 then end
    if ffi.C.SetLayeredWindowAttributes(hWnD, ((chroma ~= nil) and tonumber(chroma) or -29292929) , 0, 0x00000001) == 0 then end
end

function cpp.hasWindowsVersion(vers)
	return (string.find(getPropertyFromClass("lime.system.System", "platformLabel"), vers) ~= nil)
end

function cpp.setDarkMode()
	local window = ffi.C.GetActiveWindow()
	local isDark = dwmapi.DwmSetWindowAttribute(window, 19, ffi.new("int[1]", cpp.addressOf(cpp.windowColorMode.DARK)), ffi.sizeof(ffi.cast("DWORD", cpp.windowColorMode.DARK)))

	if isDark == 0 or isDark ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, ffi.new("int[1]", cpp.addressOf(cpp.windowColorMode.DARK)), ffi.sizeof(ffi.cast("DWORD", cpp.windowColorMode.DARK)))
	end
	
	ffi.C.UpdateWindow(window)
end

function cpp.setLightMode()
	local window = ffi.C.GetActiveWindow()
	local isLight = dwmapi.DwmSetWindowAttribute(window, 19, ffi.new("int[1]", 0), ffi.sizeof(ffi.cast("DWORD", 0)))

	if isLight == 0 or isLight ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, ffi.new("int[1]", 0), ffi.sizeof(ffi.cast("DWORD", 0)))
	end
	
	ffi.C.UpdateWindow(window)
end

function cpp.setWindowColorMode(isDark)
	if isDark then cpp.setDarkMode()
	else cpp.setLightMode() end
end

function cpp.setWindowBorderColor(colorHex, setHeader, setBorder)
	local window = ffi.C.GetActiveWindow()
	local strHex = (colorHex == nil or (type(colorHex) ~= 'number' and #colorHex < 6 or false)) and '0xFFFFFF' or _rgbHexToBGR(colorHex)
	local hex = tonumber('0x'..strHex)
	
	if setHeader == nil then setHeader = true end
	if setBorder == nil then setBorder = true end
	
	if setHeader then dwmapi.DwmSetWindowAttribute(window, 35, ffi.new("int[1]", cpp.addressOf(hex)), ffi.sizeof(ffi.cast("DWORD", (hex)))) end
	if setBorder then dwmapi.DwmSetWindowAttribute(window, 34, ffi.new("int[1]", cpp.addressOf(hex)), ffi.sizeof(ffi.cast("DWORD", (hex)))) end

	ffi.C.UpdateWindow(window)
end

function cpp.setWindowTextColor(colorHex)
	local window = ffi.C.GetActiveWindow()
	local strHex = (colorHex == nil or (type(colorHex) ~= 'number' and #colorHex < 6 or false)) and '0xFFFFFF' or _rgbHexToBGR(colorHex)
	local hex = tonumber('0x'..strHex)
	
	dwmapi.DwmSetWindowAttribute(window, 36, ffi.new("int[1]", cpp.addressOf(hex)), ffi.sizeof(ffi.cast("DWORD", (hex))))

	ffi.C.UpdateWindow(window)
end

function cpp.setWindowCornerType(cornerType)
    local window = ffi.C.GetActiveWindow()

    dwmapi.DwmSetWindowAttribute(window, 33, ffi.new("int[1]", cpp.addressOf(cornerType)), ffi.sizeof(ffi.cast("DWORD", (cornerType))))
    ffi.C.UpdateWindow(window)
end

function cpp.redrawWindowHeader()
	for i = 0, 1 do
		setPropertyFromClass('flixel.FlxG', 'stage.window.borderless', not (getPropertyFromClass('flixel.FlxG', 'stage.window.borderless')))
	end
end

--  Standard C syntax functions  --
function cpp.cast(toType, varToConvert)
	return ffi.cast(toType, varToConvert)
end

function cpp.alignof(var)
	return ffi.alignof(var)
end

function cpp.sizeof(var)
	return ffi.sizeof(var)
end

function cpp.addressOf(target)
	local hi = ffi.new("int[1]", target)
    return hi[0]
end

function cpp.compress(text)
	local n = zlib.compressBound(#text)
	local buf = ffi.new("uint8_t[?]", n)
	local buflen = ffi.new("unsigned long[1]", n)
	local res = zlib.compress2(buf, buflen, text, #text, 9)
	assert(res == 0)
	return ffi.string(buf, buflen[0])
end

function cpp.uncompress(comp, n)
	local buf = ffi.new("uint8_t[?]", n)
	local buflen = ffi.new("unsigned long[1]", n)
	local res = zlib.uncompress(buf, buflen, comp, #comp)
	assert(res == 0)
	return ffi.string(buf, buflen[0])
end

----------------------------------------------------------------------
---                             Helper                             ---
----------------------------------------------------------------------

function getZFromString(zpos)
	if zpos ~= nil then
		if zpos:lower() == "topmost" then return ffi.cast("HWND", -1)
		elseif zpos:lower() == "bottom" then return ffi.cast("HWND", 1)
		elseif zpos:lower() == "notopmost" then return ffi.cast("HWND", -2) 
		end
	end
	return ffi.cast("HWND", 0)
end

function _rgbHexToBGR(rgb)
	-- conv int hex to string hex
	if type(rgb) == 'number' then rgb = string.format("%x", rgb):upper() end
	-- discard if hex isn't string
	if type(rgb) ~= 'string' then 
		debugPrint('ERROR on loading: '.. scriptName ..': _rgbHexToBGR: Failed to parse into BGR format.') 
		return rgb
	end
	-- discard extras
	rgb = stringStartsWith(rgb, '0x') and rgb:sub(3,8) or stringStartsWith(rgb, '#') and rgb:sub(2,7) or rgb
	rgb = #rgb > 6 and rgb:sub(1,6) or rgb

	-- parse
	local b, g, r = rgb:sub(5,6), rgb:sub(3,4), rgb:sub(1,2)
	return b..g..r 
end

return cpp