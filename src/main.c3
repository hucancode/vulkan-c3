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

const MAX_FRAMES_IN_FLIGHT = 2;

glfw::Window* g_window;
vk::Instance g_instance;
vk::SurfaceKHR g_surface;
vk::DebugUtilsMessengerEXT g_debugMessenger;

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
    defer {
        vk::destroySurfaceKHR(g_instance, g_surface, null);
        vk::destroyInstance(g_instance, null);
    }
    pickPhysicalDevice()!!;
    io::print("Physical device picked\n");
    createLogicalDevice()!!;
    defer vk::destroyDevice(g_device, null);
    io::print("Logical device created\n");
    createSwapchain()!!;
    defer destroySwapchain();
    io::print("Swap chain created\n");
    loadShader()!!;
    defer {
        vk::destroyShaderModule(g_device, g_vertexShader, null);
        vk::destroyShaderModule(g_device, g_fragmentShader, null);
    }
    io::print("Shader module created\n");
    createRenderPass()!!;
    defer vk::destroyRenderPass(g_device, g_renderPass, null);
    io::print("Render pass created\n");
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
fn uint logCallback(vk::DebugUtilsMessageSeverityFlagsEXT messageSeverity, vk::DebugUtilsMessageTypeFlagsEXT messageType, vk::DebugUtilsMessengerCallbackDataEXT* pCallbackData, void* pUserData) @if(ENABLE_VALIDATION_LAYERS) {
    io::printfn("Validation layer: %s", pCallbackData.pMessage);
    return 0;
}
fn void! createVulkanInstance() {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* extensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    vk::InstanceCreateInfo createInfo = {
        .sType = vk::StructureType.INSTANCE_CREATE_INFO,
        .pApplicationInfo = &&vk::ApplicationInfo {
            .sType = vk::StructureType.APPLICATION_INFO,
            .pApplicationName = "Hello VK",
            .applicationVersion = vk::@make_version(1, 0, 0),
            .pEngineName = "No Engine",
            .engineVersion = vk::@make_version(1, 0, 0),
            .apiVersion = vk::API_VERSION_1_3,
        },
    };
    $if ENABLE_VALIDATION_LAYERS:
        extensionCount += 1;
        ZString* ext2 = (ZString*)malloc(extensionCount * ZString.sizeof);
        mem::copy(ext2, extensions, (extensionCount - 1) * ZString.sizeof);
        extensions = ext2;
        extensions[extensionCount - 1] = vk::EXT_DEBUG_UTILS_EXTENSION_NAME;
        createInfo.enabledLayerCount = VALIDATION_LAYERS.len;
        createInfo.ppEnabledLayerNames = &VALIDATION_LAYERS;
        io::printfn("vk::StructureType.DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT = %d", (int)vk::StructureType.DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT);
        vk::DebugUtilsMessengerCreateInfoEXT debugCreateInfo = {
            .sType = vk::StructureType.DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            .messageSeverity = vk::DebugUtilsMessageSeverityFlagsEXT {
                .error = true,
                .warning = true,
                .info = true,
            },
            .messageType = vk::DebugUtilsMessageTypeFlagsEXT {
                .general = true,
                .validation = true,
                .performance = true,
            },
            .pfnUserCallback = &logCallback,
        };
        createInfo.pNext = &debugCreateInfo;
    $endif

    createInfo.enabledExtensionCount = (uint)extensionCount;
    createInfo.ppEnabledExtensionNames = extensions;
    io::printfn("Required extensions count: %d", extensionCount);
    for (uint i = 0; i < extensionCount; i++) {
        io::printfn("Required extension: %s", extensions[i]);
    }
    vk::check(vk::createInstance(&createInfo, null, &g_instance))!;
    io::print("Vulkan instance created\n");
    vk::loadProcAddressesInstance(g_instance);
    $if ENABLE_VALIDATION_LAYERS:
        vk::check(vk::createDebugUtilsMessengerEXT(
            g_instance,
            &debugCreateInfo,
            null,
            &g_debugMessenger
        ))!;
    $endif
    vk::check(glfw::createWindowSurface(g_instance, g_window, null, &g_surface))!;
    io::print("window surface created\n");
}

