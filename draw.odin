package main

import "core:fmt"
import "core:math/rand"

line :: proc(x0, y0, x1, y1: int, image: Image, color: Color) {
    if abs(x1 - x0) > abs(y1 - y0){
        if x0 < x1 {
            for x in x0..=x1 {
                t := f32(x - x0) / f32(x1 - x0)
                y := int(f32(y0) * (1 - t) + f32(y1) * t)
                set_pixel(image,x, y, color)
            }
        } else {
            for x in x1..=x0 {
                t := f32(x - x1) / f32(x0 - x1)
                y := int(f32(y1) * (1 - t) + f32(y0) * t)
                set_pixel(image,x, y, color)
            }
        }
    } else {
        if y0 < y1 {
            for y in y0..=y1 {
                t := f32(y - y0) /f32(y1 - y0)
                x := int(f32(x0) * (1 - t) + f32(x1) * t)
                set_pixel(image, x, y, color)
            }
        } else {
            for y in y1..=y0 {
                t := f32(y - y1) /f32(y0 - y1)
                x := int(f32(x1) * (1 - t) + f32(x0) * t)
                set_pixel(image, x, y, color)
            }
        }
    }
}

draw_vertex_line :: proc(v0, v1: Vertex, image: Image, color: Color) {
    x0 := int((v0.x + 1) * f32(image.width) / 2)
    y0 := int((v0.y + 1) * f32(image.height) / 2)
    x1 := int((v1.x + 1) * f32(image.width) / 2)
    y1 := int((v1.y + 1) * f32(image.height) / 2)
    line(x0, y0, x1, y1, image, color)
}

draw_triangle_wire :: proc(face: Face, model: Model, image: Image, color: Color) {
    draw_vertex_line(model.vertices[face.vert_i.x], model.vertices[face.vert_i.y], image, color)
    draw_vertex_line(model.vertices[face.vert_i.y], model.vertices[face.vert_i.z], image, color)
    draw_vertex_line(model.vertices[face.vert_i.z], model.vertices[face.vert_i.x], image, color)
}

edge_function :: proc(a, b, c: vec2i) -> int {
    result := ((b.x - a.x) * (c.y - a.y)) - ((b.y - a.y) * (c.x - a.x))
    return result
}

screen_coordinates :: proc(vertex: Vertex, image: Image) -> (screen_coord: vec2i) {
    screen_coord.x = int((vertex.x + 1) * f32(image.width) / 2)
    screen_coord.y = int((vertex.y + 1) * f32(image.width) / 2)
    return screen_coord
}

draw_triangle :: proc(face: Face, model: Model, image: Image, color: Color) {
    a := screen_coordinates(model.vertices[face.vert_i[0]], image)
    b := screen_coordinates(model.vertices[face.vert_i[1]], image)
    c := screen_coordinates(model.vertices[face.vert_i[2]], image)
    box_min_x := min(a.x, b.x, c.x)
    box_max_x := max(a.x, b.x, c.x)
    box_min_y := min(a.y, b.y, c.y)
    box_max_y := max(a.y, b.y, c.y)
    for p_x in box_min_x..=box_max_x {
        for p_y in box_min_y..=box_max_y {
            p := vec2i{p_x, p_y}
            if  edge_function(a, b, p) < 0 ||
                edge_function(b, c, p) < 0 ||
                edge_function(c, a, p) < 0 
            { continue }
            set_pixel(image, p_x, p_y, color)
        }
    }
}

draw_model :: proc(model: Model, image: Image, color: Color) {
    light_dir := vec3f{0, 0, -1}
    light_dir = normalize_vec3f(light_dir)
    for face in model.faces {
        n := cross_vec3f(
            model.vertices[face.vert_i[2]] - model.vertices[face.vert_i[0]],
            model.vertices[face.vert_i[1]] - model.vertices[face.vert_i[0]]
        )
        n = normalize_vec3f(n)
        intensity := dot_vec3f(n, light_dir)
        if intensity < 0 { continue }
        light_color : Color
        light_color.r = u8(f32(color.r) * intensity)
        light_color.g = u8(f32(color.g) * intensity)
        light_color.b = u8(f32(color.b) * intensity)
        light_color.a = color.a
        draw_triangle(face, model, image, light_color)
    }
}