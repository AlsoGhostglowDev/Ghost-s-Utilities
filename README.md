**Ghost's Utilities** *(GhostUtil)* is a large Lua library full of modules for all-in-one use containing functions of which you may find useful for executing common tasks in Psych Engine. <br>

It also adds support to backwards compatibility by adding newer reflect functions from **Psych Engine 1.0.0** to lower versions ranging from **0.6.3 to 0.7.3** with the **support from the <kbd>reflect</kbd> extension**. It also adds newer Psych Engine features like `startTween` and `runHaxeFunction` to **0.6.3**. <br>

The library is also equipped with the `outdate-handler.lua` module of which could automatically handle the **class pathing between 0.6.3 and 0.7.0 huge overhaul**. Added support is for functions like `addHaxeLibrary`, `setPropertyFromClass` and `getPropertyFromClass`. Although, it is only limited towards the changes made in the Psych Engine's Source Code and nothing from other changes from Flixel and other Haxelibs.<br>

Additionally, GhostUtil has easier methods on **adding shaders to cameras** (<kbd>shader.addCameraFilter</kbd>), manipulating the **game's application** with simple tweens (<kbd>window.startTween</kbd>) and more! There's also a simple-to-use **semi-advanced modcharting tool** for you chaotic modcharters out there who uses `Lua`.<br>

GhostUtil also adds the capability to make and add **community extensions** (as seen for GhostUtil's `reflect.lua` extension) for others to **integrate their own library into GhostUtil's environment**.

***

## Compatibility:

### Tested Psych Engine Versions:
- 0.6.3, 0.7.3 *(requires <kbd>reflect</kbd> extension)*
- 1.0.4 <br> 

*(These results are only tested from our limited unit tests, it may not be as accurate.)*

### Incompatible Psych Engine Versions:
- 0.7.1h
- below 0.6.3

***

## Contributors:
* [**GhostglowDev**](https://github.com/AlsoGhostglowDev)
* [**T-Bar**](https://github.com/TBar09)
* [**galactic_2005**](https://github.com/galactic2005)
* [**Meloomazy**](https://github.com/Meloomazy)
* [**Silver984**](https://github.com/silver984)
* [**Flain**](https://www.youtube.com/channel/UCQ-WPpDkLX3PdKlTTtAqcsw)
* [**Execute**](https://github.com/fl215)

***

## How to Install

> [!IMPORTANT]
> Before downloading, please check if the current Psych Engine version you're using is supported for GhostUtil usage.

<b>1.</b> To use GhostUtil, drag-n-drop the `ghostutil` folder into your `PsychEngine` folder.

<b>2.</b> Afterwards, drag-n-drop the `callbackhandler.lua` script into `mods/scripts`.

<b>3.</b> Next, to actually use GhostUtil inside your scripts, simply import one of the module using the `require` function.
> ```lua
> -- you can name the variable to your liking.
> -- replace "module" with the corresponding module name (e.g. util, color, modchart).
> local gmodule = require 'ghostutil.module'
> ```

## How to Use

> [!CAUTION]
> Some modules may only be available after `onCreate` is called in Psych Engine **0.6.3**

<b>1.</b> Import one of GhostUtil's module.
> ```lua
> local util = require 'ghostutil.util'
> ```

<b>2.</b> Call a method from the corresponding module.
> ```lua
> local util = require 'ghostutil.util'
> util.setPosition('dad', 100, 200) 
> ```
> *Result: `dad`'s positions is set to **(100, 200)***

***

## Information
**a**. **Documentation:** <br>
GhostUtil provides an extensive documentation for every function from each respective module.<br>
**Check it out here**: - [**`GhostUtil Docs`**]() *(Currently Unavailable)*.

**b**. **Issues:** <br>
If any errors were to occur while using GhostUtil, please check first to confirm if the error itself is **from** or **caused by** GhostUtil itself. Otherwise, the issue would be closed. <br>
For a better and faster response, you should give additional information as to how the error occured or what you last did to make it throw an error.

> [!WARNING]
> Before reporting any issues to the **Gamebanana / GitHub Issues / Lua Script Forum**, please do check the Wiki first for a more detailed documentation about GhostUtil's modules. 

**c**. **Bug Reports:** <br>
If any bugs is found within the utility, make sure to report it in the Github Issue section. I would greatly appreciate if you'd provide more information to give a better response/solution towards your problem. Sorry in advanced for the inconvinience. <br>

*Note that I will be closing issues that's caused in the aforementioned incompatible Psych Engine versions.*

---
<div style="text-align:center">
<sub><i>
a Lua Library made by GhostglowDev; for <a href='https://github.com/ShadowMario/FNF-PsychEngine'>Psych Engine</a> <br>
© 2025 <a href='https://github.com/AlsoGhostglowDev'>GhostglowDev</a> — <a href='https://github.com/AlsoGhostglowDev/Ghost-s-Utilities'>Ghost's Utilities</a> <br>
Licensed under the <a href='https://opensource.org/license/mit'>MIT License</a>.
</sub></i>
</div>