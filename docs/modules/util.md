## `util.lua`
*The general purpose utility class. Serves as a utility for the game and other miscellaneous purposes.*

```lua
local util = require 'ghostutil.util'
```

---

### Methods

```lua
doTweenNumber(tag: string, a: number, b: number, ?duration: number, ?options: TweenOptions): void
```
Creates a number tween starting from `a` to `b` with the given duration and options.

**Parameters:**
- `tag`: The tween's tag.
- `a`: The value the tween should start from.
- `b`: The value the tween will end at.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `options` **(optional)**: The tween's options; Refer to [**`TweenOptions`**]().

**Information:** Calls [**`onNumberTween`**]() every number update. Use this to actually get the currently tweened value.

<details><summary>View Example</summary>
<p>

```lua
local veryCoolNumber = 14

-- increasing your number variable with a number tween.
util.doTweenNumber('coolTween', 14, 32, 3, {
    ease = 'expoOut'
})

-- actually settings the variable's value to the tweened value every time it updates.
function onNumberTween(tag, num)
    if tag == 'coolTween' then
        veryCoolNumber = num
    end
end
```

</p>
</details>


<p align="center">─────────────────────────</p>

```lua
doTweenScale(tag: string, var: string, values: table<number>, ?duration: number, ?ease: string): void
```
Tweens an object's scale to the given values. <br>

**Parameters:**
- `tag`: The tween's tag.
- `var`: The scalable object to tween.
- `values`: A table of two numbers corresponding to one respective axis. `[1]` for <code>scale.x</code> and `[2]` for <code>scale.y</code>
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`.

**Information:** Calls `onTweenCompleted` on completion.

<details><summary>View Example</summary>
<p>

```lua
-- tweens dad's scale to double their size.
util.doTweenScale('coolScale', 'dad', {2, 2}, 1, 'expoInOut')
```

</p>
</details>


<p align="center">─────────────────────────</p>

```lua
doTweenPosition(tag: string, var: string, values: table<number>, ?duration: number, ?ease: string): void
```
Tweens an object's position to the given values. <br>

**Parameters:**
- `tag`: The tween's tag.
- `var`: The object to tween.
- `values`: A table of two numbers corresponding to one respective axis. `[1]` for <kbd>x</kbd> and `[2]` for <kbd>y</kbd>
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`.

**Information:** Calls `onTweenCompleted` on completion.

<details><summary>View Example</summary>
<p>

```lua
-- tweens boyfriend's position to (X: 200, Y: 300)
util.doTweenPosition('coolPosition', 'boyfriend', {200, 300}, 1, 'expoInOut')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
pauseTween(tag: string): void
```
Pauses an active tween.

**Parameters:**
- `tag`: The tween's tag.

<p align="center">─────────────────────────</p>

```lua
resumeTween(tag: string): void
```
Resumes a paused tween.

**Parameters:**
- `tag`: The tween's tag.

<p align="center">─────────────────────────</p>

```lua
toboolean(value: dynamic): boolean
```
Converts any type of value into a boolean. <br>
*<sub>(Aliases: <code>toBoolean</code>, <code>toBool</code>)</sub>*

**Parameters:**
- `value`: The value to convert.

**Returns:** The converted boolean.
> If the **string** <code>value</code> is <kbd>'1'</kbd> or <kbd>'true'</kbd>, then `true` is returned. <br>
> Else, `false` is returned.

<p align="center">─────────────────────────</p>

```lua
isOfType(value: dynamic, type: string): boolean
```
Checks if the given value matches the given type. <br>
*<sub>(Shortcut to <kbd>helper.isOfType</kbd>)</sub>*

**Parameters:**
- `value`: The value to check.
- `type`: The matching type to check. <br>
*<sup>(can be <kbd>nil</kbd>, <kbd>string</kbd>, <kbd>number</kbd>, <kbd>boolean</kbd>, <kbd>function</kbd>, <kbd>userdata</kbd>, <kbd>thread</kbd> or <kbd>table</kbd>)</sup>*

**Returns:** If the value matches the given type.

<p align="center">─────────────────────────</p>

```lua
isnan(value: dynamic): boolean
```
Checks if the given value is NaN *(not a number)*. <br>
*<sub>(Aliases: <code>isNaN</code>)</sub>*

**Parameters:**
- `value`: The value to check.

**Returns:** If value is NaN.

<p align="center">─────────────────────────</p>

