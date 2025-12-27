## `window.lua`
*Tools used for the game's application/window manipulation. **Use with caution.***

```lua
local window = require 'ghostutil.window'
```

---

### Fields

```lua
defaultDimensions = {
    width: int = 1280,
    height: int = 720
}
```
<sup>
Contains the default game's window dimensions.
</sup>

<br>

```lua
desktopDimensions = {
    -- not a constant, therefore it's defaulted to 0. 
    width: int = 0,
    height: int = 0
}
```
<sup>
Contains the current desktop's dimensions. The values are only usable after <code>onCreate</code>, else it will only return <kbd>0</kbd>. 
</sup>

---

### Methods

```lua
setProperty(property: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): dynamic
```
Sets the window's property directly to `value`. <br>
*<sub>(uses <code>helper.setProperty</code>)</sub>*

**Parameters:**
- `property`: The property to set, available properties can be referred here: [**`lime.ui.Window`**](https://api.haxeflixel.com/lime/ui/Window.html).
- `value`: The value to set the property to. 
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `allowInstances` **(optional)**: Allows usage of `instanceArg` for properties, disabled by default for optimization.

**Returns:** The passed `value`.

<details><summary>View Example</summary>
<p>

```lua
-- sets the window's X position to 100.
window.setProperty('x', 100)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getProperty(property: string, ?allowMaps: boolean): dynamic
```
Fetches the window's property directly.

**Parameters:**
- `property`: The property to fetch, available properties can be referred here: [**`lime.ui.Window`**](https://api.haxeflixel.com/lime/ui/Window.html).
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.

**Returns:** The fetched value.

<details><summary>View Example</summary>
<p>

```lua
-- assuming you didn't change the window title,
-- this will return "Friday Night Funkin': Psych Engine"
window.getProperty('title')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setPosition(x: number, y: number): void
```
Sets the window's position.

**Parameters:**
- `x`: The target X position.
- `y`: The target Y position.

<details><summary>View Example</summary>
<p>

```lua
-- sets the window's position to (X: 240, Y: 320)
window.setPosition(240, 320)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
screenCenter(?axes: string): void
```
Centers the current window at the given axis.

**Parameters:**
- `axes` **(optional)**: The axis the window should center at, defaults to `'xy'` <br>
*<sup>(can be <kbd>x</kbd>, <kbd>y</kbd> or <kbd>xy</kbd>)</sup>*

<details><summary>View Example</summary>
<p>

```lua
-- centers the window on the X axis.
window.screenCenter('x')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
resize(width: number, height: number): void
```
Resizes the window to the specified dimensions.

**Parameters:**
- `width`: The new window width. 
- `height`: The new window height.

<details><summary>View Example</summary>
<p>

```lua
-- resizes the window to half it's size
window.resize(
    window.getProperty('width') / 2,
    window.getProperty('height') / 2
)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
doTweenX(tag: string, value: number, ?duration: number, ?ease: string): void
```
Tweens the window's X position to the given `value`.

**Parameters:**
- `tag`: The tween's tag.
- `value`: The target X position.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`

<details><summary>View Example</summary>
<p>

```lua
-- tweens the window's X position to 100.
window.doTweenX('coolTween', 100, 2, 'expoInOut')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
doTweenY(tag: string, value: number, ?duration: number, ?ease: string): void
```
Just like `doTweenX`, instead this tweens the window's Y position instead.

**Parameters:**
- `tag`: The tween's tag.
- `value`: The target Y position.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`

<details><summary>View Example</summary>
<p>

```lua
-- tweens the window's Y position to 300.
window.doTweenY('coolTween', 300, 2, 'expoInOut')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
doTweenPosition(tag: string, x: number, y: number, ?duration: number, ?ease: string): void
```
Tweens the window's position to the specified values.

**Parameters:**
- `tag`: The tween's tag.
- `x`: The target X position.
- `y`: The target Y position.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`

<p align="center">─────────────────────────</p>

```lua
doTweenSize(tag: string, width: number, height: number, ?duration: number, ?ease: string): void
```
Tweens the window's size to the specified values.

**Parameters:**
- `tag`: The tween's tag.
- `width`: The target window width.
- `height`: The target window height.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `ease` **(optional)**: Determines the ease used on the tween. Refer to [**`FlxEase`**](https://api.haxeflixel.com/flixel/tweens/FlxEase.html). Defaults to `'linear'`

<details><summary>View Example</summary>
<p>

```lua
-- tweens the window's width and height to your desktop's dimensions.
window.doTweenSize('coolResize', window.desktopDimensions.width, window.desktopDimensions.height, 2, 'expoInOut')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
tweenToCenter(tag: string, ?axes: string, ?duration: number, ?options: TweenOptions): void
```
Tweens the window to the center of the given axis. <br>
*<sub>(uses <code>bcompat.startTween</code>)</sub>*

**Parameters:**
- `tag`: The tween's tag.
- `axes` **(optional)**: The axis the window should center at, defaults to `'xy'` <br>
*<sup>(can be <kbd>x</kbd>, <kbd>y</kbd> or <kbd>xy</kbd>)</sup>*
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `options` **(optional)**: The tween's options; Refer to [**`TweenOptions`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#tweenoptions).

<details><summary>View Example</summary>
<p>

```lua
-- tweens the window to the center.
window.tweenToCenter('tweener', 'xy', 2, {
    ease = 'quadIn'
})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
startTween(tag: string, values: directory<string, dynamic>, ?duration: number, ?options: TweenOptions): void
```
Creates a tween of the window supporting multiple values for each respective fields. <br>
*<sub>(uses <code>bcompat.startTween</code>)</sub>*

**Parameters:**
- `tag`: The tween's tag.
- `object`: The target object to tween.
- `values`: Directory containing values mapped to their corresponding field.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `options` **(optional)**: The tween's options; Refer to [**`TweenOptions`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#tweenoptions).

<sub>This tween is still cancelable through Psych's <code>cancelTween</code>.</sub>

<details><summary>View Example</summary>
<p>

```lua
-- tweens the window's width and x to 200 and 100 respectively.
window.startTween('tweener', {x = 100, width = 200}, 2, {
    ease = 'quadInOut'
})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setIcon(image: string): void
```
Sets the window's icon to the specified image.

**Parameters:**
- `image`: The image path. *(checks in `images`)*

<details><summary>View Example</summary>
<p>

```lua
-- assuming you have icon.png in mods/images/..
window.setIcon('icon')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
alert(title: string, message: string): void
```
Sends an alert to the user. <br>
<sub>For a more advanced use, check out <a href="https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/CPP"><b><code>cpp.makeMessageBox</code></b></a>.</sub>

**Parameters:**
- `title`: The alert's window title.
- `message`: The alert's message.

<details><summary>View Example</summary>
<p>

```lua
window.alert('Cool dude spotted', 'YOOO THIS GUY USES GHOSTUTIL!!')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setTitle(?title: string): void
```
Sets the current window's title.

**Parameters:**
- `title` **(optional)**: The new window title, defaults to `"Friday Night Funkin': Psych Engine"`.

<p align="center">─────────────────────────</p>

```lua
createWindow(tag: string, ?attributes: WindowAttributes): void
```
Creates a new window for the current application. <br>
*<sub>(This window does not automatically close. Use <code>window.closeWindow</code> to close it.)</sub>*

> [!WARNING]
> This function is exclusively for Psych Engine versions below 0.7.0.

**Parameters**:
- `tag`: The tag to store to later use with other functions like `setProperty`, etc.
- `attributes`: The window's attributes; Refer to [**`WindowAttributes`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#windowattributes).

<details><summary>View Example</summary>
<p>

```lua
-- WARNING: this only works in Psych Engine versions below 0.7.0
window.createWindow('coolWindow', {
    x = 100,
    y = 200,
    title = 'Cool Window'
})

-- you can change it's properties with setProperty..
setProperty('coolWindow.title', 'VERY Cool Window')

-- close it once you're done using it!
function onDestroy()
    window.closeWindow('coolWindow')
end
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
closeWindow(tag: string): void
```
Closes the custom window that corresponds to the given tag that was created with `createWindow`.

**Parameters:**
- `tag`: The custom window tag.

<p align="center">─────────────────────────</p>

```lua
close(): void
```
Exits the current window. <br>
*<sub>(Shortcut for <code>os.exit</code>.)</sub>*

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