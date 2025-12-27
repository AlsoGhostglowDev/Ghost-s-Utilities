## `modchart.lua`
*A semi-complex modchart system equipped with simple common modifiers.*

```lua
local modchart = require 'ghostutil.modchart'
```

---

### Strum Modifiers
Here is a list of modifiers you can use for each respective strums. Each strums has it's own unique modifiers and can be resetted with `modchart.resetStrumModifiers`.

**General Modifiers:**
- `enabled`,
- `position` / `pos`,
- `offset`,
- `direction` *(note direction)*,
- `speed` *(scroll speed)*,

**Wiggle Modifier:** (`wiggleMod`):
- `enabled`,
- `frequency` *(speed)*,
- `phase` *(time position)*,
- `magnitude` *(distance)*,
- `offset` *(time offset)*,
- `func`

| Information | **Example 1**         | **Example 2**         |
|:------------|:---------------------:|:---------------------:|
|**Preview**  |<img src="https://files.catbox.moe/1p9t24.gif" width=200/>|<img src="https://files.catbox.moe/wt5c7f.gif" width=200/>|
| `frequency` | `{x: 5, y: 5}`        | `{x: 6, y: 12}`       |
| `magnitude` | `{x: 25, y: 25}`      | `{x: 50, y: 15}`      |
| `func`      | `{x: sine, y: cosine}`| `{x: sine, y: cosine}`|

<details><summary>View Example</summary>
<p>

```lua
modchart.toggle()
modchart.toggleStrums()

modchart.setModifier(index, 'wiggle.enabled', true)
modchart.setModifier(index, 'wiggle.frequency', 5, 'xy')
modchart.setModifier(index, 'wiggle.magnitude', 25, 'xy')
modchart.setModifier(index, 'wiggle.func', modchart.ModFunctions.COSINE, 'y')
```

</p>
</details>

<br>

**Shake Modifier:** (`shakeMod`):
- `enabled`,
- `magnitude` *(distance)*,
- `func`

| Information | **Example**           |
|:------------|:---------------------:|
|**Preview**  |<img src="https://files.catbox.moe/lzii5m.gif" width=200/>|
| `magnitude` | `{x: 3, y: 3}`        |

<details><summary>View Example</summary>
<p>

```lua
modchart.toggle()
modchart.toggleStrums()

-- replace the index with the strum index.
modchart.setModifier(index, 'shake.enabled', true)
modchart.setModifier(index, 'shake.magnitude', 3, 'xy')
```

</p>
</details>

<br>

**Hidden & Sudden Modifier:** (`hiddenMod` & `suddenMod`):
- `enabled`,
- `startStep`,
- `startAlpha`,
- `endAlpha`

*Note that these two modifiers aren't meant to be used with each other.*

| Information | **Hidden Modifier**   | **Sudden Modifier**   |
|:------------|:---------------------:|:---------------------:|
|**Preview**  |<img src="https://files.catbox.moe/3q9q6r.gif" width=200/>|<img src="https://files.catbox.moe/28t53t.gif" width=200/>|
| `startStep` |  3                    |  5                    |
| `startAlpha`|  1                    |  0                    |
| `endAlpha`  |  0                    |  1                    |

<details><summary>View Example</summary>
<p>

```lua
modchart.toggle()
modchart.toggleStrums()
for i = 0, 7 do 
    -- hidden mod
    modchart.setModifier(i, 'hidden.enabled', true)
    modchart.setModifier(i, 'hidden.startStep', 2)
    modchart.setModifier(i, 'hidden.endAlpha', 0.1)

    -- sudden mod
    modchart.setModifier(i, 'sudden.enabled', true)
    modchart.setModifier(i, 'sudden.startStep', 4)
    modchart.setModifier(i, 'sudden.endAlpha', 0.5)
end
```

</p>
</details>

<br>

**Boost & Brake Modifier:** (`boostMod` & `brakeMod`):
- `enabled`,
- `startStep`,
- `speed`

*Note that these two modifiers aren't meant to be used with each other.*

| Information | **Boost Modifier**    | **Brake Modifier**    |
|:------------|:---------------------:|:---------------------:|
|**Preview**  |<img src="https://files.catbox.moe/v9m5l3.gif" width=200/>|<img src="https://files.catbox.moe/32i6t0.gif" width=200/>|
| `startStep` |  5                    |  5                    |
| `speed`     |  2                    |  0.1                  |

*<sup>Boost's Preview may not be as visible, but it speeds up to <code>speed</code> at a certain point.</sup>*

<details><summary>View Example</summary>
<p>

```lua
modchart.toggle()
modchart.toggleStrums()
for i = 0, 7 do 
    -- boost mod
    modchart.setModifier(i, 'boost.enabled', true)
    modchart.setModifier(i, 'boost.speed', 2)

    -- brake mod
    modchart.setModifier(i, 'boost.enabled', true)
    modchart.setModifier(i, 'brake.speed', 0.1)
end
```

</p>
</details>

<br>

---

### Fields

```lua
ModFunctions: ModFunctions
```
<sup>
Refer to <a href='(TBA)'><b><code>ModFunctions</code></b></a>.
</sup>

<br>

```lua
ScrollType: ScrollType
```
<sup>
Refer to <a href='(TBA)'><b><code>ScrollType</code></b></a>.
</sup>

<br>

```lua
enabled: boolean
```
<sup>
The toggle switch for the modchart manager.
</sup>

<br>

