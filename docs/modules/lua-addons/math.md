## `lua-addons/math.lua`
*An addon to Lua's standard math library.*

<sup>This addon can be declared with the name "<code>math</code>" since it does NOT override the Lua's standard math library.</sup>

```lua
local math = require 'ghostutil.lua-addons.math'
```

---

### Fields

```lua
math.epsilon = 1e-12
```
<sup>
Epsilon, two numbers that are compared with this small of a difference would be considered equal, used in <code>math.equals</code>.
</sup>

<br>

```lua
math.max_float = 1.79e308
```
<sup>
Maximum value of a floating-point number.
</sup>

<br>

```lua
math.max_int = 0x7FFFFFFF
```
<sup>
Maximum value of an integer.
</sup>

<br>

```lua
math.min_float = 4.94e-324
```
<sup>
Minimum value of floating-point number before it reaches 0.
</sup>

<br>

```lua
math.min_int = -0x7FFFFFFF
```
<sup>
Minimum value of an integer. 
</sup>

<br>

```lua
math.infinity = math.huge
```
<sup>
Lua's definition of infinity.
</sup>

<br>

```lua
math.negative_infinity = -math.huge
```
<sup>
The negative counterpart of <code>math.infinity</code>. 
</sup>

<br>

```lua
math.nan = 0/0
```
<sup>
Lua's definition of NaN (not a number).
</sup>

---

### Methods

```lua
lerp(a: number, b: number, ratio: number): number
```
Linear interpolation, a mathematical function that finds a point between two values (`a` and `b`) based on a the `ratio` value; a value between 0 and 1.  <br>

**Parameters:**
- `a`: The starting value.
- `b`: The end value.
- `ratio`: The interpolation factor, ranges from 0 to 1.

**Returns:** The end-product calculated.

<p align="center">─────────────────────────</p>

```lua
fpslerp(a: number, b: number, ratio: number): number
```
Similar to <code>math.lerp</code>, this function instead relies on the current game FPS. <br>

**Parameters:**
- `a`: The starting value.
- `b`: The end value.
- `ratio`: The interpolation factor, ranges from 0 to 1.

**Returns:** The end-product calculated with taking the game's FPS into account.

<p align="center">─────────────────────────</p>

```lua
isfinite(n: number): boolean
```
Checks if the given number is finite. Defined through when the passed value is not infinity and Not a Number (NaN).

**Parameters:**
- `n`: The number to check.

**Returns:** `true` if the number is finite.

<p align="center">─────────────────────────</p>

```lua
isnan(n: number): boolean
```
Checks if the given number is Not a Number (NaN). Defined through if the type itself a number but does not equal to itself.  <br>
*<sub>(Shortcut to <code>util.isnan</code>)</sub>*

**Parameters:**
- `n`: The number to check.

**Returns:** `true` if the number is Not a Number.

<p align="center">─────────────────────────</p>

```lua
invert(n: number): number
```
Swaps out the given number's sign.

**Parameters:**
- `n`: The number to invert.

**Returns:** The inverted number.

<p align="center">─────────────────────────</p>

```lua
ispositive(n: number): boolean
```
Checks if the given number is a positive.

**Parameters:**
- `n`: The number to check.

**Returns:** If the number is positive. <br>
**Information:** If the number passed is 0, `false` is returned.

<p align="center">─────────────────────────</p>

```lua
isnegative(n: number): boolean
```
Checks if the given number is negative.

**Parameters:**
- `n`: The number to check.

**Returns:** If the number is negative. <br>
**Information:** If the number passed is 0, `false` is returned.

<p align="center">─────────────────────────</p>

```lua
factorial(n: int): boolean
```
Returns the factorial of the given number.

**Parameters:**
- `n`: The integer to compute the factorial of.

**Returns:** The factorial of the given number.

<p align="center">─────────────────────────</p>

```lua
bound(n: number, min: number, max: number): number
```
Bounds the given number in a specific range set by `min` and `max` from going less/over the set limit. <br>
*<sub>(Aliases: <code>math.clamp</code>)</sub>*

**Parameters:**
- `n`: The number to bound.
- `min`: The minimum limit.
- `max`: The maximum limit.

**Returns:** The bounded number.

<p align="center">─────────────────────────</p>

```lua
floordecimal(n: number, ?decimals: number): number
```
Limits the decimals of the given number to the specified value.

**Parameters:**
- `n`: The number.
- `decimals` **(optional)**: The decimals the number should have, defaults to `2`.

