## `web.lua`
*a Tool for interacting with the web.*

```lua
local web = require 'ghostutil.web'
```

---

### Methods

```lua
getDataFromUrl(url: string): string
```
Fetches data from the specified URL. <br>
*<sup>(Aliases: <code>getDataFromWeb</code>, <code>getDataFromWebsite</code>)</sup>*

**Parameters:**
- `url`: The URL of the target website to fetch the data from.

**Returns:** The fetched website's data in string ***if available***.

<details><summary>View Example</summary>
<p>

```lua
-- trying to fetch Psych Engine's current version:
-- returns "1.0.4"
web.getDataFromUrl('https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/refs/heads/main/gitVersion.txt')
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
loadBrowser(url: string): void
```
Opens the website using user's default browser with the given URL. <br>
*<sup>(Aliases: <code>loadURL</code>)</sup>*

**Parameters:**
- `url`: The URL of the website to open.

<details><summary>View Example</summary>
<p>

```lua
-- this will try to load YouTube on your default browser.
web.loadBrowser('https://youtube.com')
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