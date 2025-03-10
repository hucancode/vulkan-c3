module mj;

struct LocalBuffer {
    vk::Buffer buffer;
    vk::DeviceMemory memory;
    usz size;
}

struct ImageBuffer {
    vk::Image image;
    vk::DeviceMemory memory;
    usz size;
}

struct MappedBuffer {
    vk::Buffer buffer;
    vk::DeviceMemory memory;
    usz size;
    void* mapped;
}

fn LocalBuffer! createLocalBuffer(Renderer* renderer, usz size, vk::BufferUsageFlags usage) {
    vk::BufferCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = (vk::DeviceSize)size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    LocalBuffer ret = {
        .buffer = vk::createBuffer(renderer.device, &create_info)!,
        .memory = allocateMemory(renderer.device, vk::getBufferMemoryRequirements(renderer.device, ret.buffer))!,
        .size = size,
    };
    vk::bindBufferMemory(renderer.device, ret.buffer, ret.memory, 0)!;
    return ret;
}

fn LocalBuffer! createLocalBufferInit(Renderer* renderer, void* data, usz size, vk::BufferUsageFlags usage) {
    MappedBuffer staging = createMappedBuffer(engine, data, size);
    return transferToLocal(engine, &staging, usage);
}

fn MappedBuffer! createMappedBuffer(Renderer* renderer, void* data, usz size, vk::BufferUsageFlags usage = { .transfer_src }) {
    vk::BufferCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = (vk::DeviceSize)size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    MappedBuffer ret = {
        .buffer = vk::createBuffer(renderer.device, &create_info)!,
        .memory = allocateMemory(renderer.device, vk::getBufferMemoryRequirements(renderer.device, ret.buffer), { .host_visible, .host_coherent })!,
        .mapped = vk::mapMemory(renderer.device, ret.memory, 0, (vk::DeviceSize)size)!,
    };
    vk::bindBufferMemory(renderer.device, ret.buffer, ret.memory, 0)!;
    mem::copy(ret.mapped, data, size);
    return ret;
}

fn void! writeToMappedBuffer(void* src, MappedBuffer* dst) {
    mem::copy(dst.mapped, src, dst.size);
}

fn LocalBuffer! transferToLocal(Renderer* renderer, MappedBuffer* src, vk::BufferUsageFlags usage) {
    defer destroyBuffer(engine, src.buffer, src.memory);
    LocalBuffer dst = createLocalBuffer(engine, src.size, { .transfer_dst } | usage);
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::cmdCopyBuffer(command_buffer, src.buffer, dst.buffer, 1, &&vk::BufferCopy { .size = (vk::DeviceSize)size });
    endSingleTimeCommand(command_buffer)!;
    return dst;
}

fn ImageBuffer! transferToImage(Renderer* renderer, MappedBuffer* src, vk::ImageCreateInfo* image_info) {
    defer destroyBuffer(engine, src.buffer, src.memory);
    ImageBuffer ret = {
        .image = vk::createImage(renderer.device, &image_info),
        .memory = allocateMemory(engine, vk::getImageMemoryRequirements(renderer.device, ret.image))!,
        .size = src.size,
    };
    vk::bindImageMemory(renderer.device, ret.image, ret.memory, 0)!;
    transitionImageLayout(ret.image, image_info.format, vk::IMAGE_LAYOUT_UNDEFINED, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL)!;
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::BufferImageCopy copy_region = {
        .image_subresource = {
            .aspect_mask = { .color },
            .layer_count = 1,
        },
        .image_extent = image_info.extent,
    };
    vk::cmdCopyBufferToImage(command_buffer, src.buffer, ret.image, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy_region);
    endSingleTimeCommand(command_buffer)!;
    transitionImageLayout(ret.image, image_info.format, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL)!;
    return ret;
}

fn uint! findMemoryType(vk::PhysicalDevice device, uint filter, vk::MemoryPropertyFlags flags) {
    vk::PhysicalDeviceMemoryProperties props = vk::getPhysicalDeviceMemoryProperties(device);
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

fn vk::DeviceMemory! allocateMemory(Renderer* renderer, vk::MemoryRequirements req, vk::MemoryPropertyFlags properties = { .device_local }) {
    vk::MemoryAllocateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = req.size,
        .memory_type_index = findMemoryType(renderer.physical_device, req.memory_type_bits, properties)!,
    };
    return vk::allocateMemory(renderer.device, &info)!;
}

fn void destroyBuffer(Renderer* renderer, vk::Buffer buffer, vk::DeviceMemory memory) {
    vk::destroyBuffer(renderer.device, buffer);
    vk::freeMemory(renderer.device, memory);
    vk::unmapMemory(renderer.device, memory);
}

fn void! transitionImageLayout(vk::Image image, vk::Format format, vk::ImageLayout old, vk::ImageLayout new) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::PipelineStageFlags src_stage;
    vk::PipelineStageFlags dst_stage;
    vk::ImageMemoryBarrier barrier = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = old,
        .new_layout = new,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = image,
        .subresource_range = {
            .aspect_mask = { .color },
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1,
        },
    };
    if(old == vk::IMAGE_LAYOUT_UNDEFINED && new == vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) {
        barrier.dst_access_mask = { .transfer_write };
        src_stage = { .top_of_pipe };
        dst_stage = { .transfer };
    } else if(old == vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL && new == vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
        barrier.src_access_mask = { .transfer_write };
        barrier.dst_access_mask = { .shader_read };
        src_stage = { .transfer };
        dst_stage = { .fragment_shader };
    }
    vk::cmdPipelineBarrier(
        command_buffer,
        src_stage, dst_stage,
        {},
        0, null,
        0, null,
        1, &barrier);
    endSingleTimeCommand(command_buffer)!;
}

fn void! copyBufferImage(vk::Buffer buffer, vk::Image image, uint width, uint height) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::BufferImageCopy copy_region = {
        .buffer_offset = 0,
        .buffer_row_length = 0,
        .buffer_image_height = 0,
        .image_subresource = {
            .aspect_mask = { .color },
            .mip_level = 0,
            .base_array_layer = 0,
            .layer_count = 1,
        },
        .image_offset = {0, 0, 0},
        .image_extent = {width, height, 1},
    };
    vk::cmdCopyBufferToImage(command_buffer, buffer, image, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy_region);
    endSingleTimeCommand(command_buffer)!;
}
