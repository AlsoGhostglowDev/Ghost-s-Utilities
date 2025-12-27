## `backend/helper.lua`
*GhostUtil's backend helper utility used for resolving common problems/tasks.*

<sup>Intended for <b>developer use</b>.</sup>

```lua
local helper = require 'ghostutil.backend.helper'
```

---

### Fields

```lua
extensions: dictionary<string, module> = { }
```
<sup>
Contains the current active extensions.
</sup>

<br>

```lua
throwError: boolean = true
```
<sup>
Determines whether GhostUtil should error when the reflect extension isn't available when using a Psych Engine version below 1.0.
</sup>

<br>

---

### Methods

```lua
reflect(): module
```
Returns the current instance of reflect module if exists. <br>

**Returns:** The reflect module. `nil` is returned if it's not found.

<p align="center">─────────────────────────</p>

```lua
legacyAvailable(): boolean
```
Checks if the legacy version (<0.7) has Psych Engine functions available. <br>
*<sub>(Returns <code>true</code> after onCreate is called)</sub>*

**Returns:** `true` if Psych Engine functions are available; always returns `true` on versions above and 0.7.0.

<p align="center">─────────────────────────</p>

```lua
instanceArg(instance: string, ?class: string): string
```
Refer to [**`bcompat.instanceArg`**]()

<p align="center">─────────────────────────</p>

```lua
callMethod(method: string, ?args: table<dynamic>): dynamic
```
Refer to [**`bcompat.callMethod`**]()

<p align="center">─────────────────────────</p>

```lua
callMethodFromClass(class: string, method: string, ?args: table<dynamic>): dynamic
```
Refer to [**`bcompat.callMethodFromClass`**]()

<p align="center">─────────────────────────</p>

```lua
createInstance(tag: string, className: string, args: table<dynamic>): boolean 
```
Refer to [**`bcompat.createInstance`**]()

<p align="center">─────────────────────────</p>

```lua
addInstance(instance: string, ?front: boolean): void
```
Refer to [**`bcompat.addInstance`**]()

<p align="center">─────────────────────────</p>

```lua
setProperty(prop: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): dynamic
```
Refer to [**`bcompat.setProperty`**]()

<p align="center">─────────────────────────</p>

```lua
setPropertyFromClass(class: string, prop: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): dynamic
```
Refer to [**`bcompat.setPropertyFromClass`**]()

<p align="center">─────────────────────────</p>

```lua
setPropertyFromGroup(group: string, index: string, prop: string, value: dynamic, ?allowMaps: boolean, ?allowInstances: boolean): dynamic
```
Refer to [**`bcompat.setPropertyFromGroup`**]()

<p align="center">─────────────────────────</p>

```lua
connect(name: string): module
```
Connects to an existing or create a new instance of a GhostUtil extension if exists. This action adds the module (extension) to <kbd>helper.extensions</kbd>.

**Parameters:**
- `name`: The extension file name in `ghostutil/extensions/`. 

**Returns:** The module object.

<p align="center">─────────────────────────</p>

```lua
getCameraFromString(camera: string): string 
```
Fetches the camera from the given `camera` string, also supports custom cameras that's added through `createInstance`.

**Parameters:**
- `camera`: The camera name. <br>
*<sup>(Can be shorten like <kbd>hud</kbd>, <kbd>other</kbd>, etc., except custom cameras)</sup>*

> [!WARNING]
> GhostUtil might mistake your custom camera as one of Psych's camera if it has the word <code>'other'</code> or <code>'hud'</code>. If so, try changing the name to something else. Sorry for the inconvinience. 

**Returns:** The camera name. `camGame` is returned by default if camera is not found.

<p align="center">─────────────────────────</p>

```lua
getType(e: dynamic, ?structOverDict: boolean): string
```
A more "accurate" Lua's existing `type()`, being able to detect dictionaries for table types.

**Parameters:**
- `e`: The element to check.
- `structOverDict` **(optional)**: If it should return `struct` instead of `dictionary` for dictionary types.

**Returns:** `e`'s type.

<p align="center">─────────────────────────</p>

```lua
serialize(value: dynamic, t: string)
```
Serializes `value` to the desired type if it were to be written in Haxe. Commonly used for serializing Lua table/dictionary to Haxe's array, anonymous structure or map.

**Parameters:**
- `value`: The value to serialize.
- `t`: The type of `value`. <br>
*<sup>(can be <kbd>string</kbd>, <kbd>array/table</kbd>, <kbd>map/dictionary/dict</kbd>, <kbd>struct/structure/anonstruct</kbd>, <kbd>bool/boolean</kbd> or <kbd>function</kbd>)</sup>*

**Returns:** The serialized `value`. However, if `t` is invalid, `value` is returned unchanged.

<p align="center">─────────────────────────</p>

```lua
addHaxeLibrary(library: string, ?package: string): void
```
Does the same thing as Psych's `addHaxeLibrary` without triggering Psych Engine >1.0.0 deprecation warning. 

**Parameters:**
- `library`: The library name.
- `package` **(optional)**: The package the library is from, defaults to an empty string.

