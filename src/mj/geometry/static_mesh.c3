module mj;
import vk;
import std::core::mem;

def StaticMeshHandle = uint;

struct StaticMesh {
    Vertex[] vertices;
    uint[] indices;
    MaterialHandle material;
}

struct StaticMeshGPU {
    LocalBuffer vertex;
    LocalBuffer index;
}

fn StaticMesh make_cube(float[<4>] color = {0.125, 0.25, 0.5, 1.0}) {
    const float[<4>] A =  {-1.0, -1.0, 1.0, 1.0};
    const float[<4>] B =  {1.0, -1.0, 1.0, 1.0};
    const float[<4>] C =  {1.0, 1.0, 1.0, 1.0};
    const float[<4>] D =  {-1.0, 1.0, 1.0, 1.0};
    const float[<4>] E =  {-1.0, 1.0, -1.0, 1.0};
    const float[<4>] F =  {1.0, 1.0, -1.0, 1.0};
    const float[<4>] G =  {1.0, -1.0, -1.0, 1.0};
    const float[<4>] H =  {-1.0, -1.0, -1.0, 1.0};
    Vertex[] vertices = {
        // Front face
        {.position = A, .color = color, .normal = VEC_FORWARD, .uv = {0.0, 1.0}},
        {.position = B, .color = color, .normal = VEC_FORWARD, .uv = {1.0, 1.0}},
        {.position = C, .color = color, .normal = VEC_FORWARD, .uv = {1.0, 0.0}},
        {.position = D, .color = color, .normal = VEC_FORWARD, .uv = {0.0, 0.0}},

        // Back face
        {.position = E, .color = color, .normal = VEC_BACKWARD, .uv = {1.0, 1.0}},
        {.position = F, .color = color, .normal = VEC_BACKWARD, .uv = {0.0, 1.0}},
        {.position = G, .color = color, .normal = VEC_BACKWARD, .uv = {0.0, 0.0}},
        {.position = H, .color = color, .normal = VEC_BACKWARD, .uv = {1.0, 0.0}},

        // Top face
        {.position = F, .color = color, .normal = VEC_UP, .uv = {0.0, 1.0}},
        {.position = E, .color = color, .normal = VEC_UP, .uv = {1.0, 1.0}},
        {.position = D, .color = color, .normal = VEC_UP, .uv = {1.0, 0.0}},
        {.position = C, .color = color, .normal = VEC_UP, .uv = {0.0, 0.0}},

        // Bottom face
        {.position = B, .color = color, .normal = VEC_DOWN, .uv = {0.0, 1.0}},
        {.position = A, .color = color, .normal = VEC_DOWN, .uv = {1.0, 1.0}},
        {.position = H, .color = color, .normal = VEC_DOWN, .uv = {1.0, 0.0}},
        {.position = G, .color = color, .normal = VEC_DOWN, .uv = {0.0, 0.0}},

        // Right face
        {.position = G, .color = color, .normal = VEC_RIGHT, .uv = {0.0, 1.0}},
        {.position = F, .color = color, .normal = VEC_RIGHT, .uv = {1.0, 1.0}},
        {.position = C, .color = color, .normal = VEC_RIGHT, .uv = {1.0, 0.0}},
        {.position = B, .color = color, .normal = VEC_RIGHT, .uv = {0.0, 0.0}},

        // Left face
        {.position = A, .color = color, .normal = VEC_LEFT, .uv = {0.0, 1.0}},
        {.position = D, .color = color, .normal = VEC_LEFT, .uv = {1.0, 1.0}},
        {.position = E, .color = color, .normal = VEC_LEFT, .uv = {1.0, 0.0}},
        {.position = H, .color = color, .normal = VEC_LEFT, .uv = {0.0, 0.0}},
    };

    uint[] indices = {
        // Front face
        0, 1, 2, 2, 3, 0,
        // Back face
        4, 5, 6, 6, 7, 4,
        // Top face
        8, 9, 10, 10, 11, 8,
        // Bottom face
        12, 13, 14, 14, 15, 12,
        // Right face
        16, 17, 18, 18, 19, 16,
        // Left face
        20, 21, 22, 22, 23, 20
    };
    return StaticMesh {
        .vertices = vertices,
        .indices = indices,
    };
}

fn StaticMeshGPU! createStaticMesh(Engine* engine, StaticMesh* data) {
    return StaticMeshGPU {
        .vertex = createLocalBufferInit(engine, &data.vertices, $sizeof(data.vertices), { .vertex_buffer }),
        .index = createLocalBufferInit(engine, &data.indices, $sizeof(data.indices), { .index_buffer })
    }
}

fn void destroyStaticMesh(Engine* engine, StaticMeshGPU* mesh) {
    destroyBuffer(engine.device, mesh.vertex.buffer, mesh.vertex.memory);
    destroyBuffer(engine.device, mesh.index.buffer, mesh.index.memory);
}
