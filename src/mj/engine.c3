module mj;
import std::time;
import std::math::matrix;
import std::math;
import vk;
import mj::be::vk;

const ENGINE_NAME = "Mjolnir";
time::Time g_last_frame_timestamp;
time::Time g_start_timestamp;
uint g_current_frame;

fn void! init() {
    g_start_timestamp = time::now();
    g_last_frame_timestamp = g_start_timestamp;
    createVulkanInstance()!;
    createWindowSurface()!;
    pickPhysicalDevice()!;
    createLogicalDevice()!;
    createSwapchain()!;
    createDescriptorSetLayout()!;
    createGraphicsPipeline()!;
    createCommandPool()!;
    createBuffers()!;
    createDescriptorSets()!;
    createSemaphores()!;
    createUBO();
}

fn void destroy() {
    vk::deviceWaitIdle(g_device)!!;
    destroySemaphores();
    destroyBuffers();
    destroyCommandPool();
    destroyGraphicsPipeline();
    destroyDescriptorSetLayout();
    destroyDescriptorSets();
    destroySwapchain();
    destroyDevice();
    destroySurface();
    destroyVulkanInstance();
}

fn void update() {
    g_ubo.time = (float)time::now().diff_sec(g_start_timestamp);
    g_ubo.model = matrix::IDENTITY4(<float>)
        .rotate_x((float)math::sin(g_ubo.time*0.53))
        .rotate_y((float)math::sin(g_ubo.time*0.97))
        .rotate_z((float)math::sin(g_ubo.time*1.17))
        .transpose();
    g_last_frame_timestamp = time::now();
    updateUniforms();
}
