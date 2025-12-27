## `cpp.lua`
*a Utility dedicated to FFI related functions.*

```lua
local cpp = require 'ghostutil.cpp'
```

---

### Fields

```lua
cpp.SWP_NOMOVE = 0x0002
cpp.SWP_NOSIZE = 0x0001
```
<sup>
Used internally by <code>cpp.setWindowZPos</code>. This tells the function not to move the window and to not resize the window respectively.
</sup>

<br>

```lua
cpp.S_OK = 0x00000000
```
<sup>
Used internally by <code>cpp.setWindowColorMode</code> to tell the function to run the backup color mode function if the first one fails.<br>This is done due to Windows 10 using DWM window attribute 19, while Windows 11 uses attribute 20. This prevents running attribute 20 if 19 works. 
</sup>

<br>

```lua
cpp.DWMWA_COLOR_NONE = 0xFFFFFFFE
```
<sup>
Can be used with <code>cpp.setWindowBorderColor</code> to remove the window border entirely.
</sup>

<br>

```lua
cpp.DWMWA_COLOR_DEFAULT = 0xFFFFFFFF
```
<sup>
Can be used with <code>cpp.setWindowBorderColor</code> to set the border color to the default settings set by system preferences.
</sup>

<br>

```lua
cpp.windowColorMode = {
	DARK = 1,
	LIGHT = 0
}
```
<sup>
A table with both of the color modes that Windows can use. Supposed to be used alongside <code>cpp.addressOf</code>.
</sup>

<br>

```lua
cpp.windowCornerType = {
	DEFAULT = 0,
	DONOTROUND = 1,
	ROUND = 2,
	ROUNDSMALL = 3
}
```
<sup>
Supposed to be used with <code>cpp.setWindowCornerType</code> to set the window corners to different modes.
</sup>

<br>

```lua
--Message Formats
cpp.ABORTRETRYIGNORE = ffi.C.MB_ABORTRETRYIGNORE
cpp.CANCELTRYCONTINUE = ffi.C.MB_CANCELTRYCONTINUE
cpp.HELP = ffi.C.MB_HELP
cpp.OKCANCEL = ffi.C.MB_OKCANCEL
cpp.RETRYCANCEL = ffi.C.MB_RETRYCANCEL
cpp.YESNO = ffi.C.MB_YESNO
cpp.YESNOCANCEL = ffi.C.MB_YESNOCANCEL
cpp.OK = ffi.C.MB_OK
```
<sup>
Shortcuts to common message box option modes used in <code>cpp.makeMessageBox</code>.
</sup>

<br>

```lua
--Message Icons
cpp.INFORMATION = ffi.C.MB_ICONINFORMATION
cpp.QUESTION = ffi.C.MB_ICONQUESTION
cpp.WARNING = ffi.C.MB_ICONWARNING
cpp.ERROR = ffi.C.MB_ICONERROR
```
<sup>
Shortcuts to common message box icon modes used in <code>cpp.makeMessageBox</code>.
</sup>

<br>

```lua
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
```
<sup>
Shortcuts to common message box return values used in <code>cpp.makeMessageBox</code>.
</sup>

<br>

```lua
cpp.activeWindow = ffi.C.GetActiveWindow()
```
<sup>
Basically a variable version of <code>cpp.getActiveWindow</code>.<br>Unlike it's method counterpart, which gets the active window when it's called, this one gets the active window when this module is imported.
</sup>

<br>

```lua
cpp.os = ffi.os
```
<sup>
Returns the machine's OS. Possible values are <code>Windows</code>, <code>Linux</code>, <code>OSX</code>, <code>BSD</code>, <code>POSIX</code>, and <code>Other</code>.
</sup>

<br>

```lua
cpp.arch = ffi.arch
```
<sup>
Returns the machine's architecture. Possible values are <code>x86</code>, <code>x64</code>, <code>arm</code>, <code>arm64</code>, <code>arm64be</code>, <code>ppc</code>, <code>mips</code>, <code>mipsel</code>, <code>mips64</code>, <code>mips64el</code>, <code>mips64r6</code>, and <code>mips64r6el</code>.
</sup>

<br>

---

### Methods
```lua
makeMessageBox(title: string, message: string, ?msgForm: number, ?msgIcon: number): number
```
A more advanced version of the `window.alert` function. Allows for message icons, different message options, and returns the option that was clicked.

