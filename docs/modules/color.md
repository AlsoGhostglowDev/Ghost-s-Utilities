## `color.lua`
*A utility for handling things related to color management and manipulation.*

```lua
local color = require 'ghostutil.color'
```

---

### Fields
**Neutral Colors:**
```lua
WHITE = 0xFFFFFF
GRAY = 0x808080
BLACK = 0x000000
```

**Standard Colors:**
```lua
RED = 0xFF0000
BLUE = 0x0000FF
GREEN = 0x008000
PINK = 0xFFC0CB
MAGENTA = 0xFF00FF
PURPLE = 0x800080
LIME = 0x00FF00
YELLOW = 0xFFFF00
ORANGE = 0xFFA500
CYAN = 0x00FFFF
```

## Methods

```lua
getHexString(hex: number, ?digits: number): string
```
Converts a hexadecimal integer to a hexadecimal string.

**Parameters:**
- `hex`: The hexadecimal integer
- `digits` **(optional)**: The amount of digits the hexadecimal string should have. Excess digits will be padded on the left. Defaults to `6`. 

**Returns:** The converted hexadecimal; returns `'000000'` instead if `hex` was invalid.

<details><summary>View Example</summary>
<p>

```lua
-- returns "00FFABCC"
-- the "00" padded on the left was because the passed hexadecimal only contained 6 digits. 
color.getHexString(0xFFABCC, 8)

-- returns "AA112233"
color.getHexString(0xAA112233)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
rgbToHex(rgb: table<number>): number
```
Converts RGB values to a 24-bit hexadecimal integer.

**Parameters:**
- `rgb`: Table where indices 1 to 3 corresponds to red, blue, green values respectively.

**Returns:** The hexadecimal value.

<details><summary>View Example</summary>
<p>

```lua
-- returns 0xFF7D1B 
color.rgbToHex({255, 125, 27})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
argbToRGB(argb: number): number
```
Converts a 32-bit hexadecimal (`AARRGGBB`) to a 24-bit hexadecimal following the `RRGGBB` rule.

**Parameters:**
- `argb`: The 32-bit hexadecimal integer.

**Returns:** The 24-bit hexadecimal; returns `0x0` instead if `argb` was invalid.

<details><summary>View Example</summary>
<p>

```lua
-- returns 0xAABBCC
color.argbToRGB(0xFFAABBCC)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
rgbToARGB(rgb: number, ?alpha: number): number
```
Converts a 24-bit hexadecimal (`RRGGBB`) to a 32-bit hexadecimal following the `AARRGGBB` rule.

**Parameters:**
- `rgb`: The 24-bit hexadecimal integer
- `alpha` **(optional)**: The value of the color's alpha, ranges from 0 to 1. Defaults to `1`

**Returns:** The 32-bit hexadecimal; ; returns `0x0` instead if `rgb` was invalid.

<details><summary>View Example</summary>
<p>

```lua
-- returns 0x80AABBCC
-- the "80" is the alpha, and is the equivalent form of math.ceil(255 * 0.5) in hexadecimal.
color.rgbToARGB(0xAABBCC, 0.5)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
usingARGB(int: number): boolean
```
Checks if the hexadecimal integer uses the ARGB format.

**Parameters:**
- `int`: The hexadecimal integer.
  
**Returns:** `true` if `int` uses ARGB.

<details><summary>View Example</summary>
<p>

```lua
-- returns true
color.usingARGB(0xAABBCCDD)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
usingRGB(int: number): boolean
```
Checks if the hexadecimal integer uses the RGB format.


**Parameters:**
- `int`: The hexadecimal integer.
  
**Returns:** `true` if `int` uses RGB.

<details><summary>View Example</summary>
<p>

```lua
-- returns false
color.usingRGB(0xFFAABBCC)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
extractChannels(int: number): ColorChannels
```
Extracts the individual color channels *(alpha, red, green, blue)* from a hexadecimal integer. 

**Parameters:**
- `int`: The hexadecimal integer.
  
**Returns:** The color channels, refer to [**`ColorChannels`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#colorchannels). However, the `alpha` value will equal `0` if the given hexadecimal didn't have an alpha channel present.

<details><summary>View Example</summary>
<p>

```lua
--[[
    returns {
        alpha = 170,
        red   = 187,
        green = 204,
        blue  = 221
    }
]]
color.extractChannels(0xAABBCCDD)

-- the alpha channel isn't present,
-- so, accessing the alpha field here would just return 0.
color.extractChannels(0x11A6B2)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getAlpha(int: number): number
```
Extracts the alpha value from a hexadecimal integer. <br>
<sub>(Shortcut to <code>color.extractChannels(int).alpha</code>)</sub>

**Parameters:**
- `int`: The hexadecimal integer.

**Returns:** The alpha value. If the given hexadecimal didn't have an alpha channel present, it'll return `0` instead. Ranges from 0 to 1.

<p align="center">─────────────────────────</p>

```lua
getRed(int: number): number
```
Extracts the red value from a hexadecimal integer. <br>
<sub>(Shortcut to <code>color.extractChannels(int).red</code>)</sub>

**Parameters:**
- `int`: The hexadecimal integer.

**Returns:** The value of red's channel. Ranges from 0 to 255.

<p align="center">─────────────────────────</p>

```lua
getGreen(int: number): number
```
Extracts the green value from a hexadecimal integer. <br>
<sub>(Shortcut to <code>color.extractChannels(int).green</code>)</sub>

**Parameters:**
- `int`: The hexadecimal integer.

**Returns:** The value of green's channel. Ranges from 0 to 255.

<p align="center">─────────────────────────</p>

```lua
getBlue(int: number): number
```
Extracts the blue value from a hexadecimal integer. <br>
<sub>(Shortcut to <code>color.extractChannels(int).blue</code>)</sub>

**Parameters:**
- `int`: The hexadecimal integer.

**Returns:** The value of blue's channel. Ranges from 0 to 255.

<p align="center">─────────────────────────</p>

```lua
setColor(tag: string, color: number): void
```
Sets the color multiplier of a sprite. <br>
<sub>(Shortcut to <code>setProperty('tag.color', color)</code>)</sub>

**Parameters:**
- `tag`: The sprite tag.
- `color`: The target color; alpha channel is ignored.

<details><summary>View Example</summary>
<p>

```lua
-- sets boyfriend's color to a sunset-ish color
color.setColor('boyfriend', 0xFFDB8E)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setColorTransform(tag: string, ?multiplier: table<number>, ?offset: table<number>): void
```
Sets the color transform of a sprite. <br>
<sub>(Shortcut to <code>callMethod('tag.setColorTransform', {...})</code>)

**Parameters:**
- `tag`: The sprite tag
- `multiplier`: Table containing the red, green, blue and alpha multiplier value respectively. Those values that are `nil` will be replaced with 0. Excess values are voided until table's length is 4. 
- `offset`: Table containing the red, green, blue and alpha offset value respectively. Those values that are `nil` will be replaced with 0. Excess values are voided until table's length is 4.

<details><summary>View Example</summary>
<p>

```lua
-- sets dad's color transform to be like bad apple's full-white color.
color.setColorTransform('dad', {0, 0, 0, 1}, {255, 255, 255, 0})

-- to reset a sprite's colorTransform, just do:
color.setColorTransform('sprite', {1, 1, 1, 1}, {0, 0, 0, 0})
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