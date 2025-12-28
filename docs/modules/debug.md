## `debug.lua`
*GhostUtil's backend debugger used to report errors and warnings to user.*

```lua
local debug = require 'ghostutil.debug'
```
*<sub>(module name may conflict with Lua's existing <code>debug</code> library.)</sub>*

---

### Fields
```lua
dev: boolean = false
```
<sup>
Turn this on to enable GhostUtil's developer mode. Forces errors, warnings and GhostUtil logs to be printed.
</sup>

<br>

```lua
verFile: table<string> = { '3.0', 'release' }
```
<sup>
A table containing the current version from <code>ghostutil.version</code>. Seperated with each newline.
</sup>

<br>

```lua
version: string = '3.0'
```
<sup>
Contains the first index of what <code>verFile</code> has, which should be the current GhostUtil version you have installed.
</sup>

<br>

```lua
stage: string = 'release'
```
<sup>
Contains the second index of what <code>verFile</code> has, which should be the current GhostUtil stage you have installed.
</sup>

<br>

```lua
logs: table<string> = { }
```
<sup>
Contains the logs that was passed through <code>debug.log</code>.
</sup>

<br>

```lua
checkForUpdates: boolean = true
```
<sup>
If GhostUtil should check for updates.
</sup>

---

### Methods

```lua
getCurrentVersion(): string
```
Fetches the currently installed GhostUtil version. 

**Returns:** `debug.version`.

<p align="center">─────────────────────────</p>

```lua
getCurrentStage(): string
```
Fetches the currently installed GhostUtil version stage. 

**Returns:** `debug.stage`.

<p align="center">─────────────────────────</p>

```lua
getLatest(index: number): string
```
Fetches the latest information from GhostUtil's GitHub. <br>
*<sub>(fetched from <a href="https://raw.githubusercontent.com/AlsoGhostglowDev/Ghost-s-Utilities/refs/heads/main/ghostutil/ghostutil.version"><b>here</b></a>)</sub>*

**Parameters:**
- `index`: The line number of where the target information is.

**Returns:** GhostUtil's latest version information of the given index.

<details><summary>View Example</summary>
<p>

```lua
-- fetches the latest GhostUtil version.
debug.getLatest(1)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getLatestVersion(): string
```
Fetches the latest GhostUtil version. <br>
*<sub>(Shortcut to <code>debug.getLatest(1)</code>)*

**Returns:** GhostUtil's current latest version.

<p align="center">─────────────────────────</p>

```lua
getLatestStage(): string
```
Fetches the latest GhostUtil stage. <br>
*<sub>(Shortcut to <code>debug.getLatest(2)</code>)*

**Returns:** GhostUtil's current latest stage.

<p align="center">─────────────────────────</p>

```lua
isOutdated(): boolean
```
Checks whether the currently installed GhostUtil version is outdated compared to the GitHub.

**Returns:** Returns `true` if outdated.

<p align="center">─────────────────────────</p>

```lua
warnOutdate(): void
```
Warns user to update their GhostUtil library if outdated. <br>
*<sub>(Intended for developer-only use)</sub>*

<p align="center">─────────────────────────</p>

```lua
exception(!exception: string, exceptionType: string, formattedText: table<dynamic>, ?func: string, !exceptionMsg: string, ?level: number): void
```
Throws a GhostUtil exception with the provided exception message.
*<sub>(Intended for developer-only use)</sub>*

- `exception` **(one-or-another)**: Reason for the exception that's about to be thrown. However, you can leave this as an empty string if you're planning to throw a custom exception.
> **List of available exceptions and their corresponding format**:
> - `'nil_param'`: Expected a value for parameter **%s**.  **(1)**
> - `'no_eq'`: Parameter **%s** can't be the same as **%s**!  **(2)**
> - `'no_eq_tbl'`: Values in table from parameter **%s** cannot be the same!  **(1)**
> - `'wrong_type'`: Expected **%s**, got **%s** instead.  **(2)**
> - `'less_len'`: Insufficient table length in parameter **%s**. <br>Expected length to be **%s**, got **%s** instead.  **(3)**
> - `'over_len'`: Too much elements in table in parameter **%s**. <br>Expected length to be **%s**, got **%s** instead.  **(3)**
> - `'missing_el'`: Missing element "**%s**" from **%s**.  **(2)**
> - `'unrecog_el'`: Unrecognized element "**%s**" from **%s**.  **(2)**
> - `'outdated'`: You're using an outdated version of GhostUtil (**%s**). <br>Please update to the latest version: **%s**.  **(2)**
- `exceptionType`: The exception type, can be `error`, `warning` or `deprecated`.
- `formattedText`: A table containing the text you want to replace the placeholder in the format to. The table's length must match the amount of placeholders in the given format, you can check how many in the list of available exceptions. 
- `func` **(optional)**: The function name that this exception originated from. Defaults to an empty string.
- `exceptionMsg` **(one-or-another)**: The custom exception message, if this is not `nil`, `exception` and `formattedText`'s will be ignored, else the formatted text is used instead. Defaults to an empty string.
- `level` **(optional)**: The level of the file information, fetches the top-level information by default. 

<details><summary>View Example</summary>
<p>

```lua
-- assuming this is in 'test.lua' on line 32
-- prints 'GHOSTUTIL ERROR: test.lua:32: myModule.printer: Expected a value for parameter "message".'
debug.exception('nil_param', 'error', {'message'}, 'myModule.printer')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
error(!exception: string, formattedText: table<dynamic>, ?func: string, !forcedMsg: string, level: number): void
```
Throws a GhostUtil error with the provided exception message. <br>
*<sub>(Shortcut to <code>debug.exception(.., 'error', {..}, .., .., ..)</code>, intended for developer-only use)</sub>*

**Parameters:**
- `exception` **(one-or-another)**: Reason for the exception, refer to **`debug.exception:1`**.
- `formattedText`: refer to **`debug.exception:3`**.
- `func` **(optional)**: The function name that this exception orginated from. Defaults to an empty string.
- `forcedMsg` **(one-or-another)**: The custom exception message, if this is not `nil`, `exception` and `formattedText`'s contents will be ignored, else the formatted text is used instead. Defaults to an empty string.
- `level`: **(optional)**: The level of the file information, fetches the top-level information by default.

<details><summary>View Example</summary>
<p>

```lua
-- maybe someone messed up the types.
local thing = '89' -- this was supposed to be a number, but it's a string

-- assuming this is in 'test.lua' on line 32
-- prints 'GHOSTUTIL ERROR: test.lua:32: myModule.fn: Expected number, got string instead.'
debug.error('wrong_type', {'number', type(thing)}, 'myModule.fn')

-- you can also do "myModule.fn:1" for the function name,
-- the "1" refers to what parameter was wrong and is throwing an exception.
-- this gives the user more information to what's causing the error.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
warning(!exception: string, formattedText: table<dynamic>, ?func: string, !forcedMsg: string, level: number): void
```
Throws a GhostUtil warning with the provided exception message. <br>
*<sub>(Shortcut to <code>debug.exception(.., 'warning', {..}, .., .., ..)</code>, intended for developer-only use)</sub>*

**Parameters:**
- `exception` **(one-or-another)**: Reason for the exception, refer to **`debug.exception:1`**.
- `formattedText`: refer to **`debug.exception:3`**.
- `func` **(optional)**: The function name that this exception orginated from. Defaults to an empty string.
- `forcedMsg` **(one-or-another)**: The custom exception message, if this is not `nil`, `exception` and `formattedText`'s contents will be ignored, else the formatted text is used instead. Defaults to an empty string.
- `level`: **(optional)**: The level of the file information, fetches the top-level information by default.

<details><summary>View Example</summary>
<p>

```lua
-- throws a custom warning message!:
-- assuming this is in 'test.lua' on line 32
-- prints 'GHOSTUTIL WARNING: test.lua:32: myModule.fn: You did something wrong.'
debug.warning('', {}, 'myModule.fn', 'You did something wrong.')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
log(msg: string, ?printLog: boolean): void
```
Stores the logged message in `debug.logs` for debugging purposes.

**Parameters:**
- `msg`: The log message.
- `printLog` **(optional)**: If it should print the logged message onto the screen, defaults to false. However, it can be bypassed by `debug.dev`.

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