**Parameters:**
- `title`: The message box's title.
- `a`: The message box's main text.
- `msgForm` **(optional)**: What combination of message answers the message box will show. Refer to the `Message Formats` list for possible combinations.
- `msgIcon` **(optional)**: The alert icon the message box will use. Refer to the `Message Icons` list for possible icons.
  
**Returns:** A number of the option clicked. Refer to the `cpp.messageAnswer` table for a list of possible answers.

<details><summary>View Example</summary>
<p>

```lua
-- Creates a message box with a "Yes" and "No" option and a question mark icon.
local foo = cpp.makeMessageBox("Title", "Are you awesome?", cpp.YESNO, cpp.QUESTION)

if foo == cpp.messageAnswer.YES then
	debugPrint("You are awesome")
else
	debugPrint("You are not awesome")
end
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowZPos(zPos: string): void
```
Layers the active window's Z order on the moniter.

**Parameters:**
- `zPos`: The Z order type to use. <br>
*<sup>(can be <code>topmost</code>, <code>bottom</code>, <code>nottopmost</code>, or <code>top</code>)</sup>*

<details><summary>View Example</summary>
<p>

```lua
-- The window will be layered over all windows, including the taskbar.
cpp.setWindowZPos("topmost")
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getActiveWindow(): hWnd
```
Gets the current active window, usually the game window.

