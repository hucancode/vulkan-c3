module mj::vkbe;
import vk;

vk::CommandPool g_command_pool;
vk::CommandBuffer[MAX_FRAMES_IN_FLIGHT] g_command_buffers;

fn vk::CommandBuffer! beginSingleTimeCommand() {
    vk::CommandBuffer command_buffer;
    vk::allocateCommandBuffers(g_device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = g_command_pool,
        .command_buffer_count = 1,
    }, &command_buffer)!;
    vk::beginCommandBuffer(command_buffer, &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = vk::CommandBufferUsageFlags { .one_time_submit },
    })!;
    return command_buffer;
}

fn void! endSingleTimeCommand(vk::CommandBuffer command_buffer) {
    defer vk::freeCommandBuffers(g_device, g_command_pool, 1, &command_buffer);
    vk::endCommandBuffer(command_buffer)!;
    vk::queueSubmit(g_graphics_queue, 1, &&vk::SubmitInfo {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    }, (vk::Fence)0)!;
    vk::queueWaitIdle(g_graphics_queue)!;
}

fn void! createCommandPool() {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(g_physical_device)!;
    vk::CommandPoolCreateInfo poolInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = vk::CommandPoolCreateFlags { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    vk::createCommandPool(g_device, &poolInfo, null, &g_command_pool)!;
    vk::CommandBufferAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .command_pool = g_command_pool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_buffer_count = g_command_buffers.len,
    };
    vk::allocateCommandBuffers(g_device, &allocInfo, &g_command_buffers)!;
}

fn void destroyCommandPool() {
    vk::freeCommandBuffers(g_device, g_command_pool, g_command_buffers.len, &g_command_buffers);
    vk::destroyCommandPool(g_device, g_command_pool, null);
}
