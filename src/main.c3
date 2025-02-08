module std::core::env;
const bool GLFW_INCLUDE_VULKAN = true;
module helloc3vk;
import std::core::mem;
import std::io;
import glfw;
import vk;

const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = true;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};
const char[*] VERTEX_CODE = $embed("shaders/vert.spv");
const char[*] FRAGMENT_CODE = $embed("shaders/frag.spv");

const MAX_FRAMES_IN_FLIGHT = 2;

glfw::Window* g_window;
vk::Instance g_instance;
vk::SurfaceKHR g_surface;
vk::DebugUtilsMessengerEXT g_debugMessenger @if(ENABLE_VALIDATION_LAYERS);

vk::PhysicalDevice g_physicalDevice;
vk::Device g_device;
vk::Queue g_graphicsQueue;
vk::Queue g_presentQueue;

vk::SurfaceFormatKHR g_swapChainFormat;
vk::Extent2D g_swapChainExtent;
vk::SwapchainKHR g_swapChain;
vk::Image* g_swapChainImages;
vk::ImageView* g_swapChainImageViews;
vk::Framebuffer* g_swapChainFramebuffers;
uint g_swapChainImageCount;

vk::ShaderModule g_vertexShader;
vk::ShaderModule g_fragmentShader;
vk::PipelineShaderStageCreateInfo[2] g_vertexShaderStageInfo;
vk::RenderPass g_renderPass;
vk::PipelineLayout g_pipelineLayout;
vk::Pipeline g_graphicsPipeline;

vk::CommandPool g_commandPool;
vk::CommandBuffer[MAX_FRAMES_IN_FLIGHT] g_commandBuffers;
vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_imageAvailableSemaphore;
vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_renderFinishedSemaphore;
vk::Fence[MAX_FRAMES_IN_FLIGHT] g_inFlightFences;

uint g_currentFrame = 0;

