const bool GLFW_INCLUDE_VULKAN = true;
module helloc3vk;
import std::io;
import glfw;
import vk;

glfw::Window* g_window;
vk::Instance g_instance;
vk::SurfaceKHR g_surface;

fn int main(String[] args) {
    if (!glfw::init()) {
        return -1;
    }
    defer glfw::terminate();
    glfw::windowHint(glfw::CLIENT_API, glfw::NO_API);
    g_window = glfw::createWindow(800, 600, "Hello VK!", null, null);
    if (g_window == null) {
        return -1;
    }
    defer glfw::destroyWindow(g_window);
    createVulkanInstance()!!;
    io::print("Vulkan instance created\n");
    pickPhysicalDevice()!!;
    io::print("Physical device picked\n");
    createLogicalDevice()!!;
    io::print("Logical device created\n");
    createSwapChain()!!;
    io::print("Swap chain created\n");
    createShaderModule()!!;
    io::print("Shader module created\n");
    createRenderPass()!!;
    io::print("Render pass created\n");
    createGraphicsPipeline()!!;
    io::print("Graphics pipeline created\n");
    createFramebuffers()!!;
    io::print("Framebuffers created\n");
    createCommandPool()!!;
    io::print("Command pool created\n");
    createCommandBuffers()!!;
    io::print("Command buffers created\n");
    createSemaphores()!!;
    io::print("Semaphores created\n");
    while (!glfw::windowShouldClose(g_window)) {
        glfw::pollEvents();
        render()!!;
    }
    return 0;
}

fn void! createVulkanInstance() {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* extensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    vk::InstanceCreateInfo createInfo;
    createInfo.sType = vk::StructureType.INSTANCE_CREATE_INFO;
    createInfo.enabledExtensionCount = (uint)extensionCount;
    createInfo.ppEnabledExtensionNames = extensions;
    vk::check(vk::createInstance(&createInfo, null, &g_instance))!;
    vk::loadProcAddressesInstance(g_instance);
    vk::check(glfw::createWindowSurface(g_instance, g_window, null, &g_surface))!;
}

fn void! pickPhysicalDevice() {

}

fn void! createLogicalDevice() {

}

fn void! createSwapChain() {

}

fn void! createShaderModule() {

}

fn void! createRenderPass() {

}

fn void! createGraphicsPipeline() {

}

fn void! createFramebuffers() {

}

fn void! createCommandPool() {

}

fn void! createCommandBuffers() {

}

fn void! createSemaphores() {

}

fn void! render() {

}
