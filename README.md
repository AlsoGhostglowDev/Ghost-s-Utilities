# Ghost's Utilities

Ghost's Utilities or more known as GhostUtil is a module/addon to Psych Engine to make programming more easier and tidier.
GhostUtil provides a lot of unique variables and functions for you to mess around!

## 2.0 Contributors:
*These are the peoples who contributes to GhostUtil atleast once*
* [GhostglowDev](https://github.com/GhostglowDev)
* [T-Bar](https://github.com/TBar09)
* [galactic_2005](https://github.com/galactic2005)
* [Meloomazy / Laztrix](https://github.com/Meloomazy)
* [Apollo](https://github.com/apollooo7)
* [Flain](https://www.youtube.com/channel/UCQ-WPpDkLX3PdKlTTtAqcsw)

## Other Recommended Library:
* [PEModUtils](https://github.com/galactic2005/PEModUtils) by galactic_2005

## The Basics

### How do I use GhostUtil?
* Add the "ghostutil" folder to the main Psych Engine folder. (where the `.exe` is)

![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/076a2654-46fd-4231-b4ba-2512f4ee880c)

and then, drag-n-drop the `callbackhandler.lua` file to `mods/scripts`

![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/cf993438-85c4-447c-9cb0-0255ebf7a765)

* To use GhostUtil, you must import it's modules; use the `require` function on a variable.
Since we're using base lua functions, this is not needed to be in a function.
                   
![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/d2114b55-ad69-484d-bb8b-6135d544d671)

* Let's try messing with the script!
```lua
local math = require "ghostutil.lua-addons.math"
local game = require "ghostutil.Game"

function onCreate()
    luaDebugMode = true
    game.doTweenScale("tweenScale", "boyfriend", {2, 2.1}, "expoOut")
    game.doTweenPosition({"boyfriendcool", "boyfriendswag"}, "boyfriend", {
        game.getPosition("boyfriend").x - 100,
        math.boundto(game.getPosition("dad").y + 100, -100, 200)
    }, 2, "expoOut")
end
```
This does a tweens boyfriend's scale to 2x it's default size. It also tweens boyfriend's position!

`math.boundto` was to limit the coordinates to reach a certain number

### For more advanced informations:
**CHECK OUT THE [WIKI](https://github.com/GhostglowDev/Ghost-s-Utilities/wiki) FOR MORE FUNCTIONS.**

### Older Versions
**Psych Engine**:

* below 0.6.3:
Mostly because most of the lua functions that GhostUtil use doesn't exist.

 * 0.7.1h:
It breaks GhostUtil (mostly because of `runHaxeCode`); so use the latest version or 0.7.3 instead.

**GhostUtil**:

* below 2.0.0a:
When using the `Window` class, add `window.init()` before doing anything with the Window functions/variables
"window" in `window.init()` depends on what you set the variable to. If it's `wind` then `wind.init()`, etc.


* below 1.0.0:
Naming the variable `math` will break the script.
