package main

import "core:fmt"
import "core:math/rand"

white :: Color{255, 255, 255, 255}
red :: Color{255, 0, 0, 255}

main :: proc() {
    image := new_image(800, 800)
    defer free_image_data(image)
    model := load_model("resources/human_head.obj")
    defer free_model_data(model)
    draw_model(model, image, white)
    flip_image_vertically(image)
    write_tga_image(image, "output.tga")
}