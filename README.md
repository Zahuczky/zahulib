# Usage
Put the `zahulib.lua` file into your `aegisub/automation/include/zah` folder. If it doesn't exist, create it. <br>
You can load the library by placing `zahu = _G.require("zah.zahulib")` in a `code once` line at the top of your ass file.<br>
Now the variable `zahu` is a table containing the functions below.<br>
# Functions
## `zahu.particle_shape` 
```lua
zahu.particle_shape(shape,number_of_particles,size) -> table, table
```
<br> 
This function can be used with looped lines, and is generating two tables with the correspinding x and y coordinates of particles, that will construct the given shape.<br>
Example:<br>

```lua
code        x_coords, y_coords = zahu.particle_shape("m 0 0 l 200 0 200 200 0 200",100,1)
```
```lua
template line notext    !retime("line",0,0)!!maxloop(#x_coords)!{\an7\pos(!x_coords[j]!,!y_coords[j]!)\p1}m 1 0 b 1 0.55 0.55 1 0 1 -0.55 1 -1 0.55 -1 0 -1 -0.55 -0.55 -1 0 -1 0.55 -1 1 -0.55 1 0
```
`shape:     "m 0 0 l 200 0 200 200 0 200"` is the shape in an ass vector format,<br>
`number_of_particles:    100` is the number of particles it will contruct the shape from,<br>
`size:   1` is a scaling of 'by 1', which will make the drawing appear exactly the same size your original drawing. `0.5` will make it half the size, `2` will make it double the size, it can be any number.<br>
`m 1 0 b 1 0.55 0.55 1 0 1 -0.55 1 -1 0.55 -1 0 -1 -0.55 -0.55 -1 0 -1 0.55 -1 1 -0.55 1 0` in the template line is a small circle shape, suitable for particles, but you can use any shape/character. <br><br>
You can use these coordinates in you template line for `\an7\pos(!X_coords[j]!,!y_coords[j]!)` and it will draw the particles in a manner, where `\pos(0,0)` is the geometrical center of the shape.<br>
Recommended usage is giving some amount of offset to your coordinates, which will be used as the center of the shape, like `\pos(!$center+X_coords[j]!,!$middle+y_coords[j]!`
<br>
<br>
You **have to** loop your template line with `!maxloop(#x_coords)!` because the actual number of particle positions calculated might not match the `number_of_particles` argument you gave, if your amount of particles can't be divided perfectly evenly throughout the sides of your shape.<br>
If you were to loop by the same number, you might end up with loops where there is no solution, and `\pos(!X_coords[j]!,!y_coords[j]!)` is going to be put in your line, which will render as `\pos(0,0)`<br>
<br>
Currently this function doesn't support complex drawing commands, such as `m` or `b` or `l`, so it can't draw splines or "lift the pen." <br>
<br>
## `zahu.tagpulse` 
```lua
zahu.tagpulse(max,start,tag,value1,value2,frequency) -> string
```
This function can generate a string that pulses between two values with `\t` transforms. <br>
Can be used with any tag that can be animated by `\t`.<br>
Example:<br>
```lua
template line    !retime("line",0,0)!{\pos($center,$middle)!zahu.tagpulse($ldur,0,"xshad",1,20,50)!}
```
This will generate the following string
```
\t(0,50,\xshad1)\t(50,100,\xshad20)\t(100,150,\xshad1)\t(150,200,\xshad20)\t(200,250,\xshad1)\t(250,300,\xshad20)\t(300,350,\xshad1)\t(350,400,\xshad20)\t(400,450,\xshad1)\t(450,500,\xshad20)...
```
until the time reaches `max`.
