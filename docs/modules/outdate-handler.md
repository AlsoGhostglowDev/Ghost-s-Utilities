## `outdate-handler.lua`
*Utility for handling problems in outdated versions.*

```lua
local outdate = require 'ghostutil.outdate-handler'
```

---

### Fields
```lua
classes: dictionary<string, table<string>> = {
    -- example:
    -- ['actualClass'] = { 'package', 'legacyPath' }
    ['CoolUtil'] = {'backend', 'CoolUtil'},
    ['ChartingState'] = {'states.editors', 'editors.ChartingState'}
}
```
<sup>
A dictionary containing a table that has the package of the corresponding class and the legacy class path mapped to the actual class name.
</sup>

---

### Methods

```lua
resolveClass(class: string, ?legacy: boolean, ?psychExclusive: boolean, ?avoidWarn: boolean): string
```
Resolves a classpath between legacy versions and newer versions *(>0.7)*. 

> [!WARNING]
> This function only supports in-Psych only classes unless `psychExclusive` is enabled, of which will only return `class` back to you. Else, it'll return `nil`.

**Parameters:**
- `class`: The class name, the package passed will be ignored.
- `legacy` **(optional)**: Determines whether the function should return the legacy classpath or the newer classpath. Defaults to `version < '0.7'`.
- `psychExclusive` **(optional)**: Determines whether it should error (and return `nil`) if the provided `class` is not from one of Psych Engine's classes, defaults to `true`.
- `avoidWarn` **(optional)**: If the function should warn the user if the given class is unknown (isn't from Psych Engine). Defaults to `true`.

**Returns:** The classpath of `class` based on `legacy`'s value.

<details><summary>View Example</summary>
<p>

```lua
-- doing this in Psych Engine 0.7.0; returns: 'states.PlayState'
-- however,   in Psych Engine 0.6.3; returns: 'PlayState'
outdate.resolveClass('PlayState')

-- you can also force it to return the newer classpath by setting the second argument to false.
-- returns 'states.editors.ChartingState'
outdate.resolveClass('ChartingState', false)
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
addHaxeLibrary(libName: string, ?package: string, ?legacy: boolean, ?shouldWarn: boolean): void
```
Alternative addHaxeLibrary for handling different classpaths between versions.
*<sub>(uses <code>helper.addHaxeLibrary</code>)</sub>*

**Parameters:**
- `libName`: The library name.
- `package` **(optional)**: The package the library is from, defaults to an empty string.
- `legacy` **(optional)**: Determines whether the function should use the legacy classpath or the newer classpath. Defaults to `version < '0.7'`.
- `shouldWarn` **(optional)**: If it should warn the user if the library is not from Psych Engine. Defaults to `false`.

<p align="center">─────────────────────────</p>

```lua
setPropertyFromClass(className: string, variable: string, value: string, ?allowMaps: boolean, ?allowInstances: boolean, ?legacy: boolean): string
```
Sets the property of the variable in the provided class to `value`. <br>
*<sub>(uses <code>helper.setPropertyFromClass</code>)</sub>*

**Parameters:**
- `className`: The classpath of where the variable is from.
- `variable`: The variable to change.
- `value`: The value to set the property to. 
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `allowInstances` **(optional)**: Allows usage of `instanceArg` for properties, disabled by default for optimization.
- `legacy` **(optional)**: Determines whether the function should use the legacy classpath or the newer classpath. Defaults to `version < '0.7'`.

**Returns:** The passed `value`.

<p align="center">─────────────────────────</p>

```lua
getPropertyFromClass(className: string, variable: string, ?allowMaps: boolean, ?legacy: boolean): dynamic
```
Fetches the property of a variable in the provided class. <br>

**Parameters:**
- `className`: The classpath of where the variable is from.
- `variable`: The variable to fetch.
- `allowMaps` **(optional)**: Allows for map access in properties, disabled by default for optimization.
- `legacy` **(optional)**: Determines whether the function should use the legacy classpath or the newer classpath. Defaults to `version < '0.7'`.

**Returns:** The fetched value.

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