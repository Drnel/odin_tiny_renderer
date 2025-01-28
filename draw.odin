package main

import "core:fmt"

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