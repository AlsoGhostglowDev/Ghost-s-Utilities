## Ghost's Utilities Structures
This documentation lists the **custom table structures** that exists within GhostUtil that are used in some **module's methods** or exists as a **module's field**.

---

### `TweenOptions`:
```haxe
{
    ?type:String|Int,
    ?startDelay:Float,
    ?loopDelay:Float,
    ?ease:String,
    ?onUpdate:String,
    ?onStart:String,
    ?onComplete:String 
}
```
> The tween options used for tweening functions like `startTween`.

### `ColorChannels`:
```haxe
{
    // ranges from 0 to 1
    alpha:Int,

    // all of these ranges from 0 to 255
    red:Int,
    green:Int,
    blue:Int
}
```
> An object storing values of each respective color channels. Found returned from `color.extractChannels`. <br>
> *(from `ghostutil.color`)*

<p align="center">─────────────────────────</p>

### `ModFunctions`:
```lua
{
    SINE = math.sin,
    COSINE = math.cos,
    TAN = math.tan,
    LOG = math.log10,

    -- to be edited by users
    CUSTOM = math.sin
}
```
> The common modchart functions used for the certain modifiers. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `ScrollType`:
```lua
{
    UPSCROLL = 'up',
    DOWNSCROLL = 'down'
}
```
> Used to determine the current strum's scroll type. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `Point`:
```haxe
{
    x:Float|Dynamic,
    y:Float|Dynamic
}
```
> Used to either determine a point from the two-dimensional axis or get the appropriate property for the corresponding axis. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `WiggleMod`:
```haxe
{
    enabled:Bool,
    frequency:Point,
    phase:Point,
    magnitude:Point,
    offset:Point,
    func:Point
}
```
> Used to store the attributes of the wiggle modifier for modcharts. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `ShakeMod`:
```haxe
{
    enabled:Bool,
    magnitude:Point,
    func:Point
}
```
> Used to store the attributes of the shake modifier for modcharts. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `HiddenMod` & `SuddenMod`:
```haxe
{
    enabled:Bool,
    startStep:Int,
    startAlpha:Float,
    endAlpha:Float
}
```
> Used to store the attributes of the hidden/sudden modifier for modcharts. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `BoostMod` & `BrakeMod`:
```haxe
{
    enabled:Bool,
    startStep:Int,
    speed:Float
}
```
> Used to store the attributes of the boost/brake modifier for modcharts. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `StrumMod`:
```haxe
{
    enabled:Bool,
    scroll:ScrollType,
    position:Point,
    offset:Point,
    wiggleMod:WiggleMod,
    shakeMod:ShakeMod,
    hiddenMod:HiddenMod,
    suddenMod:SuddenMod,
    boostMod:BoostMod,
    brakeMod:BrakeMod,
    direction:Float,
    speed:Float
}
```
> Used to store the attributes of the strum's modifiers for modcharts. <br>
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `ModTweenData`:
```haxe
{
    index: number,
    mod: string,
    ?axis: string
}  
```
> Contains the data for a modifier tween.
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `ModScrollTweenData`:
```haxe
{
    index: number,
    downscroll: boolean
}  
```
> Contains the data for a modchart scroll tween.
> *(from `ghostutil.modchart`)*

<p align="center">─────────────────────────</p>

### `WindowAttributes`:
```haxe
{
    ?x:Float = 0,
    ?y:Float = 0,
    ?width:Int = 256,
    ?height:Int = 256,
    ?title:String = 'New Window',
    ?resizable:Bool = true,
    ?minimized:Bool = false,
    ?maximized:Bool = false,
    ?fullscreen:Bool = false,
    ?borderless:Bool = false,
    ?alwaysOnTop:Bool = false
}
```
> Contains attributes for creating a window. 
> All fields are optional. <br>
> *(from `ghostutil.window`)*

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