**Returns:** The number.

<p align="center">─────────────────────────</p>

```lua
round(n: number): number
```
Rounds the given number to the nearest integer.

**Parameters:**
- `n`: The number to be rounded.

**Returns:** The rounded number.

<p align="center">─────────────────────────</p>

```lua
midpoint(a: number, b: number): number
```
Finds the midpoint between two points.

**Parameters:**
- `a`: The first point.
- `b`: The second point.

**Returns:** The midpoint of the given points.

<p align="center">─────────────────────────</p>

```lua
distance(x1: number, y1: number, x2: number, y2: number): number
```
Finds the distance between two points in a two-dimensional space.

**Parameters:**
- (`x1`, `y1`): The coordinates of the first point.
- (`x2`, `y2`): The coordinates of the second point.

**Returns:** The distance between two points.

<p align="center">─────────────────────────</p>

```lua
distance3(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): number
```
Finds the distance between two points in a three-dimensional space.

**Parameters:**
- (`x1`, `y1`, `z1`): The coordinates of the first point.
- (`x2`, `y2`, `z2`): The coordinates of the second point.

**Returns:** The distance between two points.

<p align="center">─────────────────────────</p>

```lua
dot(ax: number, ay: number, bx: number, by: number): number
```
Computes the dot product of two 2D vectors.

**Parameters:**
- (`ax`, `ay`): Components of the first vector.
- (`bx`, `by`): Components of the second vector.

**Returns:** The dot product of the two vectors.

<p align="center">─────────────────────────</p>

```lua
dot3(ax: number, ay: number, az: number, bx: number, by: number, bz: number): number
```
Computes the dot product of two 3D vectors.

**Parameters:**
- (`ax`, `ay`, `az`): Components of the first vector.
- (`bx`, `by`, `bz`): Components of the second vector.

**Returns:** The dot product of the two vectors.

<p align="center">─────────────────────────</p>

```lua
equals(a: number, b: number, ?diff: number): boolean
```
Checks if the two values (`a` and `b`) are equal to each other by using epsilon (or `diff`) for a more loose equal check than a literal equal-to operator. 

**Parameters:**
- `a`: The first value.
- `b`: The second value.
- `diff` **(optional)**: The minimum difference between the two numbers until it should be considered equal to each other. Defaults to <code>math.epsilon</code>.

<p align="center">─────────────────────────</p>

```lua
area(w: number, h: number): number
```
The area of the given dimensions.

**Parameters:**
- `w`: The width.
- `h`: The height.

**Returns:** The area based on the given values.

<p align="center">─────────────────────────</p>

```lua
volume(w: number, h: number, l: number): number
```
The volume of the given dimensions.

**Parameters:**
- `w`: The width.
- `h`: The height.
- `l`: The length.

**Returns:** The volume based on the given values.

<p align="center">─────────────────────────</p>

```lua
inbounds(n: number, min: number, max: number): boolean
```
Checks if the given number is in the bounds of the specified limit.

**Parameters:**
- `n`: The number to check.
- `min`: The minimum bound.
- `max`: The maximum bound.

**Returns:** `true` if the given number is in bounds.

<p align="center">─────────────────────────</p>

```lua
iseven(n: number): boolean
```
Checks if the passed number is even.

**Parameters:**
- `n`: The number to check.

**Returns:** `true` if even.

<p align="center">─────────────────────────</p>

```lua
isodd(n: number): boolean
```
Checks if the passed number is odd

**Parameters:**
- `n`: The number to check.

**Returns:** `true` if odd.

<p align="center">─────────────────────────</p>

```lua
boundedadd(n: number, a: number, min: number, max: number): number
```
Performs an arithmetic addition of `n` to `a` while keeping it in the given bounds.

**Parameters:**
- `n`: The number.
- `a`: The number to add to `n`.
- `min`: The minimum limit.
- `max`: The maximum limit.

**Returns:** The bounded number.

<p align="center">─────────────────────────</p>

```lua
samesign(a: number, b: number): number
```
Checks if the passed values both use the same sign. <br>
*<sub>(using <code>math.signof</code>)</sub>*

**Parameters:**
- `a`: The first value.
- `b`: The second value to compare.

**Returns:** `true` if both values has the same sign. 

<p align="center">─────────────────────────</p>

```lua
signof(n: number): number
```
Returns `-1` or `1` based on what sign `n` has.

**Parameters:**
- `n`: The number to check

**Returns:** `-1` if negative, `1` if positive or 0.

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