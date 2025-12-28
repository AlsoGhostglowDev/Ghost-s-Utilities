## `module-file.lua`
*Add a description here*

```lua
local module = require 'ghostutil.module'
```

---

### Fields
```lua
dictionaryExample = {
    salmon: string,
    foo: number
}
```
<sup>
Description 1
</sup>

<br>

```lua
enumExample = {
    ONE: 1,
    TWO: 2,
    THREE: 3
}
```
<sup>
Description 2
</sup>

<br>

```lua
arrayExample = {
    'thing', 'thing2',
    'if its too long',
    'move to another line'
}
```
<sup>
Description 3
</sup>

<br>

```lua
normalField: string = 'whatever' 
```
<sup>
Description 4
</sup>

<br>

```lua
otherField: number = 2
```
<sup>
Description 5
</sup>

---

### Methods

```lua
method(arg1: string, arg2: table<number>, arg3: dictionary<string, dynamic>, arg4: TweenOptions, ?arg5: number): void
```
Method's description. <br>
*<sup>(additional information if needed)</sup>*

**Parameters:**
- `arg1`: The arguments's description
- `arg2`: Table containing numbers <br>
*<sup>(additional information to the argument desc if needed)</sup>*
- `arg3`: Dictionary containing values mapped to a key
- `arg4`: The tween's options; Refer to [**`TweenOptions`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#tweenoptions).
- `arg5` **(optional)**: A number value, defaults to `0`

<sub>Editor's note or more additional information if it's not aligned with the concurrent method's description.</sub>

<p align="center">─────────────────────────</p>

```lua
method2(): string
```
OHHO OHHO HOOH HOHO OHOH Description. <br>
*<sup>(additional alieniki information)</sup>*

**Returns:** `':plink:'`

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