<p align="center">─────────────────────────</p>

```lua
hgetKeys(map: string): table<dynamic>
```
Fetches a map's keys. The map must be in the `variables` map or in the current PlayState instance *(`game`)* itself.

**Parameters:**
- `map`: The map to fetch the keys from.

**Returns:** `map`'s keys, if exists, fallbacks to an empty table if `nil`.

<p align="center">─────────────────────────</p>

```lua
getKeys(dict: dictionary<t, dynamic>): t 
```
Refer to [**`table.getkeys`**]()

<p align="center">─────────────────────────</p>

```lua
eqAny(val: dynamic, toCheck: table<dynamic>): boolean 
```
Checks if `val` is equal to any values of `toCheck`.

**Parameters:**
- `val`: The value to check.
- `toCheck`: The list of values to match with `val`.

**Returns:** `true` if `val` equals to one of `toCheck`'s values.

<p align="center">─────────────────────────</p>

```lua
isInt(number: number): boolean 
```
Checks if `number` is an integer.

**Parameters:**
- `number`: The number to check.

**Returns:** `true` if `number` is an integer.

<p align="center">─────────────────────────</p>

```lua
isFloat(number: number): boolean 
```
Checks if `number` is a floating-point number.
*<sub>(Shortcut to <code>not helper.isInt(number)</code>)</sub>*

**Parameters:**
- `number`: The number to check.

**Returns:**: `true` if `number` is a Float.

<p align="center">─────────────────────────</p>

```lua
isDict(tbl: table|dictionary): boolean 
```
Refer to [**`table.isdictionary`**]()

<p align="center">─────────────────────────</p>

```lua
findIndex(tbl: table<dynamic>, el: dynamic): number
```
Refer to [**`table.indexof`**]()

<p align="center">─────────────────────────</p>

```lua
findKey(dict: dictionary<t, dynamic>, value: dynamic): t 
```
Refer to [**`table.keyof`**]()

<p align="center">─────────────────────────</p>

```lua
existsFromTable(tbl: table|dictionary, value: dynamic): boolean 
```
Refer to [**`table.contains`**]()

<p align="center">─────────────────────────</p>

```lua
keyExists(dict: dictionary<t, dynamic>, key: t): boolean 
```
Refer to [**`table.containskey`**]()

<p align="center">─────────────────────────</p>

```lua
stringSplit(str: string, del: string): string 
```
Similar to Psych's `stringSplit` but adds support for legacy Psych (<0.7.0) to use a custom split function before onCreate is called.

**Information:** Refer to [**`string.split`**]()

<p align="center">─────────────────────────</p>

```lua
ternary(statement: boolean, a: dynamic, b: dynamic): dynamic 
```
Simple ternary in Lua.

**Parameters:**
- `statement`: Either true or false.
- `a`: The return value if `statement` is `true`.
- `b`: The return value if `statement` is `false` 

**Returns:** `a` is returned if `statement` is `true` else, `b` is returned.

<sub>
Q: "Why not use <code>statement and a or b</code> instead?" <br>
A: "That 'ternary' is actually just a trick that's widely used in Lua. It can often be faulty when dealing with booleans or nil values, i.e. <kbd>statement</kbd> is true but <kbd>a</kbd> is nil or false, this causes Lua to fallback to <kbd>b</kbd> even though it should be returning <kbd>a</kbd>."</sub> <br><br>

<p align="center">─────────────────────────</p>

```lua
bound(n: number, min: number, max: number): number
```
Refer to [**`math.bound`**]()

<p align="center">─────────────────────────</p>

```lua
rawsetDict(t: dictionary, path: string, value: dynamic): void
```
Refer to [**`table.rawsetdict`**]()

<p align="center">─────────────────────────</p>

```lua
rawgetDict(t: dictionary, path: string): dynamic
```
Refer to [**`table.rawgetdict`**]()

<p align="center">─────────────────────────</p>

```lua
getDictLength(t: dictionary): number
```
Refer to [**`table.getdictlength`**]()

<p align="center">─────────────────────────</p>

```lua
pack(value: dynamic, length: number): table<dynamic>
```
Packs `value` into a table `length` times.

**Parameters:**
- `value`: The value to pack.
- `length`: The amount of `value` should be packed into the table.

**Returns:** The packed table.

<p align="center">─────────────────────────</p>

```lua
fillTable(tbl: table<dynamic>, value: dynamic, length: number): table<dynamic>
```
Refer to [**`table.fill`**]()

<p align="center">─────────────────────────</p>

```lua
resolveNilInTable(tbl: table<dynamic>, fallbackValue: dynamic): table<dynamic>
```
Resolves `nil` values in `tbl`, replacing them with `fallbackValue` instead. <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure)</sub>*

**Parameters:**
- `tbl`: The table to resolve.
- `fallbackValue`: The value to replace `nil` values with.

**Returns:** The resolved table for chaining.

<p align="center">─────────────────────────</p>

