package main

import "core:fmt"

white :: Color{255, 255, 255, 255}
red :: Color{255, 0, 0, 255}

main :: proc() {
    image := new_image(800, 800)
    defer free_image_data(image)
    model := load_model("resources/human_head.obj")
    defer free_model_data(model)
    for face in model.faces {
        draw_vertex_line(model.vertices[face.vert_i.x], model.vertices[face.vert_i.y], image, white)
        draw_vertex_line(model.vertices[face.vert_i.y], model.vertices[face.vert_i.z], image, white)
        draw_vertex_line(model.vertices[face.vert_i.z], model.vertices[face.vert_i.x], image, white)
    }
    flip_image_vertically(image)
    write_tga_image(image, "output.tga")
}