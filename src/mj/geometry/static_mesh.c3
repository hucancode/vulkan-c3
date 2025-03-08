module mj;
import vk;

def StaticMeshHandle = uint;

struct StaticMesh {
    Vertex[] vertices;
    uint[] indices;
    MaterialHandle material;
}

struct StaticMeshGPU {
    vk::Buffer vertex_buffer;
    vk::Buffer index_buffer;
    vk::DeviceMemory memory;
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

fn void! createBuffer(vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags properties, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::BufferCreateInfo bufferInfo = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    vk::createBuffer(g_device, &bufferInfo, null, buffer)!;
    allocateMemory(g_device, vk::getBufferMemoryRequirements(g_device, *buffer), properties, memory)!;
    vk::bindBufferMemory(g_device, *buffer, *memory, 0)!;
}

fn void! copyBuffer(vk::Buffer dst, vk::Buffer src, vk::DeviceSize size) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::cmdCopyBuffer(command_buffer, src, dst, 1, &&vk::BufferCopy { .size = size });
    endSingleTimeCommand(command_buffer)!;
}

fn void! createBufferInit(void* data, vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags flags, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::Buffer stg_buffer;
    vk::DeviceMemory stg_memory;
    createBuffer(size, vk::BufferUsageFlags { .transfer_src }, vk::MemoryPropertyFlags { .host_visible, .host_coherent }, &stg_buffer, &stg_memory)!;
    defer {
        vk::destroyBuffer(g_device, stg_buffer, null);
        vk::freeMemory(g_device, stg_memory, null);
    }
    void* mapped;
    vk::mapMemory(g_device, stg_memory, 0, size, vk::MemoryMapFlags{}, &mapped)!;
    defer vk::unmapMemory(g_device, stg_memory);
    mem::copy(mapped, data, (usz)size);
    createBuffer(size, vk::BufferUsageFlags { .transfer_dst } | usage, flags, buffer, memory)!;
    copyBuffer(*buffer, stg_buffer, size)!;
}

fn void! createBuffers() {
    createBufferInit(&VERTICES, (vk::DeviceSize)($sizeof(VERTICES)), vk::BufferUsageFlags { .vertex_buffer }, vk::MemoryPropertyFlags { .device_local }, &g_vertex_buffer, &g_vertex_memory)!;
    createBufferInit(&INDICES, (vk::DeviceSize)($sizeof(INDICES)), vk::BufferUsageFlags { .index_buffer }, vk::MemoryPropertyFlags { .device_local }, &g_index_buffer, &g_index_memory)!;
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        createBufferInit(&g_ubo, UniformBuffer.sizeof, vk::BufferUsageFlags { .uniform_buffer }, vk::MemoryPropertyFlags { .host_visible, .host_coherent }, &g_uniform_buffers[i], &g_uniform_memory[i])!;
        vk::mapMemory(g_device, g_uniform_memory[i], 0, UniformBuffer.sizeof, vk::MemoryMapFlags{}, &g_uniform_buffer_mapped[i])!;
    }
    createTextures()!;
}

fn void destroyBuffers() {
    vk::destroyBuffer(g_device, g_vertex_buffer, null);
    vk::freeMemory(g_device, g_vertex_memory, null);
    vk::destroyBuffer(g_device, g_index_buffer, null);
    vk::freeMemory(g_device, g_index_memory, null);
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroyBuffer(g_device, g_uniform_buffers[i], null);
        vk::freeMemory(g_device, g_uniform_memory[i], null);
    }
    destroyTextures();
}
