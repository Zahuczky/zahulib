local function coords_from_shape(shape)
    local coords = { }
    for x,y in shape:gmatch("(-?[0-9.]+) +(-?[0-9.]+)") do
        table.insert(coords, {x, y})
    end
    return coords
end

local function get_center(corners)
    local origin_x = 0
    local origin_y = 0
    for _, corner in ipairs(corners) do
        origin_x = (origin_x + corner)
        origin_y = (origin_y + corner)
    end
    origin_x = origin_x / #corners
    origin_y = origin_y / #corners

    return origin_x, origin_y
end

function particle_shape(shape, part_num, size)
    local draw_coords = coords_from_shape(shape)

    -- calculate center before duplicating final point
    local origin_x, origin_y = get_center(draw_coords)

    -- add the first point to the end of the table so it can wrap around to the first point at the last iteration(since it's a closed shape)
    draw_coords[#draw_coords+1] = draw_coords[1]

    local side_lengths = { }
    local total_length = 0
    for i = 1, #draw_coords-1 do
        local x1, y1 = table.unpack(draw_coords[i])
        local x2, y2 = table.unpack(draw_coords[i+1])
        local l = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
        total_length = total_length + l
        side_lengths[i] = l
    end

    --amount of particles per side for equal distribution
    local part_per_sides = { }
    for i=1,#side_lengths do
        part_per_sides[i] = math.floor((side_lengths[i]/total_length)*part_num + 0.5)
    end

    --calculating the positions for the particles
    local x_coords = { }
    local y_coords = { }
    for i, parts_on_this in ipairs(part_per_sides) do
        -- start and end of current side
        local x1, y1 = table.unpack(draw_coords[i])
        local x2, y2 = table.unpack(draw_coords[i+1])

        for j=1, parts_on_this do
            local la = j / parts_on_this
            table.insert(x_coords, ((1-la)*x1 + (la)*x2))
            table.insert(y_coords, ((1-la)*y1 + (la)*y2))
        end
    end

    -- center particles around 0,0 and scale the drawing
    for i=1,#x_coords do
        x_coords[i] = (x_coords[i] - origin_x) * size
        y_coords[i] = (y_coords[i] - origin_y) * size
    end

    return x_coords, y_coords
end


--function to pulse any tag between two values for a given frequency and duration
--recommended for shad / xshad / yshad, but can be useful for other tags that can be animated with \\t
function tagpulse(max,start,tag,value1,value2,frequency)
    local tagstring = ""

    for j=0,math.floor(max/frequency) do
        local value
        if j % 2 == 0 then
            value = value1
        else
            value = value2
        end

        local t1 = start + (j * frequency)
        local t2 = t1 + frequency

        tagstring = tagstring.."\\t("..t1..","..t2..",\\"..tag..value..")"
    end
    return tagstring
end


return {
    particle_shape = particle_shape,
    tagpulse = tagpulse
}
