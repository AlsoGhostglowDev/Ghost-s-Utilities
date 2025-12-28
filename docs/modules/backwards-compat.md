## `backwards-compat.lua`
*Backwards Compatibility handler. Used to handle backwards compatibility between outdated versions of Psych Engine.*

*<sup>Be reminded that these versions only uses GhostUtil's counterpart of said function if it's not supported there; Else it'll fallback to the original Psych Engine function. If GhostUtil's version of a function were to bug out, please contact **@ghostglowdev** in Discord.</sup>*


```lua
local bcompat = require 'ghostutil.backwards-compat'
```

---

### Methods

```lua
startTween(tag: string, object: string, values: directory<string, dynamic>, ?duration: number, ?options: TweenOptions): void
```
Creates a tween of an object supporting multiple values for each respective fields. <br>
*<sup>(from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `tag`: The tween's tag.
- `object`: The target object to tween.
- `values`: Directory containing values mapped to their corresponding field.
- `duration` **(optional)**: Determines how long the tween will take, defaults to `1`.
- `options` **(optional)**: The tween's options; Refer to [**`TweenOptions`**](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/wiki/Structures#tweenoptions).

<sub>This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>0.7.0</kbd>.</sub>

<details><summary>View Example</summary>
<p>

```lua
-- tweens boyfriend's x position to 100 alongside his velocity.x to 200.
-- the tween runs for 2 seconds with the expoInOut ease.
bcompat.startTween('tweenTag', 'boyfriend', { x = 100, ['velocity.x'] = 200 }, 2, {
    ease = 'expoInOut',
    onComplete = 'coolFn'    
})

-- gets called when the tween is completed.
function coolFn(tag, object)
    -- debug prints "tweenTag" (tag) and "boyfriend" (object).
    debugPrint(tag)
    debugPrint(object)
end
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
runHaxeFunction(funcToRun: string, ?args: table<dynamic>): dynamic
```
Calls a function from the current `HScript` / `runHaxeCode` instance. <br>
*<sup>(from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `funcToRun`: The function to call.
- `args` **(optional)**: The arguments for the function, defaulted to an empty table.

**Returns:** The called function's return value if there's any.

<sub>This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>0.7.0</kbd>.</sub>

<details><summary>View Example</summary>
<p>

```lua
runHaxeCode([[
    function coolFn(arg:String) {
        game.addTextToDebug(arg, 0xFF00FF00);
    }
]])

bcompat.runHaxeFunction('coolFn', {'oh look, its a green debug text!!'})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setHealthBarColors(left: string, right: string): void
```
Sets the health bar's colors. <br>
*<sup>(from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `left`: The color to apply on the left side. Inputted as a string hexadecimal. 
- `right`: The color to apply on the right side. Inputted as a string hexadecimal.

<sub>This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>0.7.0</kbd>.</sub>

<details><summary>View Example</summary>
<p>

```lua
-- just like the old times where the opponent will have a red colored healthbar,
-- meanwhile the player will have a green one.
bcompat.setHealthBarColors('FF0000', '00FF00')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setTimeBarColors(left: string, right: string): void
```
Sets the time bar's colors. <br>
*<sup>(from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `left`: The color to apply on the left side. Inputted as a string hexadecimal. 
- `right`: The color to apply on the right side. Inputted as a string hexadecimal.

<sub>This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>0.7.0</kbd>.</sub>

<details><summary>View Example</summary>
<p>

```lua
-- it's my color scheme!!
bcompat.setTimeBarColors('08FF9C', '10201A')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
instanceArg(instanceName: string, ?classVar: string): string
```
Fetches the "instance string" of an instance to be used in reflection functions of which that accepts it.<br>
*<sup>(Shortcut to <code>helper.instanceArg</code>, from Psych Engine 0.7.2h)</sup>* <br>
*<sup>(reflection functions that accepts instance strings are <code>callMethod</code>, <code>callMethodFromClass</code>, <code>createInstance</code>, <code>setProperty</code>, <code>setPropertyFromGroup</code>, <code>setPropertyFromGroup</code> and <code>setVar</code>)</sup>*

**Parameters:**
- `instanceName`: The instance's name.
- `classVar` **(optional)**: What class the instance is from, defaults to `nil`.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- loads dad's graphic into my cool sprite
bcompat.callMethod('sprite.loadGraphicFromSprite', { bcompat.instanceArg('dad') })
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
callMethod(method: string, ?args: table<dynamic>): dynamic
```
Calls a method from PlayState's instance. <br>
*<sup>(Shortcut to <code>helper.callMethod</code>, from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `method`: The method to call.
- `args` **(optional)**: The arguments to use for said method, defaults to an empty table. <br>
*<sup>(You may need to use <code>{''}</code> instead for an empty table/argument in some versions.)</sup>*

**Returns:** The called method's return value if there's any.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- sets dad's position to (X: 200, Y: 300) 
bcompat.callMethod('dad.setPosition', {200, 300})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
callMethodFromClass(className: string, method: string, ?args: table<dynamic>): dynamic
```
Calls a method from a class. <br>
*<sup>(Shortcut to <code>helper.callMethodFromClass</code>, from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `className`: Class based on the source folder structure.
- `method`: The method to call from said class.
- `args` **(optional)**: The arguments to use for said method, defaults to an empty table. <br>
*<sup>(You may need to use <code>{''}</code> instead for an empty table/argument in some versions.)</sup>*

**Returns:** The called method's return value if there's any.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- loads up a youtube video on your default browser
bcompat.callMethodFromClass('backend.CoolUtil', 'browserLoad', {'https://www.youtube.com/watch?v=dQw4w9WgXcQ'})
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
createInstance(tag: string, className: string, ?args: table<dynamic>): dynamic
```
Creates an instance of the provided class with the specified arguments. The instance can later be used with other functions like `setProperty`. <br>
*<sup>(Shortcut to <code>helper.createInstance</code>, from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `tag`: The tag to save the variable as.
- `className`: Class based on the source folder structure.
- `args` **(optional)**: The arguments to use for the class' constructor, defaults to an empty table. <br>

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- creates a new character instance with tag "pico"
bcompat.createInstance('pico', 'objects.Character', {100, 200, 'pico-player', true})

-- adds pico to the game
bcompat.addInstance('pico', true)

-- modifying the instance's properties
setProperty('pico.alpha', 0.2)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
addInstance(tag: string, ?inFront: boolean): void
```
Adds the created instance to the game. <br>
*<sup>(Shortcut to <code>helper.addInstance</code>, from Psych Engine 0.7.0)</sup>*

**Parameters:**
- `tag`: The tag of the instance to add.
- `inFront` **(optional)**: If the instance should be infront of everything, defaults to `false`.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>0.7.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- creates a new character instance with tag "pico"
bcompat.createInstance('pico', 'objects.Character', {100, 200, 'pico-player', true})

-- adds pico to the game
bcompat.addInstance('pico', true)

-- modifying the instance's properties
setProperty('pico.alpha', 0.2)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setProperty(variable: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): void
```
Sets the property of the given variable in PlayState to `value`. <br>
*<sup>(Shortcut to <code>helper.setProperty</code>, instance support from Psych Engine 1.0)</sup>*

**Parameters:**
- `variable`: The variable to change.
- `value`: The value to set the property to. 
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `allowInstances` **(optional)**: Allows usage of `instanceArg` for properties, disabled by default for optimization.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- applies a sprite's shader to boyfriend
bcompat.setProperty('boyfriend.shader', bcompat.instanceArg('sprite.shader'), false, true)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setPropertyFromGroup(group: string, index: number, variable: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): void
```
Sets the property of the given group/array in PlayState to `value`. <br>
*<sup>(Shortcut to <code>helper.setPropertyFromGroup</code>, instance support from Psych Engine 1.0)</sup>*

**Parameters:**
- `group`: The variable's object group.
- `index`: The index to the variable's object.
- `variable`: The variable to change.
- `value`: The value to set the property to. 
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `allowInstances` **(optional)**: Allows usage of `instanceArg` for properties, disabled by default for optimization.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br><br>

<details><summary>View Example</summary>
<p>

```lua
-- sets the first note's multAlpha to 0.5.
bcompat.setPropertyFromGroup('unspawnNotes', 0, 'multAlpha', 0.5)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
setPropertyFromClass(className: string, variable: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): void
```
Sets the property of the variable in the provided class to `value`. <br>
*<sup>(Shortcut to <code>helper.setPropertyFromClass</code>, instance support from Psych Engine 1.0)</sup>*

**Parameters:**
- `className`: The classpath of where the variable is from.
- `variable`: The variable to change.
- `value`: The value to set the property to. 
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `allowInstances` **(optional)**: Allows usage of `instanceArg` for properties, disabled by default for optimization.

<sub>
This function only uses GhostUtil's alternative way if the current Psych Engine version is under <kbd>1.0.0</kbd>.
</sub> <br>

<details><summary>View Example</summary>
<p>

```lua
-- sets isPixelStage to true.

--[[
  Q: Why can't this be done in setProperty instead?
  A: isPixelStage is a static variable, only exists within the class itself.
]]
bcompat.setPropertyFromClass('states.PlayState', 'isPixelStage', true)
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