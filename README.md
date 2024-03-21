# Ghost's Utilities
![ghostutil2 1_noises](https://github.com/AlsoGhostglowDev/Ghost-s-Utilities/assets/159514284/27161772-75ce-474c-a5e3-85306e48e8a9)


GhostUtil (aka. Ghost's Utilities) is a library for Psych Engine with the objective to make programming easier. It provides a unique environment for you to mess around in.

## 2.0 Contributors:
*These are the people who contributed to GhostUtil atleast once*
* [GhostglowDev](https://github.com/AlsoGhostglowDev)
* [T-Bar](https://github.com/TBar09)
* [galactic_2005](https://github.com/galactic2005)
* [Meloomazy / Laztrix](https://github.com/Meloomazy)
* [Apollo](https://github.com/apollooo7)
* [Flain](https://www.youtube.com/channel/UCQ-WPpDkLX3PdKlTTtAqcsw)
* [Execute](https://github.com/fl215)

## Other Recommended Library:
* [PEModUtils](https://github.com/galactic2005/PEModUtils) by galactic_2005

## The Basics

### How do I use GhostUtil?
* Add the "ghostutil" folder to the main Psych Engine folder (where the `.exe` is).

![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/076a2654-46fd-4231-b4ba-2512f4ee880c)

* Next, drag-n-drop the `callbackhandler.lua` file to `mods/scripts`.

![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/cf993438-85c4-447c-9cb0-0255ebf7a765)

* To use GhostUtil, you must import it's modules; you must use the `require` function.
                   
![image](https://github.com/GhostglowDev/Ghost-s-Utilities/assets/108509756/d2114b55-ad69-484d-bb8b-6135d544d671)

* Now you can mess around in the GhostUtil environment!
```lua
local math = require "ghostutil.lua-addons.math"
local game = require "ghostutil.game"

function onCreate()
    luaDebugMode = true
    game.doTweenScale("tweenScale", "boyfriend", {2, 2.1}, "expoOut")
    game.doTweenPosition({"boyfriendcool", "boyfriendswag"}, "boyfriend", {
        game.getPosition("boyfriend").x - 100,
        math.boundto(game.getPosition("dad").y + 100, -100, 200)
    }, 2, "expoOut")
end
```

### For more advanced information:
**CHECK OUT THE [WIKI](https://github.com/GhostglowDev/Ghost-s-Utilities/wiki) FOR MORE FUNCTIONS.**

### Older Versions
**Psych Engine**:

* below 0.6.3:
Some of the functions GhostUtil utilizes don't exist.

 * 0.7.1h:
It breaks GhostUtil (mostly because of `runHaxeCode`);

**GhostUtil**:

* below 2.0.0a:
When using the `Window` class, add `window.init()` before doing anything with the Window class.


* below 1.0.0:
Naming the variable `math` will break the script.