fn int main(String[] args) {
    io::printfn("GLFW %s",glfw::getVersionString());
    glfw::setErrorCallback(fn void(int error, ZString description) => io::printfn("GLFW error: %s", description));
    if (!glfw::init()) {
        return -1;
    }
    defer glfw::terminate();
    glfw::windowHint(glfw::CLIENT_API, glfw::NO_API);
    g_window = glfw::createWindow(800, 600, "Hello VK!", null, null);
    if (g_window == null) {
        return -1;
    }
    io::printfn("Window created %x", g_window);
    defer glfw::destroyWindow(g_window);
    createVulkanInstance()!!;
    defer vk::destroyInstance(g_instance, null);
    $if ENABLE_VALIDATION_LAYERS:
		defer vk::destroyDebugUtilsMessengerEXT(g_instance, g_debugMessenger, null);
    $endif
    io::printfn("Vulkan instance created %x", g_instance);
    createWindowSurface()!!;
    defer vk::destroySurfaceKHR(g_instance, g_surface, null);
    io::printfn("Window surface created %x", g_surface);
    pickPhysicalDevice()!!;
    io::printfn("Physical device picked %x", g_physicalDevice);
    createLogicalDevice()!!;
    defer vk::destroyDevice(g_device, null);
    io::printfn("Logical device created %x", g_device);
    createSwapchain()!!;
    defer destroySwapchain();
    io::printfn("Swap chain created %x", g_swapChain);
    loadShader()!!;
    defer {
        vk::destroyShaderModule(g_device, g_vertexShader, null);
        vk::destroyShaderModule(g_device, g_fragmentShader, null);
    }
    io::printfn("Shader module created %x %x", g_vertexShader, g_fragmentShader);
    createRenderPass()!!;
    defer vk::destroyRenderPass(g_device, g_renderPass, null);
    io::printfn("Render pass created %x", g_renderPass);
    createFrameBuffers()!!;
    defer destroyFrameBuffers();
    io::printfn("Frame buffers created %x", g_swapChainFramebuffers);
    createGraphicsPipeline()!!;
    defer {
        vk::destroyPipelineLayout(g_device, g_pipelineLayout, null);
        vk::destroyPipeline(g_device, g_graphicsPipeline, null);
    }
    io::print("Graphics pipeline created\n");
    createCommandPool()!!;
    defer vk::destroyCommandPool(g_device, g_commandPool, null);
    io::print("Command pool created\n");
    createSemaphores()!!;
    defer destroySemaphores();
    io::print("Semaphores created\n");
    while (!glfw::windowShouldClose(g_window)) {
        glfw::pollEvents();
        anyfault excuse = @catch(render());
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    vk::deviceWaitIdle(g_device);
    return 0;
}

fn void! createVulkanInstance() {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* extensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    //defer free(extensions);
    vk::InstanceCreateInfo createInfo = {
        .sType = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &&vk::ApplicationInfo {
            .sType = vk::STRUCTURE_TYPE_APPLICATION_INFO,
            .pApplicationName = "Hello VK",
            .applicationVersion = vk::@make_version(1, 0, 0),
            .pEngineName = "No Engine",
            .engineVersion = vk::@make_version(1, 0, 0),
            .apiVersion = vk::API_VERSION_1_3,
        },
    };
    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabledLayerCount = VALIDATION_LAYERS.len;
        createInfo.ppEnabledLayerNames = &VALIDATION_LAYERS;
        extensionCount += 1;
        ZString* ext2 = (ZString*)malloc(extensionCount * ZString.sizeof);
        mem::copy(ext2, extensions, (extensionCount - 1) * ZString.sizeof);
        defer free(extensions);
        extensions = ext2;
        extensions[extensionCount - 1] = vk::EXT_DEBUG_UTILS_EXTENSION_NAME;
        vk::DebugUtilsMessengerCreateInfoEXT debugCreateInfo = {
            .sType = vk::STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            .messageSeverity = vk::DebugUtilsMessageSeverityFlagsEXT {
                .error = true,
                .warning = true,
                .info = true,
            },
            .messageType = vk::DebugUtilsMessageTypeFlagsEXT {
                .general = true,
                .validation = true,
                .performance = true,
                .device_address_binding = true,
            },
            .pfnUserCallback = fn uint(vk::DebugUtilsMessageSeverityFlagsEXT messageSeverity,
                vk::DebugUtilsMessageTypeFlagsEXT messageType,
                vk::DebugUtilsMessengerCallbackDataEXT* pCallbackData,
                void* pUserData) {
                io::printfn("Validation layer: %s", pCallbackData.pMessage);
                return 0;
            },
        };
        createInfo.pNext = &debugCreateInfo;
    $endif

    createInfo.enabledExtensionCount = (uint)extensionCount;
    createInfo.ppEnabledExtensionNames = extensions;
    io::printfn("Required extensions count: %d", (uint)extensionCount);
    for (uint i = 0; i < extensionCount; i++) {
        io::printfn("Required extension: %s", extensions[i]);
    }
    vk::check(vk::createInstance(&createInfo, null, &g_instance))!;
    vk::loadProcAddressesInstance(g_instance);
    $if ENABLE_VALIDATION_LAYERS:
        vk::check(vk::createDebugUtilsMessengerEXT(
            g_instance,
            &debugCreateInfo,
            null,
            &g_debugMessenger
        ))!;
    $endif
}

fn void! createWindowSurface() {
    vk::check(glfw::createWindowSurface(g_instance, g_window, null, &g_surface))!;
}

fn vk::ExtensionProperties[]! getAvailableExtensions() {
    uint n;
    vk::check(vk::enumerateInstanceExtensionProperties(null, &n, null))!;
    vk::ExtensionProperties* ret = (vk::ExtensionProperties*)malloc(n * vk::ExtensionProperties.sizeof);
    vk::check(vk::enumerateInstanceExtensionProperties(null, &n, ret))!;
    return ret[:n];
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    uint score = 0;
    vk::PhysicalDeviceProperties properties;
    vk::PhysicalDeviceFeatures features;
    vk::getPhysicalDeviceProperties(device, &properties);
    ZString deviceName = (ZString)properties.deviceName[0..];
    io::printfn("Scoring device %s", deviceName);
    defer io::printfn("Device %s scored %d", score);
    vk::getPhysicalDeviceFeatures(device, &features);
    $if !env::DARWIN:
        if (!features.geometryShader) {
            return 0;
        }
    $endif
    {
        vk::ExtensionProperties[]! extensions = getAvailableExtensions();
        if (catch excuse = extensions) {
            io::printfn("Cound not get extension list for %s", deviceName);
            return 0;
        }
        defer free(extensions.ptr);
        foreach (required: REQUIRED_EXTENSIONS) {
            bool found = false;
            foreach (e : extensions) {
                ZString name = (ZString)e.extensionName[0..];
                if (name == required) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                io::printfn("Extension %s not found in %s", required, deviceName);
                return 0;
            }
        }
    }
    {
        SwapchainSupportDetails! support = querySwapchainSupport(device);
        if (catch excuse = support) {
            io::printfn("Cound not get swapchain support for %s", deviceName);
            return 0;
        }
        support.free();
    }
    {
        QueueFamilyIndices! indices = findQueueFamilies(device);
        if (catch excuse = indices) {
            io::printfn("Cound not get queue families for %s", deviceName);
            return 0;
        }
    }
    switch (properties.deviceType) {
    case vk::PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
        score += 400_000;
    case vk::PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU:
        score += 300_000;
    case vk::PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU:
        score += 200_000;
    case vk::PHYSICAL_DEVICE_TYPE_CPU:
        nextcase;
    case vk::PHYSICAL_DEVICE_TYPE_OTHER:
        score += 100_000;
    }
    score += properties.limits.maxImageDimension2D;
    return score;
}

fn void! pickPhysicalDevice() {
    uint count;
    vk::check(vk::enumeratePhysicalDevices(g_instance, &count, null))!;
    io::printfn("Physical devices count: %d", count);
    vk::PhysicalDevice* devices = (vk::PhysicalDevice*)malloc(count * vk::PhysicalDevice.sizeof);
    defer free(devices);
    vk::check(vk::enumeratePhysicalDevices(g_instance, &count, devices))!;
    g_physicalDevice = devices[0];
    uint bestScore = 0;
    for (int i = 0; i < count; i++) {
        int score = scorePhysicalDevice(devices[i]);
        io::printfn("Device %x score: %d", i, score);
        if (score > bestScore) {
            g_physicalDevice = devices[i];
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %x with score %d", g_physicalDevice, bestScore);
}

struct SwapchainSupportDetails {
    vk::SurfaceCapabilitiesKHR capabilities;
    vk::SurfaceFormatKHR* formats;
    uint formatCount;
    vk::PresentModeKHR* presentModes;
    uint presentModeCount;
}
fn void SwapchainSupportDetails.free(SwapchainSupportDetails* self) {
    free(self.formats);
    free(self.presentModes);
}

fn SwapchainSupportDetails! querySwapchainSupport(vk::PhysicalDevice device) {
    SwapchainSupportDetails ret;
    vk::check(vk::getPhysicalDeviceSurfaceCapabilitiesKHR(device, g_surface, &ret.capabilities))!;
    vk::check(vk::getPhysicalDeviceSurfaceFormatsKHR(device, g_surface, &ret.formatCount, null))!;
    ret.formats = (vk::SurfaceFormatKHR*)malloc(ret.formatCount * vk::SurfaceFormatKHR.sizeof);
    vk::check(vk::getPhysicalDeviceSurfaceFormatsKHR(device, g_surface, &ret.formatCount, ret.formats))!;
    vk::check(vk::getPhysicalDeviceSurfacePresentModesKHR(device, g_surface, &ret.presentModeCount, null))!;
    ret.presentModes = (vk::PresentModeKHR*)malloc(ret.presentModeCount * vk::PresentModeKHR.sizeof);
    vk::check(vk::getPhysicalDeviceSurfacePresentModesKHR(device, g_surface, &ret.presentModeCount, ret.presentModes))!;
    return ret;
}

struct QueueFamilyIndices {
    uint graphicsFamily;
    uint presentFamily;
}

fn QueueFamilyIndices! findQueueFamilies(vk::PhysicalDevice device) {
    uint count;
    vk::getPhysicalDeviceQueueFamilyProperties(device, &count, null);
    io::printfn("Queue families count: %d", count);
    vk::QueueFamilyProperties* queueFamilies = (vk::QueueFamilyProperties*)malloc(count * vk::QueueFamilyProperties.sizeof);
    defer free(queueFamilies);
    vk::getPhysicalDeviceQueueFamilyProperties(device, &count, queueFamilies);
    QueueFamilyIndices indices;
    bool foundGraphics = false;
    bool foundPresent = false;
    for (uint i = 0; i < count; i++) {
        if (queueFamilies[i].queueFlags.graphics) {
            indices.graphicsFamily = i;
            foundGraphics = true;
            io::printfn("Queue family %d support graphics", i);
        }
        uint supported = glfw::getPhysicalDevicePresentationSupport(g_instance, device, i);
        //vk::check(vk::getPhysicalDeviceSurfaceSupportKHR(device, i, g_surface, &supported))!;
        if (supported) {
            indices.presentFamily = i;
            foundPresent = true;
            io::printfn("Queue family %d support present", i);
        }
        if (foundGraphics && foundPresent) {
            return indices;
        }
    }
    return vk::VulkanError.ERROR_UNKNOWN?;
}

fn void! createLogicalDevice() {
    QueueFamilyIndices indices = findQueueFamilies(g_physicalDevice)!;
    ZString[] layers;
    $if ENABLE_VALIDATION_LAYERS:
		layers = ZString[*] {
		  "VK_LAYER_KHRONOS_validation"
		};
	$endif
    vk::DeviceQueueCreateInfo queueCreateInfo = {
        .sType = vk::STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queueFamilyIndex = indices.graphicsFamily,
        .queueCount = 1,
        .pQueuePriorities = &&1.0f,
    };
    vk::DeviceCreateInfo createInfo = {
        .sType = vk::STRUCTURE_TYPE_DEVICE_CREATE_INFO,
        .queueCreateInfoCount = 1,
        .pQueueCreateInfos = &queueCreateInfo,
        .enabledExtensionCount = REQUIRED_EXTENSIONS.len,
        .ppEnabledExtensionNames = &REQUIRED_EXTENSIONS,
    };
    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabledLayerCount = layers.len;
        createInfo.ppEnabledLayerNames = layers.ptr;
    $endif
    vk::check(vk::createDevice(g_physicalDevice, &createInfo, null, &g_device))!;
    vk::getDeviceQueue(g_device, indices.graphicsFamily, 0, &g_graphicsQueue);
    vk::getDeviceQueue(g_device, indices.presentFamily, 0, &g_presentQueue);
}

fn vk::SurfaceFormatKHR pickSwapSurfaceFormat(vk::SurfaceFormatKHR* formats, int count) {
    for (int i = 0; i < count; i++) {
        if (formats[i].format == vk::FORMAT_B8G8R8A8_SRGB && formats[i].colorSpace == vk::COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            return formats[i];
        }
    }
    return formats[0];
}

fn vk::PresentModeKHR pickSwapPresentMode(vk::PresentModeKHR* presentModes, int count) {
    for (int i = 0; i < count; i++) {
        if (presentModes[i] == vk::PRESENT_MODE_MAILBOX_KHR) {
            return presentModes[i];
        }
    }
    return vk::PRESENT_MODE_FIFO_KHR;
}

fn vk::Extent2D pickSwapExtent(vk::SurfaceCapabilitiesKHR capabilities) {
    if (capabilities.currentExtent.width != uint.max) {
        return capabilities.currentExtent;
    }
    vk::Extent2D actualExtent = {
        .width = 800,
        .height = 600,
    };
    actualExtent.width = max(capabilities.minImageExtent.width, min(capabilities.maxImageExtent.width, actualExtent.width));
    actualExtent.height = max(capabilities.minImageExtent.height, min(capabilities.maxImageExtent.height, actualExtent.height));
    return actualExtent;
}

fn void! createSwapchain() {
    QueueFamilyIndices indices = findQueueFamilies(g_physicalDevice)!;
    SwapchainSupportDetails swapChainSupport = querySwapchainSupport(g_physicalDevice)!;
    vk::PresentModeKHR presentMode = pickSwapPresentMode(swapChainSupport.presentModes, swapChainSupport.presentModeCount);
    g_swapChainFormat = pickSwapSurfaceFormat(swapChainSupport.formats, swapChainSupport.formatCount);
    g_swapChainExtent = pickSwapExtent(swapChainSupport.capabilities);
    g_swapChainImageCount = swapChainSupport.capabilities.minImageCount + 1;
    bool unlimited = swapChainSupport.capabilities.maxImageCount == 0;
    if (!unlimited && g_swapChainImageCount > swapChainSupport.capabilities.maxImageCount) {
        g_swapChainImageCount = swapChainSupport.capabilities.maxImageCount;
    }
    uint[2] indiceArray = {indices.graphicsFamily, indices.presentFamily};
    vk::SwapchainCreateInfoKHR createInfo = {
        .sType = vk::STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = g_surface,
        .minImageCount = g_swapChainImageCount,
        .imageFormat = g_swapChainFormat.format,
        .imageColorSpace = g_swapChainFormat.colorSpace,
        .imageExtent = g_swapChainExtent,
        .imageArrayLayers = 1,
        .imageUsage = vk::ImageUsageFlags { .color_attachment = true },
        .imageSharingMode = vk::SHARING_MODE_EXCLUSIVE,
        .queueFamilyIndexCount = 2,
        .pQueueFamilyIndices = &indiceArray,
        .preTransform = swapChainSupport.capabilities.currentTransform,
        .compositeAlpha = vk::CompositeAlphaFlagsKHR { .opaque = true },
        .presentMode = presentMode,
        .clipped = (uint)true,
        .oldSwapchain = (vk::SwapchainKHR)0,
    };
    if (indices.graphicsFamily != indices.presentFamily) {
        createInfo.imageSharingMode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queueFamilyIndexCount = 2;
        createInfo.pQueueFamilyIndices = &indiceArray;
    }
    vk::check(vk::createSwapchainKHR(g_device, &createInfo, null, &g_swapChain))!;

    vk::check(vk::getSwapchainImagesKHR(g_device, g_swapChain, &g_swapChainImageCount, null))!;
    g_swapChainImages = (vk::Image*)malloc(g_swapChainImageCount * vk::Image.sizeof);
    vk::check(vk::getSwapchainImagesKHR(g_device, g_swapChain, &g_swapChainImageCount, g_swapChainImages))!;
    g_swapChainImageViews = (vk::ImageView*)malloc(g_swapChainImageCount * vk::ImageView.sizeof);
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::ImageViewCreateInfo info = {
            .sType = vk::STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
            .image = g_swapChainImages[i],
            .viewType = vk::IMAGE_VIEW_TYPE_2D,
            .format = g_swapChainFormat.format,
            .subresourceRange = {
                .aspectMask = vk::ImageAspectFlags { .color = true },
                .baseMipLevel = 0,
                .levelCount = 1,
                .baseArrayLayer = 0,
                .layerCount = 1,
            },
        };
        vk::check(vk::createImageView(g_device, &info, null, &g_swapChainImageViews[i]))!;
    }
}

fn void destroySwapchain() {
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::destroyImageView(g_device, g_swapChainImageViews[i], null);
    }
    vk::destroySwapchainKHR(g_device, g_swapChain, null);
    free(g_swapChainImageViews);
    free(g_swapChainImages);
}

fn vk::ShaderModule! createShaderModule(char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .sType = vk::STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .codeSize = code.len,
        .pCode = (uint*)code.ptr,
    };
    vk::ShaderModule ret;
    vk::check(vk::createShaderModule(g_device, &createInfo, null, &ret))!;
    return ret;
}

