package main

import "core:math"

vec2i :: [2]int
vec3f :: [3]f32

normalize_vec3f :: proc(vec: vec3f) -> vec3f {
    return vec * (1 / norm_vec3f(vec))
}

dot_vec3f :: proc(a, b: vec3f) -> f32 {
    return ((a.x * b.x) + (a.y * b.y) + (a.z * b.z))
}

norm_vec3f :: proc(vec: vec3f) -> f32 {
    return math.sqrt_f32(dot_vec3f(vec, vec))
}

cross_vec3f ::proc(a, b: vec3f) -> vec3f {
    return vec3f{(a.y * b.z) - (a.z * b.y), (a.z * b.x) - (a.x * b.z), (a.x * b.y) - (a.y * b.x)}
}