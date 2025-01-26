package main

import "core:fmt"

white :: Color{255, 255, 255, 255}
red :: Color{255, 0, 0, 255}

main :: proc() {
    image := new_image(100, 100)
    defer free_image_data(image)
    set_pixel(image, 52, 41, red)
    flip_image_vertically(image)
    write_tga_image(image, "output.tga")
}