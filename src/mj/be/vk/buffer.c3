module mj::vkbe;
import vk;
import glfw;

vk::Buffer[MAX_FRAMES_IN_FLIGHT] g_uniform_buffers;
vk::DeviceMemory[MAX_FRAMES_IN_FLIGHT] g_uniform_memory;
void*[MAX_FRAMES_IN_FLIGHT] g_uniform_buffer_mapped;
vk::Buffer g_index_buffer;
vk::DeviceMemory g_index_memory;
vk::Buffer g_vertex_buffer;
vk::DeviceMemory g_vertex_memory;
vk::Sampler g_sampler;
vk::Image g_texture_image;
vk::ImageView g_texture_image_view;
vk::DeviceMemory g_texture_image_memory;

UniformBuffer g_ubo;

fn uint! findMemoryType(uint filter, vk::MemoryPropertyFlags flags) {
    vk::PhysicalDeviceMemoryProperties props;
    vk::getPhysicalDeviceMemoryProperties(g_physical_device, &props);
    for (uint i = 0; i < props.memory_type_count; i++) {
        if (filter & (1 << i) == 0) {
            continue;
        }
        if ((props.memory_types[i].property_flags & flags) != flags) {
            continue;
        }
        return i;
    }
    return vk::VulkanError.ERROR_UNKNOWN?;
}
fn void! createBuffer(vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags properties, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::BufferCreateInfo bufferInfo = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    vk::createBuffer(g_device, &bufferInfo, null, buffer)!;
    vk::MemoryRequirements requirements;
    vk::getBufferMemoryRequirements(g_device, *buffer, &requirements);
    vk::MemoryAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = requirements.size,
        .memory_type_index = findMemoryType(requirements.memory_type_bits, properties)!,
    };
    vk::allocateMemory(g_device, &allocInfo, null, memory)!;
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

fn void destroyTextures() {
    vk::destroyImage(g_device, g_texture_image, null);
    vk::destroyImageView(g_device, g_texture_image_view, null);
    vk::destroySampler(g_device, g_sampler, null);
}
