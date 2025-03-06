module mj;
import std::time;
import std::math::matrix;
import std::math;
import vk;
import mj::vkbe;

const ENGINE_NAME = "Mjolnir";
const TITLE = "Vulkan C3";
struct Engine {
    Time last_frame_timestamp;
    Time start_timestamp;
    uint current_frame;
}

fn void! init() {
    g_start_timestamp = time::now();
    g_last_frame_timestamp = g_start_timestamp;
    // engine
    vkbe::createVulkanInstance()!;
    vkbe::createWindowSurface()!;
    vkbe::pickPhysicalDevice()!;
    vkbe::createLogicalDevice()!;
    vkbe::createSwapchain()!;
    vkbe::createSemaphores()!;
    // material
    vkbe::createDescriptorSetLayout()!;
    vkbe::createDescriptorSets()!;
    vkbe::createGraphicsPipeline()!;
    vkbe::createCommandPool()!;
    vkbe::createUBO();
    // mesh
    vkbe::createBuffers()!;
}

fn void destroy() {
    vk::deviceWaitIdle(vkbe::g_device)!!;
    vkbe::destroySemaphores();
    vkbe::destroyBuffers();
    vkbe::destroyCommandPool();
    vkbe::destroyGraphicsPipeline();
    vkbe::destroyDescriptorSetLayout();
    vkbe::destroyDescriptorSets();
    vkbe::destroySwapchain();
    vkbe::destroyDevice();
    vkbe::destroySurface();
    vkbe::destroyVulkanInstance();
}

fn void update() {
    vkbe::g_ubo.time = (float)time::now().diff_sec(g_start_timestamp);
    vkbe::g_ubo.model = matrix::IDENTITY4(<float>)
        .rotate_x((float)math::sin(g_ubo.time*0.53))
        .rotate_y((float)math::sin(g_ubo.time*0.97))
        .rotate_z((float)math::sin(g_ubo.time*1.17))
        .transpose();
    g_last_frame_timestamp = time::now();
    vkbe::updateUniforms();
}
