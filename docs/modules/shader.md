## `shader.lua`
*a Utility that specializes in handling shader-related functionalities.*

```lua
local shader = require 'ghostutil.shader'
```

---

### Fields
```lua
filters: dictionary<string, string> = { }
```
<sup>
Directory containing the active filters used in current cameras mapped to their corresponding tag.
</sup>

---

### Methods

```lua
fixShaderCoord(?forceFix: boolean): void
```
Fixes the shader's coordinates being incorrect or causing visual glitches that may occur when the game window is resized. This function only really needs to be ran once.

**Parameters:**
- `forceFix` **(optional)**: Forces the fix to be applied again, defaults to `false`.

<p align="center">─────────────────────────</p>

```lua
addCameraFilter(camera: string, filter: string, ?floats: dictionary<string, number>, ?tag: string): void
```
Pushes a new filter to the specified camera.

**Parameters:**
- `camera`: The camera to apply the filter to.
- `filter`: The filter to apply to the camera.
- `floats` **(optional)**: Dictionary containing float values mapped to their corresponding uniform identifier. 
- `tag`: **(optional)**: The shader's sprite tracker's tag. If not specified, it will use the name of the filter instead. This can be used to change the uniform values manually with `setShaderFloat`, etc.

<details><summary>View Example</summary>
<p>

```lua
-- assuming you had a fragment shader file named "chrom.frag" in your "shaders" folder.
--[[ 
    the "chrom" shader has 2 float uniform values of which are: 
    - intensity
    - distFactor

    you can set these float uniform values in the 3rd optional argument.
]]
shader.addCameraFilter('game', 'chrom', {
    intensity = 0.04,
    distFactor = 0.2
})
```

</p>
</details>


<p align="center">─────────────────────────</p>

```lua
removeCameraFilter(camera: string, tag: string, ?destroy: boolean): void
```
Removes the specified filter from the given camera.

**Parameters:**
- `camera`: The camera to remove the filter from.
- `tag`: The filter's sprite tracker tag. If you didn't set the tag in `addCameraFilter`, you'll just need to put in the filter name instead.
- `destroy` **(optional)**: If the filter's sprite tracker object should be destroyed, else it'll stay in memory. Defaults to `true`.

<details><summary>View Example</summary>
<p>

```lua
-- assuming you added a shader tagged "chrom" with addCameraFilter on the game camera.
-- to remove it, simply:
shader.removeCameraFilter('game', 'chrom')
```

</p>
</details>


<p align="center">─────────────────────────</p>

```lua
clearCameraFilters(camera: string): void
```
Clears all the filters from the given camera.

**Parameters:**
- `camera`: The camera to clear the filters from.

<p align="center">─────────────────────────</p>

```lua
tweenShaderFloat(tweenTag: string, tag: string, float: string, to: number, ?duration: number, ?options: TweenOptions): void
```
Tweens a shader's float uniform value. This also works with normal sprites with a shader applied from `setSpriteShader`.

**Parameters:**
- `tweenTag`: The tween's tag.
- `tag`: The filter's sprite tracker tag. If you didn't set the tag in `addCameraFilter`, you'll just need to put in the filter name instead. However, if this is just for a normal sprite, just simply put it's normal tag.
- `float`: The float's uniform identifier.
- `to`: The target end value.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `options` **(optional)**: The tween's options; Refer to [**`TweenOptions`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#tweenoptions).

<details><summary>View Example</summary>
<p>

```lua
-- tweens the chrom's shader float "intensity" to 0.06.
shader.tweenShaderFloat('coolTween', 'chrom', 'intensity', 0.06, 2, {
    ease = 'cubeIn'
})
```

</p>
</details>


<p align="center">─────────────────────────</p>

```lua
clearRuntimeShader(shaderName: string): void
```
Removes the specified shader from the `runtimeShaders` map. Enabling you to have a unique shader object without having to make a new fragment file just to have a unique value for each sprite with the same shader.

**Parameters:**
- `shaderName`: The shader's file name. 

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