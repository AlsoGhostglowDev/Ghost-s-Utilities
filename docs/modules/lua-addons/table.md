## `lua-addons/table.lua`
*An addon to Lua's standard table library.*

<sup>This addon can be declared with the name "<code>table</code>" since it does NOT override the Lua's standard table library.</sup>

```lua
local table = require 'ghostutil.lua-addons.table'
```

---

### Methods

```lua
isdictionary(tbl: table|dictionary): boolean
```
Checks if the passed table is a dictionary. <br>
*<sub>(Shortcut to <code>helper.isDict</code>. Result may not be accurate)</sub>*

**Parameters:**
- `tbl`: The table to check.

**Returns:** `true` if the passed table is a dictionary.

<p align="center">─────────────────────────</p>

```lua
getkeys(dict: dictionary<t, dynamic>): table<t>
```
Fetches the keys in a dictionary. <br>
*<sub>(Shortcut to <code>helper.getKeys</code>. Aliases: <code>table.keys</code>)</sub>*

**Parameters:**
- `dict`: The dictionary to fetch the keys from.

**Returns:** Table containing the keys of the passed dictionary.

<p align="center">─────────────────────────</p>

```lua
indexof(tbl: table<dynamic>, el: dynamic): number
```
Fetches the index of the first element matching with `el` found in `tbl` <br>
*<sub>(Shortcut to <code>helper.findIndex</code>)</sub>*

**Parameters:**
- `tbl`: The table to check.
- `el`: The element to find.

**Returns:** The index of the first found `el` in `tbl`. Returns `0` if failed.

<p align="center">─────────────────────────</p>

```lua
keyof(dict: dictionary<t, dynamic>, el: dynamic): t
```
Fetches the key of the first element matching with `el` found in `dict`. <br>
*<sub>(Shortcut to <code>helper.findKey</code>)</sub>*

**Parameters:**
- `dict`: The dictionary to check.
- `el`: The element of the key to find.

**Returns:** The key of the first found `el` in `dict`. Returns `nil` if failed.

<p align="center">─────────────────────────</p>

```lua
contains(tbl: table|dictionary, el: dynamic): boolean
```
Checks if the passed table has `el` as one of it's values. <br>
*<sub>(Shortcut to <code>helper.existsFromTable</code>. Aliases: <code>table.exists</code>, <code>table.has</code>, <code>table.hasvalue</code>)</sub>*

**Parameters:**
- `tbl`: The table to check.
- `el`: The element to look for. 

**Returns:** `true` if `el` is one of `tbl`'s values.

<p align="center">─────────────────────────</p>

```lua
containskey(dict: dictionary<t, dynamic>, key: t): boolean
```
Checks if the passed dictionary has the corresponding `key`. <br>
*<sub>(Shortcut to <code>helper.keyExists</code>. Aliases: <code>table.keyexists</code>, <code>table.haskey</code>)</sub>*

**Parameters:**
- `dict`: The dictionary to check.
- `key`: The key to look for.

**Returns:** `true` if `key` is one of `dict`'s keys.

<p align="center">─────────────────────────</p>

```lua
rawsetdict(dict: dictionary, path: string, value: dynamic): void
```
Similar to Lua's <code>rawset</code> function, this sets the value of a dictionary with key <code>path</code> to <code>value</code> without invoking any metamethods, specifically bypassing the <code>__newindex</code> metamethod. <br>
*<sub>(This is an in-place function directly modifying <code>dict</code>'s structure. Shortcut to <code>helper.rawsetDict</code>)</sub>*

**Parameters:**
- `dict`: The target dictionary to set.
- `path`: The key to set, seperated with `.` for nested dictionaries.
- `value`: The value to set it to.

<p align="center">─────────────────────────</p>

```lua
rawgetdict(dict: dictionary, path: string): dynamic
```
Similar to Lua's <code>rawget</code> function, this fetches the value of a dictionary with key <code>path</code> without invoking any metamethods, specifically bypassing the <code>__index</code> metamethod. <br>
*<sub>(Shortcut to <code>helper.rawgetDict</code>)</sub>*

**Parameters:**
- `dict`: The target dictionary to fetch from.
- `path`: The key to set, seperated with `.` for nested dictionaries.

**Returns:** Fetches the value that corresponds to the given `path` in `dict`.

<p align="center">─────────────────────────</p>

```lua
getdictlength(dict: dictionary): number
```
Fetches the length of a dictionary. <br>
*<sub>(Shortcut to <code>helper.getDictLength</code>. Aliases: <code>table.getdictlen</code>)</sub>*

**Parameters:**
- `dict`: The dictionary to get the length from.

**Returns:** The passed dictionary's length.

<p align="center">─────────────────────────</p>

```lua
fill(tbl: table<dynamic>, value: dynamic, len: number): table<dynamic>
```
Fills the passed table with `value` until `tbl`'s length matches `len`. <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure. Shortcut to <code>helper.fillTable</code>)</sub>*

**Parameters:**
- `tbl`: The table to fill.
- `value`: The fill value.
- `len`: The target table length.

**Returns:** The filled table for chaining.

<p align="center">─────────────────────────</p>

```lua
resize(tbl: table<dynamic>, len: number): table<dynamic>
```
Resizes the passed table down to the given length. <br> <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure. Shortcut to <code>helper.resizeTable</code>)</sub>*