```lua
resizeTable(tbl: table<dynamic>, length: number): table<dynamic>
```
Refer to [**`table.resize`**]()

<p align="center">─────────────────────────</p>

```lua
arrayComprehension(from: number, to: number, fn: number->dynamic): table<dynamic>
```
Refer to [**`table.arraycomp`**]()

<p align="center">─────────────────────────</p>

```lua
mapComprehension(keys: table<t1>, fn: t1->t2): dictionary<t1, t2>
```
Refer to [**`table.dictcomp`**]()

<p align="center">─────────────────────────</p>

```lua
resolveAlt(value: t|table<t>, length: number): table<t>
```
Resolves an alternative way for an `t-or-table<t>` argument. <br>

This was previously used in GhostUtil 2.0 when functions like <code>game.doTweenPosition</code> used to take `number` and `table<number>` simultaneously as one of it's values, whereas if the argument were to be a `number`, it'll make a `table<number>` with two *(which is the `length`)* of those given number, else it'll just stay as the passed `table<number>`.

**Parameters:**
- `value`: The passed value. If `table<t>` is passed, it will remain unchanged, else it'll create a `table<t>` containing `length` times the passed `value`.
- `length`: The target length, ignored if `value` is a table.

**Returns:** The resolved value.

<p align="center">─────────────────────────</p>

```lua
validate(params: table<dynamic>, types: table<string|table<string>>): boolean
```
Checks if the given parameters matches with the given types. <br>

This is used to validate multiple arguments that was passed through a function was given with the correct type by the user.

**Parameters:**
- `params`: Table containing the parameters to check.
- `types`: Table containing types that should match to the corresponding parameter. Multiple-types are also supported, use `table<string>` containing multiple types instead of the normal `string`.

**Returns:** `true` if all parameters matches their corresponding type.

<p align="center">─────────────────────────</p>

```lua
parseObject(obj: string): string
```
Parses the object tag to a referenceable object in Haxe. Checks the object in the current PlayState instance *(`game`)*, the `variables` map and "modchart" maps (<1.0.0).

> [!WARNING]
> This function may not be fully accurate, it may fallback to `game.object` instead.

**Parameters:**
- `obj`: The object name (tag).

**Returns:** The object reference. <br>
*<sup>(can be <kbd>game.object</kbd>, <kbd>getVar("object")</kbd> or <kbd>game.getLuaObject("object")</kbd>)</sup>*

<p align="center">─────────────────────────</p>

```lua
concat(t1: table, t2: table): table
```
Refer to [**`table.merge`**]()

<p align="center">─────────────────────────</p>

```lua
concatDict(d1: dictionary, d2: dictionary, ?override: boolean): dictionary
```
Refer to [**`table.mergedict`**]()

<p align="center">─────────────────────────</p>

```lua
isOfType(value: dynamic, t: string): boolean
```
Refer to [**`util.isOfType`**]()

<p align="center">─────────────────────────</p>

```lua
resolveDefaultValue(value: dynamic, fallback: dynamic): dynamic
```
Resolves for `nil` values that occurs on default values. This function may only be useful when you're working with booleans, but other than that, `value or fallback` should be safe to use.

**Parameters:**
- `value`: The passed value.
- `fallback`: The default value to use if `value` is `nil`.

**Returns:** `fallback` if `value` is `nil`, else `value` is returned.

<p align="center">─────────────────────────</p>

```lua
getTweenEaseByString(ease: string): string
```
Fetches the tween ease based on the given string.

**Parameters:**
- `ease`: The target ease.

**Returns:** The ease in `FlxEase` as a string, i.e. `'FlxEase.cubeOut'`. Returns `FlxEase.linear` if the ease not found. <br>
*<sup>(Refer to <a href="https://api.haxeflixel.com/flixel/tweens/FlxEase.html"><b><code>FlxEase</b></code></a>)<sup>*

<p align="center">─────────────────────────</p>

```lua
getTweenType(twnType: string|number): number
```
Fetches the tween type based on the given value.

**Parameters:**
- `twnType`: String of the tween's type or the abstract value (number).

**Returns:** The tween type in it's abstract value (number). Returns `8` *(oneshot)* by default if not found.

<p align="center">─────────────────────────</p>

```lua
objectExists(obj: string): boolean
```
Checks whether the given object exists in the `variables` map, as a lua object or in the current PlayState instance.

**Parameters:**
- `obj`: The object to check.

**Returns:** `true` if the given object passes one of the checks.

<p align="center">─────────────────────────</p>

```lua
variableExists(var: string): boolean
```
Checks whether the given variable exists in the `variables` map.

**Parameters:**
- `var`: The variable to check.

**Returns:** `true` if the variable exists.

<p align="center">─────────────────────────</p>

```lua
luaObjectExists(obj: string): boolean
```
Checks whether the given object exists as a lua object. This function is redundant on Psych Engine 1.0.0 and above as all "modchart" maps has been moved to the `variables` map instead. Consider using [**`helper.variableExists`**]() instead.

**Parameters:**
- `obj`: The object to check.

**Returns:** `true` if the object exists.

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