```lua
isnil(value: dynamic): boolean
```
Checks if the given value is nil. <br>
*<sub>(Aliases: <code>isNil</code>, <code>isnull</code>, <code>isNull</code>)</sub>*

**Parameters:**
- `value`: The value to check.

**Returns:** If value is nil.

<p align="center">─────────────────────────</p>

```lua
isbool(value: dynamic): boolean
```
Checks if the given value is a boolean. <br>
*<sub>(Aliases: <code>isBool</code>)</sub>*

**Parameters:**
- `value`: The value to check.

**Returns:** If value is a boolean.

<p align="center">─────────────────────────</p>

```lua
isstring(value: dynamic): boolean
```
Checks if the given value is a string. <br>
*<sub>(Aliases: <code>isString</code>)</sub>*

**Parameters:**
- `value`: The value to check.

**Returns:** If value is a string.

<p align="center">─────────────────────────</p>

```lua
istable(value: dynamic): boolean
```
Checks if the given value is a table. <br>
*<sub>(Aliases: <code>isTable</code>)</sub>*

**Parameters:**
- `value`: The value to check.

**Returns:** If value is a table.

<p align="center">─────────────────────────</p>

```lua
switch(case: dynamic, cases: dictionary<any, void->dynamic>): dynamic
```
Simple switch cases in Lua. Runs the function mapped to the key <code>"default"</code> if no other cases match. <br>

**Parameters:**
- `case`: The current case.
- `cases`: Dictionary of cases mapped to a function to execute corresponding to the given case.

**Returns:** The returned value from the executed function if there's any.

<details><summary>View Example</summary>
<p>

```lua
function onStepHit()
    -- prints "woah." at step 128.
    -- prints "that's sick!" at step 256.
    -- prints "pluh.." at every other step.
    util.switch(curStep, {
        [128] = function()
            debugPrint('woah.')
        end,
        [256] = function()
            debugPrint('that\'s sick!')
        end
        default = function()
            debugPrint('pluh..')
        end
    })
end

-- this would return '🦐'
util.switch('shrimp', {
    ['fish'] = function()
        return '🐟'
    end,
    ['shrimp'] = function()
        return '🦐'
    end
})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
makeGradient(tag: string, width: number, height: number, colors: table<number|string>, ?chunkSize: number, ?rotation: number, ?interpolate: boolean): void
```
Generates a solid gradient square as graphic for a sprite.

**Parameters:**
- `tag`: The object to apply the gradient.
- `width`: The width of the gradient graphic.
- `height`: The height of the gradient graphic.
- `colors`: A table of hexadecimal numbers, needs atleast 2 elements.
- `chunkSize` **(optional)**: The chunk size of the gradient. Increase the value if you're looking for an old-school look. Defaults to `1`.
- `rotation` **(optional)**: The gradient's angle rotation in degrees, defaults to `90`.
- `interpolate` **(optional)**: Uses RGB interpolation instead of linear RGB if `true` Defaults to `true`.

<details><summary>View Example</summary>
<p>

