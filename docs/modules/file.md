## `file.lua`
*Utility for interacting with the file system.*

```lua
local file = require 'ghostutil.file'
```

---

### Methods

```lua
write(filePath: string, content: string): void
```
Writes onto the specified file with the given `filePath`.

**Parameters:**
- `filePath`: The path to the target file. (absolute)
- `content`: The new file content to write onto the file. (overwrite)

<details><summary>View Example</summary>
<p>

```lua
-- sets the content of the file "info.txt" to: "You are currently running GhostUtil!!" 
-- if "info.txt" had any contents before executing file.write, it will be overwritten by the contents passed into file.write.
file.write('info.txt', 'You are currently running GhostUtil!!')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
append(filePath: string, content: string): void
```
Appends onto the specified file with the given `filePath`. This would mean it'd write `content` at the end of the file instead of overriding it's contents.

**Parameters:**
- `filePath`: The path to the target file. (absolute)
- `content`: The content to append onto the file.

<details><summary>View Example</summary>
<p>

```lua
--[[
    let's assume that "info.txt" had this as the file content: [
        what a nice day.
        i just woke up..
    ]
]]

-- let's add a new line that says "hello world!".
file.append('info.txt', '\nhello world!')

--[[
    info.txt should look like this now: [
        what a nice day.
        i just woke up..
        hello world!
    ]
]]
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
read(filePath: string): string
```
Reads the specified file with the given `filePath`.

**Parameters:**
- `filePath`: The path to the target file to read. (absolute)

**Returns:** The file contents.

<details><summary>View Example</summary>
<p>

```lua
--[[
    assuming that "info.txt" had the content: [ 
        salmon is tasting great today,
        i love them code.
    ]
]]

-- let's try reading info.txt's contents.. 
file.read('info.txt')

--[[ 
    this should return the exact file content: [
        salmon is tasting great today,
        i love them code.
    ]
]] 
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
exists(filePath: string): boolean
```
Checks if the specified file with the given `filePath` exists.

> [!WARNING]
> Result might not be accurate in **Psych Engine 0.6.3** if ran before `onCreate` or outside a callback. <br>
> Using it in an appropriate callback instead is highly recommended.

**Parameters:**
- `filePath`: The path to the target file to check. (absolute)

**Returns:** If the file exists.

<details><summary>View Example</summary>
<p>

```lua
--[[
    assuming the file system looks like this:
    - assets/
    - mods/
    - PsychEngine.exe
    - info.txt
]]

file.exists('info.txt')
-- it exists, so this should return true.

file.exists('EVILinfo.txt')
-- this doesnt exist in the file system, so it returns false..
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
isDirectory(filePath: string): boolean
```
Checks whether the provided `filePath` leads to a directory or a normal file.

> [!CAUTION]
> This function is unavailable outside a callback in **Psych Engine 0.6.3**, <br>
> Please run it in an appropriate callback instead.

**Parameters:**
- `filePath`: The path to the target file to check. (absolute)

**Returns:** If the file is a directory.

<details><summary>View Example</summary>
<p>

```lua
-- naturally, "assets" is a folder, so this should return true.
file.isDirectory('assets')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
readDirectory(filePath: string): table<string>
```
Returns a table of file names that exists in the specified directory. <br>
*<sub>(This function already assumes that the `filePath` inputted is a directory. External checks may be needed.)</sub>*

> [!CAUTION]
> This function is unavailable outside a callback in **Psych Engine 0.6.3**, <br>
> Please run it in an appropriate callback instead.

**Parameters:**
- `filePath`: The path of the directory to read from. (absolute)

**Returns:** A table of file names in the directory.

<details><summary>View Example</summary>
<p>

```lua
--[[
    assuming this is the file system:
    - assets/
      | ...
    - mods/
      | - thing.txt
      | - todoList.txt
      | - keoiki.png
    - emptyFolder/
    - PsychEngine.exe
]]

file.readDirectory('mods')
-- this will return the following table: 
{
    'thing.txt',
    'todoList.txt',
    'keoiki.png'
} 

-- however, calling readDirectory on an empty folder returns an empty table ({ }).
file.readDirectory('emptyFolder')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
move(filePath: string, newPath: string): void
```
Moves the specified file in `filePath` to a new location given by `newPath`.

**Parameters:**
- `filePath`: The path of the target file to move. (absolute)
- `newPath`: The new location to move it to. (absolute)

<details><summary>View Example</summary>
<p>

```lua
--[[
    assuming this is the file system:
    - assets
      | ...
    - someFolder/
      | - supersecretplan.txt
    - mods/
      | - info.txt
      | - keoiki.png
    - PsychEngine.exe
]]

-- doing this will move "info.txt" file from the mods folder to the "someFolder" folder. 
file.move('mods/info.txt', 'someFolder')

--[[
    so afterwards, it should look like this:
    - assets
      | ...
    - someFolder/
      | - info.txt
      | - supersecretplan.txt
    - mods/
      | - keoiki.png
    - PsychEngine.exe
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