fn vk::ExtensionProperties*! getAvailableExtensions() {
    uint extensionCount;
    vk::ExtensionProperties* extensions;
    vk::check(vk::enumerateInstanceExtensionProperties(null, &extensionCount, null))!;
    extensions = (vk::ExtensionProperties*)malloc(extensionCount * vk::ExtensionProperties.sizeof);
    vk::check(vk::enumerateInstanceExtensionProperties(null, &extensionCount, extensions))!;
    return extensions;
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    vk::PhysicalDeviceProperties properties;
    vk::PhysicalDeviceFeatures features;
    io::printfn("Checking device %d", device);
    vk::getPhysicalDeviceProperties(device, &properties);
    io::printfn("fetched device properperty %s", (ZString)properties.deviceName[0..]);
    vk::getPhysicalDeviceFeatures(device, &features);
    uint score = 0;
    if (properties.deviceType == vk::PhysicalDeviceType.DISCRETE_GPU) {
        score += 100_000;
    }
    score += properties.limits.maxImageDimension2D;
    // TODO: check fore more conditions
    return score;
}

fn void! pickPhysicalDevice() {
    uint count;
    vk::PhysicalDevice* devices;
    vk::check(vk::enumeratePhysicalDevices(g_instance, &count, null))!;
    io::printfn("Physical devices count: %d", count);
    devices = (vk::PhysicalDevice*)malloc(count * vk::PhysicalDevice.sizeof);
    defer free(devices);
    vk::check(vk::enumeratePhysicalDevices(g_instance, &count, devices))!;
    io::printfn("Got devices details %d", count);
    g_physicalDevice = devices[0];
    uint bestScore = 0;
    for (int i = 0; i < count; i++) {
        int score = scorePhysicalDevice(devices[i]);
        io::printfn("Device %d score: %d", i, score);
        if (score > bestScore) {
            g_physicalDevice = devices[i];
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %d with score %d", g_physicalDevice, bestScore);
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
    vk::QueueFamilyProperties* queueFamilies;
    vk::getPhysicalDeviceQueueFamilyProperties(device, &count, null);
    io::printfn("Queue families count: %d", count);
    queueFamilies = (vk::QueueFamilyProperties*)malloc(count * vk::QueueFamilyProperties.sizeof);
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
        uint supported;
        vk::check(vk::getPhysicalDeviceSurfaceSupportKHR(device, i, g_surface, &supported))!;
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
    if (ENABLE_VALIDATION_LAYERS) {
		layers = ZString[*] {
		  "VK_LAYER_KHRONOS_validation"
		};
	};
    vk::DeviceQueueCreateInfo queueCreateInfo = {
        .sType = vk::StructureType.DEVICE_QUEUE_CREATE_INFO,
        .queueFamilyIndex = indices.graphicsFamily,
        .queueCount = 1,
        .pQueuePriorities = &&1.0f,
    };
    vk::DeviceCreateInfo createInfo = {
        .sType = vk::StructureType.DEVICE_CREATE_INFO,
        .queueCreateInfoCount = 1,
        .pQueueCreateInfos = &queueCreateInfo,
        .enabledExtensionCount = REQUIRED_EXTENSIONS.len,
        .ppEnabledExtensionNames = &REQUIRED_EXTENSIONS,
        .enabledLayerCount = layers.len,
        .ppEnabledLayerNames = layers.ptr,
    };
    vk::check(vk::createDevice(g_physicalDevice, &createInfo, null, &g_device))!;
    vk::getDeviceQueue(g_device, indices.graphicsFamily, 0, &g_graphicsQueue);
    vk::getDeviceQueue(g_device, indices.presentFamily, 0, &g_presentQueue);
}

fn vk::SurfaceFormatKHR pickSwapSurfaceFormat(vk::SurfaceFormatKHR* formats, int count) {
    for (int i = 0; i < count; i++) {
        if (formats[i].format == vk::Format.B8G8R8A8_SRGB && formats[i].colorSpace == vk::ColorSpaceKHR.SRGB_NONLINEAR) {
            return formats[i];
        }
    }
    return formats[0];
}

fn vk::PresentModeKHR pickSwapPresentMode(vk::PresentModeKHR* presentModes, int count) {
    for (int i = 0; i < count; i++) {
        if (presentModes[i] == vk::PresentModeKHR.MAILBOX) {
            return presentModes[i];
        }
    }
    return vk::PresentModeKHR.FIFO;
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
        .sType = vk::StructureType.SWAPCHAIN_CREATE_INFO_KHR,
        .surface = g_surface,
        .minImageCount = g_swapChainImageCount,
        .imageFormat = g_swapChainFormat.format,
        .imageColorSpace = g_swapChainFormat.colorSpace,
        .imageExtent = g_swapChainExtent,
        .imageArrayLayers = 1,
        .imageUsage = vk::ImageUsageFlags { .color_attachment = true },
        .imageSharingMode = vk::SharingMode.EXCLUSIVE,
        .queueFamilyIndexCount = 2,
        .pQueueFamilyIndices = &indiceArray,
        .preTransform = swapChainSupport.capabilities.currentTransform,
        .compositeAlpha = vk::CompositeAlphaFlagsKHR { .opaque = true },
        .presentMode = presentMode,
        .clipped = (uint)true,
        .oldSwapchain = (vk::SwapchainKHR)0,
    };
    if (indices.graphicsFamily != indices.presentFamily) {
        createInfo.imageSharingMode = vk::SharingMode.CONCURRENT;
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
            .sType = vk::StructureType.IMAGE_VIEW_CREATE_INFO,
            .image = g_swapChainImages[i],
            .viewType = vk::ImageViewType.D2,
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
    g_swapChainFramebuffers = (vk::Framebuffer*)malloc(g_swapChainImageCount * vk::Framebuffer.sizeof);
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::FramebufferCreateInfo info = {
            .sType = vk::StructureType.FRAMEBUFFER_CREATE_INFO,
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

fn void destroySwapchain() {
    for (uint i = 0; i < g_swapChainImageCount; i++) {
        vk::destroyImage(g_device, g_swapChainImages[i], null);
        vk::destroyImageView(g_device, g_swapChainImageViews[i], null);
        vk::destroyFramebuffer(g_device, g_swapChainFramebuffers[i], null);
    }
    vk::destroySwapchainKHR(g_device, g_swapChain, null);
    free(g_swapChainImageViews);
    free(g_swapChainImages);
    free(g_swapChainFramebuffers);
}

fn vk::ShaderModule! createShaderModule(char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .sType = vk::StructureType.SHADER_MODULE_CREATE_INFO,
        .codeSize = code.len,
        .pCode = (uint*)code.ptr,
    };
    vk::ShaderModule ret;
    vk::check(vk::createShaderModule(g_device, &createInfo, null, &ret))!;
    return ret;
}

fn void! loadShader() {
    char[*] vertexCode = $embed("shaders/vert.spv");
    g_vertexShader = createShaderModule(&vertexCode)!;
    char[*] fragmentCode = $embed("shaders/frag.spv");
    g_fragmentShader = createShaderModule(&fragmentCode)!;
    g_vertexShaderStageInfo[0] = {
        .sType = vk::StructureType.PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .vertex = true },
        .module_ = g_vertexShader,
        .pName = "main",
    };
    g_vertexShaderStageInfo[1] = {
        .sType = vk::StructureType.PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .fragment = true },
        .module_ = g_fragmentShader,
        .pName = "main",
    };
}

fn void! createRenderPass() {
    vk::AttachmentDescription colorAttachment = {
        .format = g_swapChainFormat.format,
        .samples = vk::SampleCountFlags { .n_1 = true },
        .loadOp = vk::AttachmentLoadOp.CLEAR,
        .storeOp = vk::AttachmentStoreOp.STORE,
        .stencilLoadOp = vk::AttachmentLoadOp.DONT_CARE,
        .stencilStoreOp = vk::AttachmentStoreOp.DONT_CARE,
        .initialLayout = vk::ImageLayout.UNDEFINED,
        .finalLayout = vk::ImageLayout.PRESENT_SRC_KHR,
    };
    vk::AttachmentReference colorAttachmentRef = {
        .attachment = 0,
        .layout = vk::ImageLayout.COLOR_ATTACHMENT_OPTIMAL,
    };
    vk::SubpassDescription subpass = {
        .pipelineBindPoint = vk::PipelineBindPoint.GRAPHICS,
        .colorAttachmentCount = 1,
        .pColorAttachments = &colorAttachmentRef,
    };
    vk::SubpassDependency dependency = {
        .srcSubpass = vk::SUBPASS_EXTERNAL,
        .dstSubpass = 0,
        .srcStageMask = vk::PipelineStageFlags { .color_attachment_output = true },
        .srcAccessMask = vk::AccessFlags {},
        .dstStageMask = vk::PipelineStageFlags { .color_attachment_output = true },
        .dstAccessMask = vk::AccessFlags {.color_attachment_read=true,.color_attachment_write=true},
    };
    vk::RenderPassCreateInfo createInfo = {
        .sType = vk::StructureType.RENDER_PASS_CREATE_INFO,
        .attachmentCount = 1,
        .pAttachments = &colorAttachment,
        .subpassCount = 1,
        .pSubpasses = &subpass,
        .dependencyCount = 1,
        .pDependencies = &dependency,
    };
    vk::check(vk::createRenderPass(g_device, &createInfo, null, &g_renderPass))!;
}

fn void! createGraphicsPipeline() {
    vk::PipelineDynamicStateCreateInfo dynamicState = {
        .sType = vk::StructureType.PIPELINE_DYNAMIC_STATE_CREATE_INFO,
        .dynamicStateCount = 2,
        .pDynamicStates = &&vk::DynamicState[*] {vk::DynamicState.VIEWPORT, vk::DynamicState.SCISSOR},
    };

    vk::PipelineVertexInputStateCreateInfo vertexInputInfo = {
        .sType = vk::StructureType.PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
    };

    vk::PipelineInputAssemblyStateCreateInfo inputAssembly = {
        .sType = vk::StructureType.PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        .topology = vk::PrimitiveTopology.TRIANGLE_LIST,
    };

    vk::PipelineViewportStateCreateInfo viewportState = {
        .sType = vk::StructureType.PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        .viewportCount = 1,
        .scissorCount = 1,
    };

    vk::PipelineRasterizationStateCreateInfo rasterizer = {
        .sType = vk::StructureType.PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        .polygonMode = vk::PolygonMode.FILL,
        .cullMode = vk::CullModeFlags { .back = true },
        .frontFace = vk::FrontFace.CLOCKWISE,
        .lineWidth = 1.0,
    };

    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .sType = vk::StructureType.PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
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
        .sType = vk::StructureType.PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .logicOp = vk::LogicOp.COPY,
        .attachmentCount = 1,
        .pAttachments = &colorBlendAttachment,
    };

    vk::PipelineLayoutCreateInfo pipelineLayoutInfo = {
        .sType = vk::StructureType.PIPELINE_LAYOUT_CREATE_INFO,
    };

    vk::check(vk::createPipelineLayout(g_device, &pipelineLayoutInfo, null, &g_pipelineLayout))!;

    vk::GraphicsPipelineCreateInfo pipelineInfo = {
        .sType = vk::StructureType.GRAPHICS_PIPELINE_CREATE_INFO,
        .stageCount = 2,
        .pStages = &g_vertexShaderStageInfo[0],
        .pVertexInputState = &vertexInputInfo,
        .pInputAssemblyState = &inputAssembly,
        .pViewportState = &viewportState,
        .pRasterizationState = &rasterizer,
        .pMultisampleState = &multisampling,
        .pColorBlendState = &colorBlending,
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
        .sType = vk::StructureType.COMMAND_POOL_CREATE_INFO,
        .queueFamilyIndex = queueFamilyIndices.graphicsFamily,
    };
    vk::check(vk::createCommandPool(g_device, &poolInfo, null, &g_commandPool))!;
    vk::CommandBufferAllocateInfo allocInfo = {
        .sType = vk::StructureType.COMMAND_BUFFER_ALLOCATE_INFO,
        .commandPool = g_commandPool,
        .level = vk::CommandBufferLevel.PRIMARY,
        .commandBufferCount = g_commandBuffers.len,
    };
    vk::check(vk::allocateCommandBuffers(g_device, &allocInfo, &g_commandBuffers))!;
}

