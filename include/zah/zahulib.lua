function particle_shape(shape, part_num, size)
    -- get the coordinates of the points of a shape
    local x_draw_cord = { }
    local y_draw_cord = { }
    for x,y in shape:gmatch("(-?[0-9.]+) +(-?[0-9.]+)") do
        table.insert(x_draw_cord, x)
        table.insert(y_draw_cord, y)
    end
--add the first point to the end of the table so it can wrap around to the first point at the last iteration(since it's a closed shape)
    x_draw_cord[#x_draw_cord+1] = x_draw_cord[1]
    y_draw_cord[#y_draw_cord+1] = y_draw_cord[1]
--the lengths of the side of the shape
    local distances = { }
    for i = 1, #x_draw_cord-1 do
        distances[i] = math.sqrt((x_draw_cord[i+1] - x_draw_cord[i])*(x_draw_cord[i+1] - x_draw_cord[i]) + (y_draw_cord[i+1] - y_draw_cord[i])*(y_draw_cord[i+1] - y_draw_cord[i]))
    end
--all the sides combined
    local length = 0
    for k=1,#distances do
        length = length + distances[k]
    end
--amount of particles per side for equal distribution
    local part_per_sides = { }
    for i=1,#distances do
        part_per_sides[i] = (distances[i]/length)*part_num
    end
--calculating the positions for the particles
    local x_coords = { }
    local y_coords = { }
    for i=1,#x_draw_cord-1 do
        for j=1,part_per_sides[i] do
            local la = j / (part_per_sides[i] + 1)
            table.insert(x_coords, ((1-la)*x_draw_cord[i]+(la)*x_draw_cord[i+1]))
            table.insert(y_coords, ((1-la)*y_draw_cord[i]+(la)*y_draw_cord[i+1]))
        end
    end

--get center of shape
    local origin_x = 0
    local origin_y = 0
    for i=1, #x_draw_cord-1 do
        origin_x = (origin_x + x_draw_cord[i])
        origin_y = (origin_y + y_draw_cord[i])
    end
    origin_x = origin_x / #x_draw_cord-1
    origin_y = origin_y / #y_draw_cord-1

--move particles to be centered around 0,0
    for i=1,#x_coords do
        x_coords[i] = x_coords[i] - origin_x
        y_coords[i] = y_coords[i] - origin_y
    end

--scale the drawing
    for i=1, #x_coords do
       x_coords[i] = x_coords[i] * size
       y_coords[i] = y_coords[i] * size
    end

    local temp_i = 1
    for i=1,#part_per_sides do
        table.insert(x_coords, temp_i, (x_draw_cord[i] - origin_x) * size)
        table.insert(y_coords, temp_i, (y_draw_cord[i] - origin_y) * size)
        temp_i = 1 + temp_i + part_per_sides[i]
    end

    return x_coords, y_coords
end


--function to pulse any tag between two values for a given frequency and duration
--recommended for shad / xshad / yshad, but can be useful for other tags that can be animated with \\t
function tagpulse(max,start,tag,value1,value2,frequency)
    local tagstring = ""
    local i = frequency
    for j=0,math.floor(max/i) do
        if j%2==0 then
            tagstring = tagstring.."\\t("..(j*i)+start..","..((j+1)*i)+start..",\\"..tag..value1..")"
        else
            tagstring = tagstring.."\\t("..(j*i)+start..","..((j+1)*i)+start..",\\"..tag..value2..")"
        end
    end
    return tagstring
end


return {
    particle_shape = particle_shape,
    tagpulse = tagpulse
}
