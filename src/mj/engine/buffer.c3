module mj;

struct DataBuffer {
    vk::Buffer buffer;
    vk::DeviceMemory memory;
    usz size;
}

struct ImageBuffer {
    vk::Image image;
    vk::DeviceMemory memory;
    uint width;
    uint height;
    vk::Format format;
}

struct MappedBuffer {
    vk::Buffer buffer;
    vk::DeviceMemory memory;
    usz size;
    void* mapped;
}

fn DataBuffer! Renderer.mallocLocalBuffer(this, usz size, vk::BufferUsageFlags usage) {
    vk::BufferCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = (vk::DeviceSize)size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    DataBuffer ret;
    ret.buffer = vk::createBuffer(this.device, &create_info)!;
    ret.memory = this.allocateMemory(vk::getBufferMemoryRequirements(this.device, ret.buffer))!;
    ret.size = size;
    vk::bindBufferMemory(this.device, ret.buffer, ret.memory, 0)!;
    return ret;
}

fn DataBuffer! Renderer.mallocHostVisibleBuffer(this, usz size, vk::BufferUsageFlags usage = { .transfer_src }) {
    vk::BufferCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = (vk::DeviceSize)size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    DataBuffer ret = {
        .buffer = vk::createBuffer(this.device, &create_info)!,
        .memory = this.allocateMemory(vk::getBufferMemoryRequirements(this.device, ret.buffer), { .host_visible, .host_coherent })!,
    };
    vk::bindBufferMemory(this.device, ret.buffer, ret.memory, 0)!;
    return ret;
}

fn ImageBuffer! Renderer.mallocImageBuffer(this, vk::Format format, uint width, uint height) {
    vk::ImageCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_CREATE_INFO,
        .image_type = vk::IMAGE_TYPE_2D,
        .extent = {
            .width = width,
            .height = height,
            .depth = 1
        },
        .mip_levels = 1,
        .array_layers = 1,
        .format = format,
        .tiling = vk::IMAGE_TILING_OPTIMAL,
        .usage = { .transfer_dst, .sampled },
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .initial_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .samples = { .n_1 },
    };
    ImageBuffer ret;
    ret.image = vk::createImage(this.device, &image_info);
    ret.memory = this.allocateMemory(vk::getImageMemoryRequirements(this.device, ret.image))!;
    ret.extent = image_info.extent;
    ret.format = image_info.format;
    vk::bindImageMemory(this.device, ret.image, ret.memory, 0)!;
    return ret;
}

fn DataBuffer! Renderer.mallocLocalBuffer(this, usz size, vk::BufferUsageFlags usage) {
    DataBuffer staging = this.makeHostVisibleBuffer(size);
    DataBuffer ret = this.mallocLocalBuffer(size);
    this.copyBuffer(&ret, &staging);
    this.destroyBuffer(&staging);
    return ret;
}

fn DataBuffer! Renderer.makeHostVisibleBuffer(this, usz size, vk::BufferUsageFlags usage = { .transfer_src }) {
    DataBuffer ret = this.createHostVisibleBuffer(size, usage);
    this.writeBuffer(&ret, data);
    return ret;
}

fn ImageBuffer! Renderer.makeImageBuffer(this, void* data, vk::Format format, uint width, uint height, uint channel) {
    usz size = width * height * channel;
    DataBuffer staging = this.makeHostVisibleBuffer(data, size);
    ImageBuffer ret = this.mallocImageBuffer(format, width, height);
    this.copyImage(&ret, &staging);
    this.destroyBuffer(&staging);
    return ret;
}

fn void! Renderer.writeBuffer(this, DataBuffer* buffer, void* data) {
    void* mapped = vk::mapMemory(this.device, buffer.memory, 0, (vk::DeviceSize)buffer.size)!;
    mem::copy(mapped, data, buffer.size);
}

fn void! Renderer.copyBuffer(this, DataBuffer* dst, DataBuffer* src) {
    vk::CommandBuffer command_buffer = this.beginSingleTimeCommand()!;
    vk::cmdCopyBuffer(command_buffer, src.buffer, dst.buffer, 1, &&vk::BufferCopy { .size = (vk::DeviceSize)src.size });
    this.endSingleTimeCommand(command_buffer)!;
}

// this procedure is assuming input image is uninitialized
fn void! Renderer.copyImage(this, ImageBuffer* dst, DataBuffer* src) {
    this.transitionImageLayout(dst.image, dst.format, vk::IMAGE_LAYOUT_UNDEFINED, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL)!;
    vk::CommandBuffer command_buffer = this.beginSingleTimeCommand()!;
    vk::BufferImageCopy copy_region = {
        .image_subresource = {
            .aspect_mask = { .color },
            .layer_count = 1,
        },
        .image_extent = {
            .width = dst.width,
            .height = dst.height,
            .depth = 1,
        },
    };
    vk::cmdCopyBufferToImage(command_buffer, src.buffer, dst.image, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy_region);
    this.endSingleTimeCommand(command_buffer)!;
    this.transitionImageLayout(dst.image, dst.format, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL)!;
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

fn vk::DeviceMemory! Renderer.allocateMemory(this, vk::MemoryRequirements req, vk::MemoryPropertyFlags properties = { .device_local }) {
    vk::MemoryAllocateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = req.size,
        .memory_type_index = findMemoryType(this.physical_device, req.memory_type_bits, properties)!,
    };
    return vk::allocateMemory(this.device, &info)!;
}

fn void Renderer.destroyImage(this, ImageBuffer* buffer) {
    vk::destroyImage(this.device, buffer.image);
    vk::freeMemory(this.device, buffer.memory);
    vk::unmapMemory(this.device, buffer.memory);
}

fn void Renderer.destroyBuffer(this, DataBuffer* buffer) {
    vk::destroyBuffer(this.device, buffer.buffer);
    vk::freeMemory(this.device, buffer.memory);
    vk::unmapMemory(this.device, buffer.memory);
}

// this procedure is assuming image only live in fragment shader
fn void! Renderer.transitionImageLayout(this, vk::Image image, vk::Format format, vk::ImageLayout old, vk::ImageLayout new) {
    vk::CommandBuffer command_buffer = this.beginSingleTimeCommand()!;
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
    this.endSingleTimeCommand(command_buffer)!;
}