fn void! loadShader() {
    g_vertexShader = createShaderModule(&VERTEX_CODE)!;
    g_fragmentShader = createShaderModule(&FRAGMENT_CODE)!;
    g_vertexShaderStageInfo[0] = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .vertex = true },
        .module_ = g_vertexShader,
        .pName = "main",
    };
    g_vertexShaderStageInfo[1] = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .fragment = true },
        .module_ = g_fragmentShader,
        .pName = "main",
    };
}

fn void! createRenderPass() {
    vk::RenderPassCreateInfo createInfo = {
        .sType = vk::STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,
        .attachmentCount = 1,
        .pAttachments = &&vk::AttachmentDescription {
            .format = g_swapChainFormat.format,
            .samples = vk::SampleCountFlags { .n_1 = true },
            .loadOp = vk::ATTACHMENT_LOAD_OP_CLEAR,
            .storeOp = vk::ATTACHMENT_STORE_OP_STORE,
            .stencilLoadOp = vk::ATTACHMENT_LOAD_OP_DONT_CARE,
            .stencilStoreOp = vk::ATTACHMENT_STORE_OP_DONT_CARE,
            .initialLayout = vk::IMAGE_LAYOUT_UNDEFINED,
            .finalLayout = vk::IMAGE_LAYOUT_PRESENT_SRC_KHR,
        },
        .subpassCount = 1,
        .pSubpasses = &&vk::SubpassDescription {
            .pipelineBindPoint = vk::PIPELINE_BIND_POINT_GRAPHICS,
            .colorAttachmentCount = 1,
            .pColorAttachments = &&vk::AttachmentReference {
                .attachment = 0,
                .layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
            },
        },
        .dependencyCount = 1,
        .pDependencies = &&vk::SubpassDependency {
            .srcSubpass = vk::SUBPASS_EXTERNAL,
            .dstSubpass = 0,
            .srcStageMask = vk::PipelineStageFlags { .color_attachment_output = true },
            .srcAccessMask = vk::AccessFlags {},
            .dstStageMask = vk::PipelineStageFlags { .color_attachment_output = true },
            .dstAccessMask = vk::AccessFlags { .color_attachment_write = true},
        },
    };
    vk::check(vk::createRenderPass(g_device, &createInfo, null, &g_renderPass))!;
}