**Parameters:**
- `tbl`: The table to resize.
- `len`: The target length to resize to.

**Returns:** The resized table for chaining. 

<p align="center">─────────────────────────</p>

```lua
arraycomp(from: number, to: number, fn: number->dynamic): table<dynamic>
```
Array comprehension made in Lua. <br>
*<sub>(Shortcut to <code>helper.arrayComprehension</code>)</sub>*

**Parameters:**
- `from`: Starting index.
- `to`: End index. 
- `fn`: Function passing the index for the user to return the value to set for that index.

**Returns:** The newly made table.

<p align="center">─────────────────────────</p>

```lua
dictcomp(keys: table<t1>, fn: t1->t2): dictionary<t1, t2>
```
Map comprehension made in Lua. <br>
*<sub>(Shortcut to <code>helper.mapComprehension</code>)</sub>*

**Parameters:**
- `keys`: The keys that the dictionary should have.
- `fn`: Function passing the key for the user to return the value to map to that key.

**Returns:** The newly made dictionary.

<p align="center">─────────────────────────</p>

```lua
merge(t1: table<t>, t2: table<t>): table<t>
```
Concatenates `t1` with `t2` into one singular table. <br>
*<sub>(This is an in-place function directly modifying <code>t1</code>'s structure. Shortcut to <code>helper.concat</code>)</sub>*

**Parameters:**
- `t1`: The initial table.
- `t2`: The table to merge with.

**Returns:** The merged table for chaining. 

<p align="center">─────────────────────────</p>

```lua
mergedict(d1: dictionary<t1, t2>, d2: dictionary<t1, t2>, ?override: boolean): dictionary<t1, t2>
```
Concatenates `d1` with `d2` into one singular dictionary. <br>
*<sub>(This is an in-place function directly modifying <code>d1</code>'s structure. Shortcut to <code>helper.concatDict</code>)</sub>*

**Parameters:**
- `d1`: The initial dictionary.
- `d2`: The dictionary to merge with.
- `override` **(optional)**: Whether to override existing value of the same key from `d1` to `d2`'s value if there's any, defaults to `true`.

**Returns:** The merged dictionary for chaining.

<p align="center">─────────────────────────</p>

```lua
filter(tbl: table|dictionary, fn: dynamic->boolean): table|dictionary
```
Creates a new table by filtering the contents of `tbl` using `fn`.

**Parameters:**
- `tbl`: The table/dictionary to filter.
- `fn`: A function called for each key (or index).
It should return `true` to keep the value, or `false` to exclude it from the resulting table. 

**Returns:** The filtered table.

<p align="center">─────────────────────────</p>

```lua
pop(tbl: table<t>): t
```
Removes the last element of `tbl`. <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure.)</sub>*

**Parameters:**
- `tbl`: The table to pop.

**Returns:** The removed element.

<p align="center">─────────────────────────</p>

```lua
shift(tbl: table<t>): t
```
Removes the first element of `tbl`. <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure.)</sub>*

**Parameters:**
- `tbl`: The table to shift.

**Returns:** The removed element.

<p align="center">─────────────────────────</p>

```lua
reverse(tbl: table): table
```
Reverses the contents of `tbl`. <br>
*<sub>(This is an in-place function directly modifying <code>tbl</code>'s structure.)</sub>*

**Parameters:**
- `tbl`: The table to reverse.

**Returns:** The reversed table for chaining.

<p align="center">─────────────────────────</p>

```lua
clone(tbl: table|dictionary): table|dictionary
```
Makes a deep-copy of `tbl` without shared references. <br>
*<sub>(Aliases: <code>table.copy</code>)</sub>*

**Parameters:**
- `tbl`: The table to clone.

**Returns:** The cloned table/dictionary.

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