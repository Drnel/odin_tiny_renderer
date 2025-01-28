package main

import "core:strconv"
import "core:os"
import "core:fmt"

Vertex :: [3]f32

Face :: struct {
    vert_i: [3]int,
    vert_t_i: [3]int,
    vert_n_i: [3]int,
}

Model :: struct {
    vertices: []Vertex,
    faces: []Face,
}

load_model :: proc(path: string) -> (model: Model) {
    vertices := make([dynamic]Vertex)
    faces := make([dynamic]Face)
    data, ok := os.read_entire_file(path)
    if !ok { fmt.println("Couldnt read file!!") }
    defer delete(data)
    for i in 0..<len(data) {
        if data[i] == 'v' && data[i + 1] == ' '{
            append(&vertices, get_vertex(data, i + 2))
        } else if data[i] == 'f' && data[i + 1] == ' '{
            append(&faces, get_face(data, i + 2))
        }
    }
    shrink(&vertices)
    shrink(&faces)
    model.vertices = vertices[:]
    model.faces = faces[:]
    return model
}

free_model_data :: proc(model: Model) {
    delete(model.vertices)
    delete(model.faces)
}

get_vertex :: proc(data: []byte, index: int) -> (vertex: Vertex) {
    start := index
    end := index
    for data[end] != ' '{
        end += 1
    }
    vertex.x, _ = strconv.parse_f32(string(data[start:end]))
    start = end + 1
    end = start
    for data[end] != ' '{
        end += 1
    }
    vertex.y, _ = strconv.parse_f32(string(data[start:end]))
    start = end + 1
    end = start
    for data[end] != '\n'{
        end += 1
    }
    vertex.z, _ = strconv.parse_f32(string(data[start:end]))
    return vertex
}

get_face :: proc(data: []byte, index: int) -> (face: Face) {
    start := index
    end := index
    for data[end] != '/'{
        end += 1
    }
    face.vert_i.x, _ = strconv.parse_int(string(data[start:end]))
    face.vert_i.x  -= 1
    start = end + 1
    end = start
    for data[end] != '/'{
        end += 1
    }
    face.vert_t_i.x, _ = strconv.parse_int(string(data[start:end]))
    face.vert_t_i.x  -= 1
    start = end + 1
    end = start
    for data[end] != ' '{
        end += 1
    }
    face.vert_n_i.x, _ = strconv.parse_int(string(data[start:end]))
    face.vert_n_i.x  -= 1
    start = end + 1
    end = start
    
    for data[end] != '/'{
        end += 1
    }
    face.vert_i.y, _ = strconv.parse_int(string(data[start:end]))
    face.vert_i.y  -= 1
    start = end + 1
    end = start
    for data[end] != '/'{
        end += 1
    }
    face.vert_t_i.y, _ = strconv.parse_int(string(data[start:end]))
    face.vert_t_i.y  -= 1
    start = end + 1
    end = start
    for data[end] != ' '{
        end += 1
    }
    face.vert_n_i.y, _ = strconv.parse_int(string(data[start:end]))
    face.vert_n_i.y  -= 1
    start = end + 1
    end = start
    
    for data[end] != '/'{
        end += 1
    }
    face.vert_i.z, _ = strconv.parse_int(string(data[start:end]))
    face.vert_i.z  -= 1
    start = end + 1
    end = start
    for data[end] != '/'{
        end += 1
    }
    face.vert_t_i.z, _ = strconv.parse_int(string(data[start:end]))
    face.vert_t_i.z  -= 1
    start = end + 1
    end = start
    for data[end] != '\n'{
        end += 1
    }
    face.vert_n_i.z, _ = strconv.parse_int(string(data[start:end]))
    face.vert_n_i.z  -= 1
    
    return face
}