fn void! createFrameBuffers() {
    g_swapChainFramebuffers = (vk::Framebuffer*)malloc(g_swapChainImageCount * vk::Framebuffer.sizeof);
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::FramebufferCreateInfo info = {
            .sType = vk::STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,
            .renderPass = g_renderPass,
            .attachmentCount = 1,
            .pAttachments = &g_swapChainImageViews[i],
            .width = g_swapChainExtent.width,
            .height = g_swapChainExtent.height,
            .layers = 1,
        };
        vk::check(vk::createFramebuffer(g_device, &info, null, &g_swapChainFramebuffers[i]))!;
    }
}

fn void destroyFrameBuffers() {
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::destroyFramebuffer(g_device, g_swapChainFramebuffers[i], null);
    }
    free(g_swapChainFramebuffers);
}


fn void! createGraphicsPipeline() {
    vk::DynamicState[*] dynamicStates = {
        vk::DYNAMIC_STATE_VIEWPORT,
        vk::DYNAMIC_STATE_SCISSOR
    };
    vk::PipelineDynamicStateCreateInfo dynamicState = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
        .dynamicStateCount = dynamicStates.len,
        .pDynamicStates = &dynamicStates,
    };
    vk::PipelineVertexInputStateCreateInfo vertexInputInfo = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
    };
    vk::PipelineInputAssemblyStateCreateInfo inputAssembly = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        .topology = vk::PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
    };
    vk::PipelineViewportStateCreateInfo viewportState = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        .viewportCount = 1,
        .scissorCount = 1,
    };
    vk::PipelineRasterizationStateCreateInfo rasterizer = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        .polygonMode = vk::POLYGON_MODE_FILL,
        .cullMode = vk::CullModeFlags { .back = true },
        .frontFace = vk::FRONT_FACE_CLOCKWISE,
        .lineWidth = 1.0,
    };
    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .rasterizationSamples = vk::SampleCountFlags { .n_1 = true },
        .minSampleShading = 1.0,
    };
    vk::PipelineColorBlendAttachmentState colorBlendAttachment = {
        .colorWriteMask = vk::ColorComponentFlags {
            .r = true,
            .g = true,
            .b = true,
            .a = true,
        },
    };
    vk::PipelineColorBlendStateCreateInfo colorBlending = {
        .sType = vk::STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .attachmentCount = 1,
        .pAttachments = &colorBlendAttachment,
    };
    vk::check(vk::createPipelineLayout(
        g_device,
        &&vk::PipelineLayoutCreateInfo {
            .sType = vk::STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        },
        null,
        &g_pipelineLayout))!;
    vk::GraphicsPipelineCreateInfo pipelineInfo = {
        .sType = vk::STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
        .stageCount = 2,
        .pStages = &g_vertexShaderStageInfo,
        .pVertexInputState = &vertexInputInfo,
        .pInputAssemblyState = &inputAssembly,
        .pViewportState = &viewportState,
        .pRasterizationState = &rasterizer,
        .pMultisampleState = &multisampling,
        .pColorBlendState = &colorBlending,
        .pDynamicState = &dynamicState,
        .layout = g_pipelineLayout,
        .renderPass = g_renderPass,
        .subpass = 0,
        .basePipelineIndex = -1,
    };
    vk::check(vk::createGraphicsPipelines(g_device, (vk::PipelineCache)0, 1, &pipelineInfo, null, &g_graphicsPipeline))!;
}

