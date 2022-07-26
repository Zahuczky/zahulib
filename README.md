# Usage
Put the `zahulib.lua` file into your `aegisub/automation/include/zah`. If it doesn't exist, create it. <br>
You can load the library by placing `zahu = _G.require("zah.zahulib")` in a `code once` line at the top of your ass file.<br>
Now the variable `zahu` is a table containing the functions below.<br>
# Functions
### `zahu.particle_shape` 
```
zahu.particle_shape(shape,number_of_particles,size) -> table, table
```
<br> 
This function can be used in looped lines, and is generating two tables with the correspinding x and y coordinates of the shape.<br>
Example:<br>

```
code        x_coords, y_coords = zahu.particle_shape("m 0 0 l 200 0 200 200 0 200",100,1)
```
```
template line notext    !retime("line",0,0)!!maxloop(#x_coords)!{\an7\pos(!x_coords[j]!,!y_coords[j]!)\p1}m 1 0 b 1 0.55 0.55 1 0 1 -0.55 1 -1 0.55 -1 0 -1 -0.55 -0.55 -1 0 -1 0.55 -1 1 -0.55 1 0
```
`"m 0 0 l 200 0 200 200 0 200"` is the shape in an ass vector format,<br>
`100` is the number of particles it will contruct the shape from,<br>
`1` is a scaling of 'by 1', which will make the drawing appear exactly the same size your original drawing. `0.5` will make it half the size, `2` will make it double the size.<br>
`m 1 0 b 1 0.55 0.55 1 0 1 -0.55 1 -1 0.55 -1 0 -1 -0.55 -0.55 -1 0 -1 0.55 -1 1 -0.55 1 0` in the template line is a small circle shape, suitable for particles. <br><br>
You can use these coordinates in you template line for `\an7\pos(!X_coords[j]!,!y_coords[j]!)` and it will draw the particles in a manner, where `\pos(0,0)` is the geometrical center of the shape.<br>
Recommended usage is giving some amount of offset to your coordinates, which will be used as the center of the shape, like `\pos(!$center+X_coords[j]!,!$middle+y_coords[j]!`
<br>
<br>
You **have to** loop your template line with `!maxloop(#x_coords)!` because the actual number of particle positions calculated might not match the `number_of_particles` argument you gave, if your amount of particles can't be divided perfectly evenly throughout the sides of your shape.<br>
If you were to loop by the same number, you might end up with loops where there is no solution, and `\pos(!X_coords[j]!,!y_coords[j]!)` is going to be put in your line, which will render as `\pos(0,0)`<br>
<br>
Currently this function doesn't support complex drawing commands, such as `m` or `b` or `l`, so it can't draw splines or "lift the pen."