**Returns:** The window handle ([**`hWnd`**](https://learn.microsoft.com/en-us/windows/win32/winmsg/windows)).

<details><summary>View Example</summary>
<p>

```lua
-- Closes the active window
cpp.destroyWindow(cpp.getActiveWindow()) 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
findWindow(windowName: string): hWnd
```
Finds the specified window using it's window name.

**Parameters:**
- `windowName`: The name of the window.

**Returns:** The window handle ([**`hWnd`**](https://learn.microsoft.com/en-us/windows/win32/winmsg/windows)).

<details><summary>View Example</summary>
<p>

```lua
-- Returns the window with the title "Friday Night Funkin': Psych Engine"
cpp.findWindow("Friday Night Funkin': Psych Engine") 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
isWindowEnabled(windowHWND: hWnd): boolean
```
Checks whether the specified window is focused on/enabled.

**Parameters:**
- `windowHWND`: The window handle.

**Returns:** If the specified window is enabled, returns true, otherwise false.

<details><summary>View Example</summary>
<p>

```lua
-- Returns true if the game window is focused on.
cpp.isWindowEnabled(cpp.activeWindow) 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
windowExists(windowHWND: hWnd): boolean
```
Checks whether the specified window exists.

**Parameters:**
- `windowHWND`: The window handle.

**Returns:** If the specified window exists, returns true, otherwise false.

<details><summary>View Example</summary>
<p>

```lua
-- Returns true if the window with the name "Task Manager" is currently opened.
local foo = cpp.findWindow("Task Manager")
cpp.windowExists(foo) 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
disableCrashHandler(): void
```
Disables that annoying "Report this issue to Microsoft" popup that appears whenever the game freezes.

<p align="center">─────────────────────────</p>

```lua
destroyWindow(windowHWND: hWnd): boolean
```
Destroys the specified window. <br>
*<sup>(This function respects windows that restrict destroy access, <b>e.g.</b> Task Manager)</sup>*

**Parameters:**
- `windowHWND`: The window handle.

**Returns:** If the specified window was sucessfully destroyed, returns true, otherwise false.

<details><summary>View Example</summary>
<p>

```lua
-- Closes the window with the name "My Window"
local myWin = cpp.findWindow("My Window")
local closedWin = cpp.destroyWindow(myWin)

if closedWin then
	debugPrint("Window has been closed!")
else
	debugPrint("Window wasn't closed")
end
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
registerDPICompatible(): void
```
Similar to Psych Engine 1.0.4, this registers the game as DPI compatible.

<p align="center">─────────────────────────</p>

```lua
getMonitorCount(): number
```
Gets the number of monitors hooked up to the computer.

**Returns:** The number of monitors connected to your PC.

<details><summary>View Example</summary>
<p>

```lua
local monitors = cpp.getMonitorCount()

if monitors > 1 then
	debugPrint("You have more than one monitor")
elseif monitors <= 0 then
	debugPrint("No monitors? How?!")
end
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowLayered(): void
```
Sets the window as layered, which is good for functions like `setWindowAlpha` and `setWindowTransparency`.

<p align="center">─────────────────────────</p>

```lua
setWindowAlpha(alpha: number): void
```
Similar to setting the `alpha` property of a sprite, this sets the alpha of the current active window.

**Parameters:**
- `alpha`: The window's alpha, from 0 (transparent) to 1 (opaque).

<details><summary>View Example</summary>
<p>

```lua
cpp.setWindowLayered()
cpp.setWindowAlpha(math.random(0, 1))
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowTransparency(win: hWnd, chroma: number): void
```
Sets a color to be transparent on the window.

**Parameters:**
- `win` **(optional)**: The target window. If this is `nil`, then it uses the active window.
- `chroma` **(optional)**: The color to set transparent, formatted as `0x00RRGGBB`. If this is `nil`, then it removes the effect.

<details><summary>View Example</summary>
<p>

```lua
cpp.setWindowLayered()

-- The color black will be replaced with transparent pixels
cpp.setWindowTransparency(cpp.activeWindow, 0x00000000)

-- Sets the window back to normal
cpp.setWindowTransparency(cpp.activeWindow, nil)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setDarkMode(): void
```
Sets the window header to dark mode. <br>
*<sup>(Shortcut to `cpp.setWindowColorMode(true)`)</sup>*


<details><summary>View Example</summary>
<p>

```lua
-- Sets the window to dark mode
cpp.setDarkMode()
cpp.redrawWindowHeader()
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setLightMode(): void
```
Sets the window header to light mode. <br>
*<sup>(Shortcut to `cpp.setWindowColorMode(false)`)</sup>*

<details><summary>View Example</summary>
<p>

```lua
-- Sets the window to light mode
cpp.setLightMode()
cpp.redrawWindowHeader()
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowColorMode(isDark: boolean): void
```
Sets the window header to dark mode or light mode.

**Parameters:**
- `isDark`: Sets the window to dark mode if true, otherwise it sets the window to light mode.

<details><summary>View Example</summary>
<p>

```lua
-- Sets the window to dark mode
cpp.setWindowColorMode(true)
cpp.redrawWindowHeader()

-- Sets the window to light mode
cpp.setWindowColorMode(false)
cpp.redrawWindowHeader()
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowBorderColor(colorHex: string|number, setHeader: boolean, setBorder: boolean): void
```
Sets the window header to the color specified. <br>
*<sup>(This function only has an effect on Windows 11)</sup>*

**Parameters:**
- `colorHex`: The color specified. Allowed formats are `'#RRGGBB'`, `'0xRRGGBB'`, `'RRGGBB'`, or `0xRRGGBB`.
- `setHeader`: Whether to affect the window header.
- `setBorder`: Whether to affect the window border.

<details><summary>View Example</summary>
<p>

```lua
-- Makes the border & header red
cpp.setWindowBorderColor(0xFF0000, true, true)

-- Makes the border green
cpp.setWindowBorderColor(0x00FF00, false, true)

-- Resets the window's color
cpp.setWindowBorderColor(cpp.DWMWA_COLOR_DEFAULT, true, true)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowTextColor(colorHex: string|number): void
```
Sets the window title text to the color specified. <br>
*<sup>(This function only has an effect on Windows 11)</sup>*

**Parameters:**
- `colorHex`: The color specified. Allowed formats are `'#RRGGBB'`, `'0xRRGGBB'`, `'RRGGBB'`, or `0xRRGGBB`.

<details><summary>View Example</summary>
<p>

```lua
-- Makes the window title text blue
cpp.setWindowTextColor(0x0000FF)

-- Resets the window's text color
cpp.setWindowTextColor(cpp.DWMWA_COLOR_DEFAULT)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setWindowCornerType(cornerType: number): void
```
Sets the window border corners to the type specified. <br>
*<sup>(This function only has an effect on Windows 11)</sup>*

**Parameters:**
- `cornerType`: The corner type. Refer to `cpp.windowCornerType` for a list of possible values.

<details><summary>View Example</summary>
<p>

```lua
-- Makes the window's corners non-round
cpp.setWindowCornerType(cpp.windowCornerType.DONOTROUND)

-- Resets the window's corners to default
cpp.setWindowCornerType(cpp.windowCornerType.DEFAULT)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
redrawWindowHeader(): void
```
Reloads the window header to force a window header effect. This is useful for Windows 10 users, but is not needed for Windows 11.

<details><summary>View Example</summary>
<p>

```lua
cpp.setDarkMode()
cpp.redrawWindowHeader()
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
cast(varToConvert: any, toType: string, isCType: boolean): dynamic
```
Casts a variable into the type specified, similar to traditional casts in other languages.

**Parameters:**
- `varToConvert`: The variable to convert.
- `toType`: The type to convert the variable to.
- `isCType` **(optional)**: Set this to true if you wanna use C types. <br>
*<sup>(This will make the function use `ffi.cast`)</sup>*

**Returns:** The casted variable.

<details><summary>View Example</summary>
<p>

```lua
-- Converts the bool into a string. This would read "That is true"
local aBool = true
debugPrint("That is " ..cpp.cast(aBool, "string"))

-- Casts the integer 1 into a DWORD unsigned 32bit integer
local coolInt = cpp.cast(1, "DWORD", true)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
alignof(var: any): dynamic
```
Returns the alignment of a variable. <br>
*<sup>(This function only has an effect on C / FFI types)</sup>*

**Parameters:**
- `var`: The variable.

**Returns:** The variable's alignment.

<details><summary>View Example</summary>
<p>

```lua
local aInt = cpp.alignof("int") -- Returns 4
local aChar = cpp.alignof("char") -- Returns 1
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
sizeof(var: any): integer
```
Returns the byte size of a variable. <br>
*<sup>(This function only has an effect on C / FFI types)</sup>*

**Parameters:**
- `var`: The variable.

**Returns:** The variable's byte size.

<details><summary>View Example</summary>
<p>

```lua
-- Since an int is 4, we multiply it by 10 to get a size of 40
local aInt = cpp.sizeof("int[10]")
-- A size of 256
local aChar = cpp.sizeof("char[256]")
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
addressOf(target: any): integer
```
Returns the address of a variable. Very useful for some C functions.

**Parameters:**
- `target`: The variable.

**Returns:** The variable's address.

<details><summary>View Example</summary>
<p>

```lua
-- Returns the address of 1
local myAdd = cpp.addressOf(1)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
compress(text: string): string
```
Compresses a string to save on resources. <br>
*<sup>(Taken from the offical [**`luajit`**](https://luajit.org/ext_ffi_tutorial.html) docs)</sup>*

**Parameters:**
- `text`: The string of text to compress.

**Returns:** The compressed text.

<details><summary>View Example</summary>
<p>

```lua
-- Compresses the string, duh
local myTxt = "Hello from Ghostutil!"
local myAdd = cpp.compress(myTxt)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
uncompress(compressedText: string, txtLength: integer): string
```
Uncompresses a string from `cpp.compress`. <br>
*<sup>(Taken from the offical [**`luajit`**](https://luajit.org/ext_ffi_tutorial.html) docs)</sup>*

**Parameters:**
- `compressedText`: The string of text to uncompress.
- `txtLength`: The length of the string. It's best to set this to `#compressedText`.

**Returns:** The uncompressed text.

<details><summary>View Example</summary>
<p>

```lua
-- Compresses the string, duh
local myTxt = "Hello from Ghostutil!"
local foo = cpp.compress(myTxt)

local coolTxt = cpp.uncompress(foo, #foo)

-- "Hello from Ghostutil!"
debugPrint(coolTxt)
```

</p>
</details>

<br>

---

<p align="center">
<sub><b>GhostUtil 3.0.0</b> • <b>Docs 3.0.0</b>, Revision 1</sub> <br><br>
<sub><i>
a Lua Library made by GhostglowDev; for <a href='https://github.com/ShadowMario/FNF-PsychEngine'>Psych Engine</a> <br>
© 2025 <a href='https://github.com/AlsoGhostglowDev'>GhostglowDev</a> — <a href='https://github.com/AlsoGhostglowDev/Ghost-s-Utilities'>Ghost's Utilities</a> <br>
Licensed under the <a href='https://opensource.org/license/mit'>MIT License</a>.
</sub></i>
</p>