fn void! createSemaphores() {
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .sType = vk::StructureType.SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .sType = vk::StructureType.FENCE_CREATE_INFO,
        .flags = vk::FenceCreateFlags { .signaled = true },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::check(vk::createSemaphore(g_device, &semaphoreInfo, null, &g_imageAvailableSemaphore))!;
        vk::check(vk::createSemaphore(g_device, &semaphoreInfo, null, &g_renderFinishedSemaphore))!;
        vk::check(vk::createFence(g_device, &fenceInfo, null, &g_inFlightFences))!;
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
    vk::check(vk::waitForFences(g_device, 1, &g_inFlightFences[g_currentFrame], (uint)true, uint.max))!;
    uint imageIndex;
    anyfault excuse = @catch(vk::check(vk::acquireNextImageKHR(g_device, g_swapChain, uint.max, g_imageAvailableSemaphore[g_currentFrame], (vk::Fence)0, &imageIndex)));
    if (excuse) {
        if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR) {
            recreateSwapchain()!;
            return;
        }
        if (excuse != vk::VulkanError.SUBOPTIMAL_KHR) {
            return excuse?;
        }
    }
    vk::check(vk::resetFences(g_device, 1, &g_inFlightFences[g_currentFrame]))!;
    vk::check(vk::resetCommandBuffer(g_commandBuffers[g_currentFrame], CommandBufferResetFlags{}))!;
    recordCommandBuffer(g_commandBuffers[g_currentFrame], imageIndex)!;

    vk::SubmitInfo submitInfo = {
        .sType = vk::StructureType.SUBMIT_INFO,
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
        .sType = vk::StructureType.PRESENT_INFO_KHR,
        .waitSemaphoreCount = 1,
        .pWaitSemaphores = &g_renderFinishedSemaphore[g_currentFrame],
        .swapchainCount = 1,
        .pSwapchains = &g_swapChain,
        .pImageIndices = &imageIndex,
    };
    excuse = @catch(vk::check(vk::queuePresentKHR(g_presentQueue, &presentInfo)));
    if (excuse) {
        if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
            recreateSwapchain()!;
        } else {
            return excuse?;
        }
    }
    g_currentFrame = (g_currentFrame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! recordCommandBuffer(vk::CommandBuffer commandBuffer, uint imageIndex) {
    vk::CommandBufferBeginInfo beginInfo = {
        .sType = vk::StructureType.COMMAND_BUFFER_BEGIN_INFO,
    };
    vk::check(vk::beginCommandBuffer(commandBuffer, &beginInfo))!;

    vk::RenderPassBeginInfo renderPassInfo = {
        .sType = vk::StructureType.RENDER_PASS_BEGIN_INFO,
        .renderPass = g_renderPass,
        .framebuffer = g_swapChainFramebuffers[imageIndex],
        .renderArea = {
            .offset = { .x = 0, .y = 0 },
            .extent = g_swapChainExtent,
        },
        .clearValueCount = 1,
        .pClearValues = &&ClearValue {
            .color = {
                .float32 = float[4] { 0.0, 0.0, 0.0, 1.0 }
            },
        },
    };
    vk::cmdBeginRenderPass(commandBuffer, &renderPassInfo, vk::SubpassContents.INLINE);
    defer vk::cmdEndRenderPass(commandBuffer);
    vk::cmdBindPipeline(commandBuffer, vk::PipelineBindPoint.GRAPHICS, g_graphicsPipeline);
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
    vk::check(vk::endCommandBuffer(commandBuffer))!;
}

fn void! recreateSwapchain() {
    vk::deviceWaitIdle(g_device);
    destroySwapchain();
    createSwapchain()!;
}