![how unpleasant...](https://static.wikia.nocookie.net/regretevator/images/0/08/Unpleasant_gradient_shows_up.png/revision/latest/scale-to-width/220?cb=20230818070901)

```lua
-- making the unpleasant gradient..
makeLuaSprite('gradient', nil, 100, 200)
util.makeGradient('gradient', 200, 400, {
    0x22D71D, 0x7A9374, 
    0xFD2EF6, 0xC24462, 
    0x9B5300
})
addLuaSprite('gradient')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
applyTextMarkup(tag: string, ?text: string, markerPair: dictionary<string, number|string>): void
```
Applies formats to text between marker characters. <br>
<sub><i>(<b>Note</b>: This will clear all text formats and return to the default format)</i></sub>

**Parameters:**
- `tag`: The text object's tag.
- `text` **(optional)**: The formatted text to apply.
- `markerPair`: Dictionary of different colors mapped to the corresponding marker character.

<details><summary>View Example</summary>
<p>

```lua
-- the making of a markup'd text. 
makeLuaText('coolText', '', 0, 100, 100)
util.applyTextMarkup('coolText', 'i am %red% or am i perhaps may be &gray&..', {
    ['%'] = 0xFF0000,
    ['&'] = 0x808080
})
setTextSize('coolText', 24)
addLuaText('coolText')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getHealthColor(character: string): number
```
Fetches the health color of the specified character.

**Parameters:**
- `character`: The character to fetch the health color from. <br>
*<sup>(can be <kbd>'dad'</kbd>, <kbd>'bf'</kbd> or <kbd>'gf'</kbd>)</sup>*

**Returns:** The health color in hexadecimal (number).

<p align="center">─────────────────────────</p>

```lua
getFps(): number
```
Fetches the current framerate.

**Returns:** The frames per second.

<p align="center">─────────────────────────</p>

```lua
getMemory(): number
```
Fetches the garbage collector's memory in bytes.

**Returns:** The GC memory usage.

<p align="center">─────────────────────────</p>

```lua
centerOrigin(object: string): void
```
Centers the origin of the specified object.

**Parameters:**
- `object`: The object's tag.

<p align="center">─────────────────────────</p>

```lua
setPosition(object: string, x: number, y: number): void
```
Sets the position of the specified object.

**Parameters:**
- `object`: The object's tag.
- `x`: The position on the <kbd>x</kbd> axis.
- `y`: The position on the <kbd>y</kbd> axis.
- 
<details><summary>View Example</summary>
<p>

```lua
-- sets gf's position to (X: 800, Y: 900)
util.setPosition('gf', 800, 900)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getPosition(object: string): Point
```
Fetches the position of the specified object.

**Parameters:**
- `object`: The object's tag.

**Returns:** The object's position in [**`Point`**]().

<details><summary>View Example</summary>
<p>

```lua
-- assuming boyfriend's position is (X: 100, Y: 200)
-- this will return 100.
util.getPosition('boyfriend').x 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setOrigin(object: string, x: number, y: number): void
```
Sets the origin of the specified object.

**Parameters:**
- `object`: The object's tag.
- `x`: The origin on the <kbd>x</kbd> axis.
- `y`: The origin on the <kbd>y</kbd> axis.

<p align="center">─────────────────────────</p>

```lua
getOrigin(object: string): Point
```
Fetches the origin of the specified object.

**Parameters:**
- `object`: The object's tag.

**Returns:** The object's origin in [**`Point`**]().

<p align="center">─────────────────────────</p>

```lua
setVelocity(object: string, x: number, y: number): void
```
Sets the velocity of the specified object.

**Parameters:**
- `object`: The object's tag.
- `x`: The velocity on the <kbd>x</kbd> axis.
- `y`: The velocity on the <kbd>y</kbd> axis.

<p align="center">─────────────────────────</p>

```lua
getVelocity(object: string): Point
```
Fetches the velocity of the specified object.

**Parameters:**
- `object`: The object's tag.

**Returns:** The object's velocity in [**`Point`**]().

<p align="center">─────────────────────────</p>

```lua
parseJSON(content: string): dictionary<string, dynamic>
```
Parses a JSON's content to a Lua dictionary. <br>
*<sup>(uses <a href='https://dkolf.de/dkjson-lua/'><b><code>dkjson.lua</code></b></a> by [David Kolf](https://dkolf.de/))</sup>*

**Parameters:**
- `content`: The JSON's content.

**Returns:** The corresponding dictionary to the JSON's data.

<details><summary>View Example</summary>
<p>

```lua
-- usually done with Psych's getTextFromFile or file.read to parse file JSON instead.
local rawJSON = parseJSON(getTextFromFile('characters/bf.json'))
-- prints: 350 
debugPrint(rawJSON.position.y)

-- you can also put in the JSON content manually:
-- returns "GhostUtil"
parseJSON('{ "using": "GhostUtil" }').using
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
stringifyJSON(data: dictionary<string, dynamic>, ?useIndent: boolean): string
```
Encodes the given JSON data from dictionary back to a JSON string. <br>
*<sup>(uses <a href='https://dkolf.de/dkjson-lua/'><b><code>dkjson.lua</code></b></a> by [David Kolf](https://dkolf.de/))</sup>*

**Parameters:**
- `data`: Dictionary containing a JSON data.
- `useIndent` **(optional)**: Enables indentation if `true`.

**Returns:** The encoded JSON string.

<details><summary>View Example</summary>
<p>

```lua
util.stringifyJSON({
    usingCodename = false,
    usingPsych = true,
    usingGhostUtil = true 
}, true)

--[[ 
    this would (supposedly) return: 
    {
        "usingCodename": false,
        "usingPsych": true,
        "usingGhostUtil": true
    }
]]  
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