fn void! createCommandPool() {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(g_physicalDevice)!;
    vk::CommandPoolCreateInfo poolInfo = {
        .sType = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = vk::CommandPoolCreateFlags { .reset_command_buffer = true },
        .queueFamilyIndex = queueFamilyIndices.graphicsFamily,
    };
    vk::check(vk::createCommandPool(g_device, &poolInfo, null, &g_commandPool))!;
    vk::CommandBufferAllocateInfo allocInfo = {
        .sType = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .commandPool = g_commandPool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .commandBufferCount = g_commandBuffers.len,
    };
    vk::check(vk::allocateCommandBuffers(g_device, &allocInfo, &g_commandBuffers))!;
}

fn void! createSemaphores() {
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .sType = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .sType = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = vk::FenceCreateFlags { .signaled = true },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::check(vk::createSemaphore(g_device, &semaphoreInfo, null, &g_imageAvailableSemaphore[i]))!;
        vk::check(vk::createSemaphore(g_device, &semaphoreInfo, null, &g_renderFinishedSemaphore[i]))!;
        vk::check(vk::createFence(g_device, &fenceInfo, null, &g_inFlightFences[i]))!;
    }
}

fn void destroySemaphores() {
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(g_device, g_imageAvailableSemaphore[i], null);
        vk::destroySemaphore(g_device, g_renderFinishedSemaphore[i], null);
        vk::destroyFence(g_device, g_inFlightFences[i], null);
    }
}

