module mj;
import vk;

fn vk::CommandBuffer! beginSingleTimeCommand(Engine* engine) {
    vk::CommandBuffer[] command_buffer = vk::allocateCommandBuffers(engine.device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = engine.command_pool,
        .command_buffer_count = 1,
    })!;
    vk::beginCommandBuffer(command_buffer[0], &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = vk::CommandBufferUsageFlags { .one_time_submit },
    })!;
    return command_buffer[0];
}

fn void! endSingleTimeCommand(Engine* engine, vk::CommandBuffer command_buffer) {
    defer vk::freeCommandBuffers(engine.device, engine.command_pool, 1, &command_buffer);
    vk::endCommandBuffer(command_buffer)!;
    vk::queueSubmit(engine.graphics_queue, 1, &&vk::SubmitInfo {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    }, (vk::Fence)0)!;
    vk::queueWaitIdle(engine.graphics_queue)!;
}
