## `lua-addons/string.lua`
*An addon to Lua's standard string library.*

<sup>This addon can be declared with the name "<code>string</code>" since it does NOT override the Lua's standard string library. Additionally, methods in this addon can be treated with the OOP (Object-oriented Programming) syntax when used on strings.</sup>

```lua
local string = require 'ghostutil.lua-addons.string'
```

---

### Methods

```lua
split(*s: string, ?delimiter: string): table<string>
```
Splits the passed string into a string table of substrings based on the given delimiter. <br>

**Parameters:**
- `s` **(ignored on OOP)**: The string to split. 
- `delimiter` **(optional)**: The seperator. 

**Returns:** Table containing the substrings, the delimeter is not included in the string itself.

<p align="center">─────────────────────────</p>

```lua
shuffle(*s: string): string
```
Shuffles the passed string. <br>

**Parameters:**
- `s` **(ignored on OOP)**: The string to shuffle. 

**Returns:** The shuffled string.

<p align="center">─────────────────────────</p>

```lua
ltrim(*s: string): string
```
Removes the trailing spaces on the string's left end <br>

**Parameters:**
- `s`: **(ignored on OOP)**: The string to trim.

**Returns:** The trimmed string.

<p align="center">─────────────────────────</p>

```lua
rtrim(*s: string): string
```
Removes the trailing spaces on the string's right end. <br>

**Parameters:**
- `s`: **(ignored on OOP)**: The string to trim.

**Returns:** The trimmed string.

<p align="center">─────────────────────────</p>

```lua
trim(*s: string): string
```
Removes trailing spaces on a string from both ends. <br>
*<sub>(Shortcut for <code>string.ltrim(string.rtrim(s))</code>)</sub>*

**Parameters:**
- `s`: **(ignored on OOP)**: The string to trim.

**Returns:** The trimmed string.

<p align="center">─────────────────────────</p>

```lua
startswith(*s: string, startsWith: string): boolean
```
Checks if the passed string starts with the given string. <br>

**Parameters:**
- `s`: **(ignored on OOP)**: The string to check.
- `startsWith`: The starting string that the function should check. 

**Returns:** `true` if `s` starts with `startsWith`.

<p align="center">─────────────────────────</p>

```lua
endswith(*s: string, endsWith: string): boolean
```
Checks if the passed string ends with the given string. <br>

**Parameters:**
- `s`: **(ignored on OOP)**: The string to check.
- `endsWith`: The ending string that the function should check.

**Returns:** `true` if `s` ends with `endsWith`.

<p align="center">─────────────────────────</p>

```lua
contains(*s: string, pattern: string): string
```
Checks if the passed string contains the given pattern. <br>

**Parameters:**
- `s`: **(ignored on OOP)**: The string to check.
- `pattern`: The pattern it should check for.

**Returns:** `true` if `pattern` is found inside `s`.

<p align="center">─────────────────────────</p>

```lua
replace(*s: string, pattern: string, to: string): string
```
Replaces `pattern` found in `s` to `to`. <br>
*<sub>(Shortcut for <code>s:gsub(pattern, to)</code>)</sub>*

**Parameters:**
- `s`: **(ignored on OOP)**: The string to compute.
- `pattern`: The pattern to be replaced.
- `to`: The value to replace `pattern` with.

**Returns:** The string after `pattern` is replaced with `to`.

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