fn void! render() {
    vk::check(vk::waitForFences(g_device, 1, &g_inFlightFences[g_currentFrame], vk::TRUE, ulong.max))!;
    uint imageIndex;
    anyfault excuse = @catch(vk::check(vk::acquireNextImageKHR(g_device, g_swapChain, ulong.max, g_imageAvailableSemaphore[g_currentFrame], (vk::Fence)0, &imageIndex)));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR) {
        recreateSwapchain()!;
        return;
    }
    if (excuse && excuse != vk::VulkanError.SUBOPTIMAL_KHR) {
        return excuse?;
    }
    vk::check(vk::resetFences(g_device, 1, &g_inFlightFences[g_currentFrame]))!;
    vk::check(vk::resetCommandBuffer(g_commandBuffers[g_currentFrame], CommandBufferResetFlags{}))!;
    recordCommandBuffer(g_commandBuffers[g_currentFrame], imageIndex)!;

    vk::SubmitInfo submitInfo = {
        .sType = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .waitSemaphoreCount = 1,
        .pWaitSemaphores = &g_imageAvailableSemaphore[g_currentFrame],
        .pWaitDstStageMask = &&vk::PipelineStageFlags { .color_attachment_output = true },
        .commandBufferCount = 1,
        .pCommandBuffers = &g_commandBuffers[g_currentFrame],
        .signalSemaphoreCount = 1,
        .pSignalSemaphores = &g_renderFinishedSemaphore[g_currentFrame],
    };
    vk::check(vk::queueSubmit(g_graphicsQueue, 1, &submitInfo, g_inFlightFences[g_currentFrame]))!;
    vk::PresentInfoKHR presentInfo = {
        .sType = vk::STRUCTURE_TYPE_PRESENT_INFO_KHR,
        .waitSemaphoreCount = 1,
        .pWaitSemaphores = &g_renderFinishedSemaphore[g_currentFrame],
        .swapchainCount = 1,
        .pSwapchains = &g_swapChain,
        .pImageIndices = &imageIndex,
    };
    excuse = @catch(vk::check(vk::queuePresentKHR(g_presentQueue, &presentInfo)));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    g_currentFrame = (g_currentFrame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! recordCommandBuffer(vk::CommandBuffer commandBuffer, uint imageIndex) {
    vk::CommandBufferBeginInfo beginInfo = {
        .sType = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    };
    vk::check(vk::beginCommandBuffer(commandBuffer, &beginInfo))!;
    vk::RenderPassBeginInfo renderPassInfo = {
        .sType = vk::STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
        .renderPass = g_renderPass,
        .framebuffer = g_swapChainFramebuffers[imageIndex],
        .renderArea = { .extent = g_swapChainExtent },
        .clearValueCount = 1,
        .pClearValues = &&vk::ClearValue { .color = { .float32 = float[4] { 0.0117, 0.0117, 0.0179, 1.0 } } },
    };
    vk::cmdBeginRenderPass(commandBuffer, &renderPassInfo, vk::SUBPASS_CONTENTS_INLINE);
    vk::cmdBindPipeline(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, g_graphicsPipeline);
    vk::Viewport viewport = {
        .width = g_swapChainExtent.width,
        .height = g_swapChainExtent.height,
        .maxDepth = 1.0,
    };
    vk::Rect2D scissor = {
        .extent = g_swapChainExtent,
    };
    vk::cmdSetViewport(commandBuffer, 0, 1, &viewport);
    vk::cmdSetScissor(commandBuffer, 0, 1, &scissor);
    vk::cmdDraw(commandBuffer, 6, 1, 0, 0);
    vk::cmdEndRenderPass(commandBuffer);
    vk::check(vk::endCommandBuffer(commandBuffer))!;
}

fn void! recreateSwapchain() {
    vk::deviceWaitIdle(g_device);
    destroyFrameBuffers();
    destroySwapchain();
    createSwapchain()!;
    createFrameBuffers()!;
}
