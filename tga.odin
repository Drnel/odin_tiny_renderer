package main

import "core:os"
import "core:slice"
import "core:fmt"

Color :: [4]u8

Image :: struct {
    width: int,
    height: int,
    data: []Color,
}

new_image :: proc(width: int, height: int) -> (image: Image) {
    image.width = width
    image.height = height
    image.data = make([]Color, width * height)
    for &pixel in image.data {
        pixel.a = 255
    }
    return
}

free_image_data :: proc(image: Image) {
    delete(image.data)
}

set_pixel :: proc(image: Image, x: int, y: int,color :Color) {
    image.data[x + (y * image.width)].rgba = color.bgra
}

flip_image_vertically :: proc(image: Image) {
    for y in 0..<(image.height/2) {
        for x in 0..<(image.width) {
            temp :=  image.data[x + (image.height-y-1) * image.height]
            image.data[x + (image.height-y-1) * image.height] = image.data[x + (y * image.width)]
            image.data[x + (y * image.width)] = temp
        }
    }
    // image.data[57 + 12*(100)] = {255,255,255,255}
}

write_tga_image :: proc(image: Image, path: string) {
    file, _ := os.open(path, os.O_RDWR|os.O_CREATE|os.O_TRUNC)
    defer os.close(file)
    header: [18]u8 = {
        0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        u8(image.width & 255), u8((image.width >> 8) & 255),
        u8(image.height & 255), u8((image.height >> 8) & 255),
        32,
        0b00100000,
    }
    os.write(file, header[:])
    data_slice := slice.bytes_from_ptr(raw_data(image.data), len(image.data) * 4)
    os.write(file, data_slice)
}