```lua
strums: table<StrumMod>
```
<sup>
Refer to <a href='(TBA)'><b><code>StrumMod</code></b></a>. <br>
Contains the modifiers for each strums. Indices from 1 to 4 are opponent's strums respectively and indices from 5 to 8 are the player's strums respectively. 
</sup>

<br>

```lua
time: number
```
<sup>
The global time for the modchart manager.
</sup>

<br>

```lua
defaultStrumData: table<StrumMod>
```
<sup>
Refer to <a href='(TBA)'><b><code>StrumMod</code></b></a>. <br>
Contains the default strum modifiers for each respective strum. 
<b>Do not change this</b>.
</sup>

<br>

```lua
trackedTweens: dictionary<string, ModTweenData>
```
<sup>
Refer to <a href='(TBA)'><b><code>ModTweenData</code></b></a>.
</sup>

<br>

```lua
trackedScrollTweens: dictionary<string, ModScrollTweenData>
```
<sup>
Refer to <a href='(TBA)'><b><code>ModScrollTweenData</code></b></a>.
</sup>

<br>

---

### Methods

```lua
toggle(): void
```
Toggles the `modchart.enabled` value.

<p align="center">─────────────────────────</p>

```lua
toggleStrums(): void
```
Toggles the `enabled` modifier on every strums.

<p align="center">─────────────────────────</p>

```lua
getModifier(index: number, data: string): dynamic
```
Fetches the specified strum's modifier data.

**Parameters:**
- `index`: The strum index, ranges from 0 to 7.
- `data`: The modifier data to fetch.
<br>

**Returns:** The modifier's value.

<p align="center">─────────────────────────</p>

```lua
setModifier(index: number, data: string, value: dynamic, ?axis: string): void
```
Sets the specified strum's modifier data.

**Parameters:**
- `index`: The strum index, ranges from 0 to 7.
- `data`: The modifier data to set.
- `value`: The new value for the strum's modifier.
- `axis` **(optional)**: The axis, if needed. <br>
*<sup>(can be <kbd>x</kbd>, <kbd>y</kbd>, <kbd>xy</kbd>)</sup>*

<p align="center">─────────────────────────</p>

```lua
setDefaultOffsets(): void
```
Resets all the strums' position and offsets back to the default value.

<p align="center">─────────────────────────</p>

```lua
tweenModifier(tag: string, index: number, modifier: string, ?axis: string, value: number, ?duration: number, ?ease: string): void
```
Tweens the specified strum's modifier.

**Parameters:**
- `tag`: The tween's tag.
- `index`: The strum's index.
- `modifier`: The modifier to tween.
- `axis` **(optional)**: The axis, if needed. Keep it as `nil` if not needed. <br>
*<sup>(can be <kbd>x</kbd>, <kbd>y</kbd>, <kbd>xy</kbd>)</sup>*
- `value`: The end value for the modifier to tween at.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`.

<details><summary>View Example</summary>
<p>

```lua
-- turning off the shakeMod slowly.
-- replace index with something else.
modchart.tweenModifier('coolShakey', index, 'shake.magnitude', 'xy', 0, 3, 'cubeIn')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
cancelTween(tag: string): void
```
Cancels a GhostUtil modifier/scroll tween.

**Parameters:**
- `tag`: The tag of the tween to cancel.

<p align="center">─────────────────────────</p>

```lua
resetStrumModifiers(index: number): void
```
Resets the specified strum's modifiers back to the default values.

**Parameters:**
- `index`: The strum's index

<p align="center">─────────────────────────</p>

```lua
resetModifiers(): void
```
Resets all the strum's modifiers back to the default values.

<p align="center">─────────────────────────</p>

```lua
setTime(newTime: number): void
```
Sets a new time for `modchart.time`.

**Parameters:**
- `newTime`: The time to set it to.

<p align="center">─────────────────────────</p>

```lua
resetTime(): void
```
Resets `modchart.time` back to 0.

<p align="center">─────────────────────────</p>

```lua
update(deltaTime: number): void
```
Updates the strum's modifiers.
*<sub><b>Internal function, handled internally.</b></sub>*

**Parameters:**
- `deltaTime`: The amount of time in seconds that passed since last frame.

<p align="center">─────────────────────────</p>

```lua
updateNoteModifiers(deltaTime: number): void
```
Updates the each strums' note modifiers.
*<sub><b>Internal function, handled internally.</b></sub>*

**Parameters:**
- `deltaTime`: The amount of time in seconds that passed since last frame.

<p align="center">─────────────────────────</p>

```lua
tweenScroll(tag: string, isDownscroll: boolean, index: number, ?duration: number, ?ease: string, ?moveNotes: boolean)
```
Tweens the specified strum's scroll.

> [!IMPORTANT]
> This only works if `modchart.enabled` and the strum's modifier "`enabled`" is `true`.

**Parameters:**
- `tag`: The tween's tag.
- `isDownscroll`: If it should tween to downscroll, this value is inversed if downscroll is turned on.
- `index`: The strum's index.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`.
- `moveNotes` **(optional)**: If the function should also move the strums to their appropriate <kbd>y</kbd> position.

<details><summary>View Example</summary>
<p>

```lua
modchart.toggle()
modchart.toggleStrums()

for i = 0, 7 do 
    -- tweens the user's strum to downscroll.
    -- (or upscroll if the user has the downscroll option on.)
    modchart.tweenScroll('scrollDown'.. i, true, i, 4, 'expoInOut', true)
end
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