module mj;
import std::time;
import std::math::matrix;
import std::math;
import vk;

const ENGINE_NAME = "Mjolnir";
const TITLE = "Vulkan C3";
const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
    vk::KHR_DYNAMIC_RENDERING_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = false;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};
const MAX_FRAMES_IN_FLIGHT = 2;

struct Renderer {
    glfw::Window* window;
    vk::Instance instance;
    vk::DebugUtilsMessengerEXT debug_messenger @if(ENABLE_VALIDATION_LAYERS);
    vk::SurfaceKHR surface;
    vk::PhysicalDevice physical_device;
    vk::Device device;
    vk::Queue graphics_queue;
    vk::Queue present_queue;
    vk::SurfaceFormatKHR swap_chain_format;
    vk::Extent2D swap_chain_extent;
    vk::SwapchainKHR swap_chain;
    vk::Image[] swap_chain_images;
    vk::ImageView[] swap_chain_image_views;
    vk::CommandPool command_pool;
    struct {
        uint current_frame;
        vk::Semaphore[MAX_FRAMES_IN_FLIGHT] image_available_semaphore;
        vk::Semaphore[MAX_FRAMES_IN_FLIGHT] render_finished_semaphore;
        vk::Fence[MAX_FRAMES_IN_FLIGHT] in_flight_fences;
        vk::CommandBuffer[MAX_FRAMES_IN_FLIGHT] command_buffers;
    }
}

fn void! Renderer.init(Renderer* this, glfw::Window* window) {
    this.window = window;
    this.createVulkanInstance()!;
    this.createWindowSurface()!;
    this.pickPhysicalDevice()!;
    this.createLogicalDevice()!;
    this.createSwapchain()!;
    this.createSemaphores()!;
    this.createCommandPool()!;
    this.createSynchronizers()!;
}

fn void Renderer.destroy(Renderer* this) {
    vk::deviceWaitIdle(this.device)!!;
    this.destroySynchronizers();
    this.destroySwapchain();
    this.destroySemaphores();
    this.destroyCommandPool();
    this.destroyDevice();
    this.destroySurface();
    this.destroyVulkanInstance();
}

fn void! Renderer.createVulkanInstance(Renderer* this) {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* glfwExtensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    ZString* extensions = (ZString*)malloc(extensionCount * ZString.sizeof);
    mem::copy(extensions, glfwExtensions, extensionCount * ZString.sizeof);
    defer free(extensions);
    vk::InstanceCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .p_application_info = &&vk::ApplicationInfo {
            .s_type = vk::STRUCTURE_TYPE_APPLICATION_INFO,
            .p_application_name = TITLE,
            .application_version = vk::@make_version(1, 0, 0),
            .p_engine_name = ENGINE_NAME,
            .engine_version = vk::@make_version(1, 0, 0),
            .api_version = vk::API_VERSION_1_3,
        },
    };
    $if env::DARWIN:
        // Mandatory on macOS
        createInfo.flags.enumerate_portability_khr = true;
        extensionCount++;
        extensions = (ZString*)realloc(extensions, extensionCount * ZString.sizeof);
        extensions[extensionCount - 1] = vk::KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;
    $endif

    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabled_layer_count = VALIDATION_LAYERS.len;
        createInfo.pp_enabled_layer_names = &VALIDATION_LAYERS;
        extensionCount++;
        extensions = (ZString*)realloc(extensions, extensionCount * ZString.sizeof);
        extensions[extensionCount - 1] = vk::EXT_DEBUG_UTILS_EXTENSION_NAME;
        vk::DebugUtilsMessengerCreateInfoEXT debugCreateInfo = {
            .s_type = vk::STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            .message_severity = vk::DebugUtilsMessageSeverityFlagsEXT { .error, .warning, .info },
            .message_type = vk::DebugUtilsMessageTypeFlagsEXT { .general, .validation, .performance, .device_address_binding },
            .pfn_user_callback = fn uint(vk::DebugUtilsMessageSeverityFlagsEXT messageSeverity,
                vk::DebugUtilsMessageTypeFlagsEXT messageType,
                vk::DebugUtilsMessengerCallbackDataEXT* pCallbackData,
                void* pUserData) {
                return 0;
            },
        };
        createInfo.p_next = &debugCreateInfo;
    $endif

    createInfo.enabled_extension_count = (uint)extensionCount;
    createInfo.pp_enabled_extension_names = extensions;
    io::printfn("Required extensions count: %d", (uint)extensionCount);
    for (uint i = 0; i < extensionCount; i++) {
        io::printfn("Required extension: %s", extensions[i]);
    }
    this.instance = vk::createInstance(&createInfo)!;
    vk::loadProcAddressesInstance(this.instance);
    $if ENABLE_VALIDATION_LAYERS:
        this.debug_messenger = vk::createDebugUtilsMessengerEXT(&this.instance, &debugCreateInfo)!;
    $endif
}

fn void Renderer.destroyVulkanInstance(Renderer* this) {
    $if ENABLE_VALIDATION_LAYERS:
        vk::destroyDebugUtilsMessengerEXT(this.instance, this.debug_messenger);
    $endif
    vk::destroyInstance(this.instance);
}

fn void! Renderer.createWindowSurface(Renderer* this) {
    vk::check(glfw::createWindowSurface(this.instance, this.window, null, &this.surface))!;
}

fn void Renderer.destroySurface(Renderer* this) {
    vk::destroySurfaceKHR(this.instance, this.surface);
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    uint score = 0;
    vk::PhysicalDeviceProperties properties = vk::getPhysicalDeviceProperties(device);
    vk::PhysicalDeviceFeatures features = vk::getPhysicalDeviceFeatures(device);
    ZString deviceName = (ZString)properties.device_name[0..];
    io::printfn("Scoring device %s", deviceName);
    defer io::printfn("Device %s scored %d", score);
    $if !env::DARWIN:
        if (!features.geometry_shader) {
            return 0;
        }
    $endif
    vk::ExtensionProperties[]! extensions = vk::enumerateDeviceExtensionProperties(device);
    if (catch excuse = extensions) {
        io::printfn("Cound not get extension list for %s", deviceName);
        return 0;
    }
    defer free(extensions);
    foreach (e:extensions) {
        io::printfn("Extension %s", (ZString)e.extension_name[0..]);
    }
    foreach (required: REQUIRED_EXTENSIONS) {
        bool found = false;
        foreach (e : extensions) {
            ZString name = (ZString)e.extension_name[0..];
            if (name.len() == required.len() && mem::equals(name, required, name.len())) {
                found = true;
                break;
            }
        }
        if (!found) {
            io::printfn("Extension %s not found in %s", required, deviceName);
            return 0;
        }
    }
    SwapchainSupportDetails! support = querySwapchainSupport(device);
    if (catch excuse = support) {
        io::printfn("Cound not get swapchain support for %s", deviceName);
        return 0;
    }
    support.free();
    QueueFamilyIndices! indices = findQueueFamilies(device);
    if (catch excuse = indices) {
        io::printfn("Cound not get queue families for %s", deviceName);
        return 0;
    }
    switch (properties.device_type) {
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
    score += properties.limits.max_image_dimension2d;
    return score;
}

fn void! Renderer.pickPhysicalDevice(Renderer* engine) {
    vk::PhysicalDevice[] devices = vk::enumeratePhysicalDevices(this.instance)!;
    defer free(devices);
    this.physical_device = devices[0];
    uint bestScore = 0;
    foreach (device: devices) {
        int score = scorePhysicalDevice(device);
        io::printfn("Device %x score: %d", device, score);
        if (score > bestScore) {
            this.physical_device = device;
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %x with score %d", this.physical_device, bestScore);
}

fn void Renderer.destroyDevice(Renderer* engine) {
    vk::destroyDevice(this.device);
}

struct SwapchainSupportDetails {
    vk::SurfaceCapabilitiesKHR capabilities;
    vk::SurfaceFormatKHR[] formats;
    vk::PresentModeKHR[] present_modes;
}
fn void SwapchainSupportDetails.free(SwapchainSupportDetails* self) {
    free(self.formats);
    free(self.present_modes);
}

fn SwapchainSupportDetails! querySwapchainSupport(vk::PhysicalDevice device, vk::SurfaceKHR surface) {
    SwapchainSupportDetails ret;
    ret.capabilities = vk::getPhysicalDeviceSurfaceCapabilitiesKHR(device, surface)!;
    ret.formats = vk::getPhysicalDeviceSurfaceFormatsKHR(device, surface)!;
    ret.present_modes = vk::getPhysicalDeviceSurfacePresentModesKHR(device, surface)!;
    return ret;
}

struct QueueFamilyIndices {
    uint graphics_family;
    uint present_family;
}

fn QueueFamilyIndices! Renderer.findQueueFamilies(Renderer* engine) {
    vk::QueueFamilyProperties[] families = vk::getPhysicalDeviceQueueFamilyProperties(this.physical_device);
    QueueFamilyIndices indices;
    bool foundGraphics = false;
    bool foundPresent = false;
    for (uint i = 0; i < families.len; i++) {
        if (families[i].queue_flags.graphics) {
            indices.graphics_family = i;
            foundGraphics = true;
            io::printfn("Queue family %d support graphics", i);
        }
        uint supported = glfw::getPhysicalDevicePresentationSupport(this.instance, this.physical_device, i);
        if (supported) {
            indices.present_family = i;
            foundPresent = true;
            io::printfn("Queue family %d support present", i);
        }
        if (foundGraphics && foundPresent) {
            return indices;
        }
    }
    return vk::VulkanError.ERROR_UNKNOWN?;
}

fn void! Renderer.createLogicalDevice(Renderer* engine) {
    QueueFamilyIndices indices = findQueueFamilies(this.physical_device)!;
    ZString[] layers;
    $if ENABLE_VALIDATION_LAYERS:
        layers = ZString[*] {
          "VK_LAYER_KHRONOS_validation"
        };
    $endif
    float[*] queue_priorities = {1};
    vk::DeviceQueueCreateInfo queueCreateInfo = {
        .s_type = vk::STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queue_family_index = indices.graphics_family,
        .queue_count = queue_priorities.len,
        .p_queue_priorities = &queue_priorities,
    };
    vk::DeviceCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_DEVICE_CREATE_INFO,
        .queue_create_info_count = 1,
        .p_queue_create_infos = &queueCreateInfo,
        .enabled_extension_count = REQUIRED_EXTENSIONS.len,
        .pp_enabled_extension_names = &REQUIRED_EXTENSIONS,
    };
    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabled_layer_count = layers.len;
        createInfo.pp_enabled_layer_names = layers.ptr;
    $endif
    this.device = vk::createDevice(this.physical_device, &createInfo)!;
    this.graphic_queue = vk::getDeviceQueue(this.device, indices.graphics_family, 0);
    this.present_queue = vk::getDeviceQueue(this.device, indices.present_family, 0);
}

fn vk::SurfaceFormatKHR pickSwapSurfaceFormat(vk::SurfaceFormatKHR[] formats) {
    foreach (f: formats) {
        if (f.format != vk::FORMAT_B8G8R8A8_SRGB) {
            continue;
        }
        if(f.color_space != vk::COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            continue;
        }
        return f;
    }
    return formats[0];
}

fn vk::PresentModeKHR pickSwapPresentMode(vk::PresentModeKHR[] presentModes) {
    foreach (p: presentModes) {
        if (p == vk::PRESENT_MODE_MAILBOX_KHR) {
            return p;
        }
    }
    return vk::PRESENT_MODE_FIFO_KHR;
}

fn vk::Extent2D pickSwapExtent(vk::SurfaceCapabilitiesKHR capabilities) {
    if (capabilities.current_extent.width != uint.max) {
        return capabilities.current_extent;
    }
    vk::Extent2D actualExtent = {
        .width = 800,
        .height = 600,
    };
    actualExtent.width = max(capabilities.min_image_extent.width, min(capabilities.max_image_extent.width, actualExtent.width));
    actualExtent.height = max(capabilities.min_image_extent.height, min(capabilities.max_image_extent.height, actualExtent.height));
    return actualExtent;
}

fn void! Renderer.createSwapchain(Renderer* engine) {
    QueueFamilyIndices indices = findQueueFamilies(this.physical_device)!;
    SwapchainSupportDetails supported = querySwapchainSupport(this.physical_device)!;
    vk::PresentModeKHR presentMode = pickSwapPresentMode(supported.present_modes);
    this.swap_chain_format = pickSwapSurfaceFormat(supported.formats);
    this.swap_chain_extent = pickSwapExtent(supported.capabilities);
    uint count = supported.capabilities.min_image_count + 1;
    bool unlimited = supported.capabilities.max_image_count == 0;
    if (!unlimited && count > supported.capabilities.max_image_count) {
        count = supported.capabilities.max_image_count;
    }
    uint[*] indiceArray = { indices.graphics_family, indices.present_family };
    vk::SwapchainCreateInfoKHR createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = this.surface,
        .min_image_count = count,
        .image_format = this.swap_chain_format.format,
        .image_color_space = this.swap_chain_format.color_space,
        .image_extent = this.swap_chain_extent,
        .image_array_layers = 1,
        .image_usage = { .color_attachment },
        .image_sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .queue_family_index_count = indiceArray.len,
        .p_queue_family_indices = &indiceArray,
        .pre_transform = supported.capabilities.current_transform,
        .composite_alpha = { .opaque },
        .present_mode = presentMode,
        .clipped = vk::TRUE,
    };
    if (indices.graphics_family != indices.present_family) {
        createInfo.image_sharing_mode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queue_family_index_count = indiceArray.len;
        createInfo.p_queue_family_indices = &indiceArray;
    }
    this.swap_chain = vk::createSwapchainKHR(this.device, &createInfo)!;
    this.swap_chain_images = vk::getSwapchainImagesKHR(this.device, this.swap_chain)!;
    uint n = this.swap_chain_images.len;
    vk::ImageView* buffer = (vk::ImageView*) malloc(n * vk::ImageView.sizeof);
    this.swap_chain_image_views = buffer[:n];
    for (uint i = 0; i < n; i++) {
        this.swap_chain_image_views[i] = createImageView(this.swap_chain_images[i], this.swap_chain_format.format)!;
    }
}

fn void Renderer.destroySwapchain(Renderer* engine) {
    foreach (view : this.swap_chain_image_views) {
        vk::destroyImageView(this.device, view);
    }
    vk::destroySwapchainKHR(this.device, this.swap_chain);
    free(this.swap_chain_image_views);
    free(this.swap_chain_images);
}

fn void! Renderer.recreateSwapchain(Renderer* engine) {
    vk::deviceWaitIdle(this.device)!;
    destroySwapchain(engine);
    createSwapchain(engine)!;
}

fn void! Renderer.createCommandPool(Renderer* engine) {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(this.physical_device)!;
    vk::CommandPoolCreateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    this.command_pool = vk::createCommandPool(this.device, &info)!;
}

fn void Renderer.destroyCommandPool(Renderer* engine) {
    vk::destroyCommandPool(this.device, this.command_pool);
}

fn vk::CommandBuffer! Renderer.beginSingleTimeCommand(Renderer* engine) {
    vk::CommandBuffer[] command_buffer = vk::allocateCommandBuffers(this.device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = this.command_pool,
        .command_buffer_count = 1,
    })!;
    vk::beginCommandBuffer(command_buffer[0], &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = { .one_time_submit },
    })!;
    return command_buffer[0];
}

fn void! Renderer.endSingleTimeCommand(Renderer* engine, vk::CommandBuffer command_buffer) {
    defer vk::freeCommandBuffers(this.device, this.command_pool, 1, &command_buffer);
    vk::endCommandBuffer(command_buffer)!;
    vk::queueSubmit(this.graphics_queue, 1, &&vk::SubmitInfo {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    }, (vk::Fence)0)!;
    vk::queueWaitIdle(this.graphics_queue)!;
}

fn void! Renderer.createSynchronizers(Renderer* this) {
    vk::CommandBufferAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .command_pool = this.command_pool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_buffer_count = this.command_buffers.len,
    };
    vk::allocateCommandBuffers(this.device, &allocInfo, &this.command_buffers)!;
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .s_type = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .s_type = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = { .signaled },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        this.image_available_semaphore[i] = vk::createSemaphore(this.device, &semaphoreInfo)!;
        this.render_finished_semaphore[i] = vk::createSemaphore(this.device, &semaphoreInfo)!;
        this.in_flight_fences[i] = vk::createFence(this.device, &fenceInfo)!;
    }
}

fn void Renderer.destroySynchronizers(Renderer* this) {
    vk::freeCommandBuffers(this.device, this.command_pool, this.command_buffers.len, &this.command_buffers);
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(this.device, this.image_available_semaphore[i]);
        vk::destroySemaphore(this.device, this.render_finished_semaphore[i]);
        vk::destroyFence(this.device, this.in_flight_fences[i]);
    }
}

fn uint! Renderer.frameBegin(Renderer* renderer) {
    vk::waitForFences(this.device, 1, &renderer.in_flight_fences[renderer.current_frame])!;
    uint! imageIndex = vk::acquireNextImageKHR(this.device, this.swap_chain, ulong.max, renderer.image_available_semaphore[renderer.current_frame], (vk::Fence)0);
    if (catch excuse = imageIndex) {
        if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
            recreateSwapchain()!;
            return;
        }
        return excuse?;
    }
    vk::resetFences(this.device, 1, &renderer.in_flight_fences[renderer.current_frame])!;
    vk::CommandBuffer commandBuffer = renderer.command_buffers[renderer.current_frame];
    vk::resetCommandBuffer(commandBuffer)!;
    vk::beginCommandBuffer(commandBuffer, &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    })!;
    vk::ImageMemoryBarrier barrier_before = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .new_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = this.swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = {},
        .dst_access_mask = {.color_attachment_write},
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        {.top_of_pipe},
        {.color_attachment_output},
        {},
        0, null,
        0, null,
        1, &barrier_before
    );

    // Begin dynamic rendering
    vk::RenderingAttachmentInfoKHR color_attachment = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR,
        .image_view = this.swap_chain_image_views[imageIndex],
        .image_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .load_op = vk::ATTACHMENT_LOAD_OP_CLEAR,
        .store_op = vk::ATTACHMENT_STORE_OP_STORE,
        .clear_value = { .color = { .float32 = {0.0117, 0.0117, 0.0179, 1.0} } }
    };

    vk::RenderingInfoKHR render_info = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_INFO_KHR,
        .render_area = {.extent = this.swap_chain_extent},
        .layer_count = 1,
        .color_attachment_count = 1,
        .p_color_attachments = &color_attachment
    };
    vk::cmdBeginRenderingKHR(commandBuffer, &render_info);
    vk::cmdSetViewport(commandBuffer, 0, 1, &&vk::Viewport {
        .width = this.swap_chain_extent.width,
        .height = this.swap_chain_extent.height,
        .max_depth = 1.0,
    });
    vk::cmdSetScissor(commandBuffer, 0, 1, &&vk::Rect2D {
        .extent = this.swap_chain_extent,
    });
    return imageIndex;
}

fn void! Renderer.frameEnd(Renderer* this, uint imageIndex) {
    vk::CommandBuffer commandBuffer = this.command_buffers[this.current_frame];
    vk::cmdEndRenderingKHR(commandBuffer);
    // Transition to PRESENT_SRC_KHR
    vk::ImageMemoryBarrier barrier_after = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .new_layout = vk::IMAGE_LAYOUT_PRESENT_SRC_KHR,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = this.swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = {.color_attachment_write},
        .dst_access_mask = {}
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        {.color_attachment_output},
        {.bottom_of_pipe},
        {},
        0, null,
        0, null,
        1, &barrier_after
    );
    vk::endCommandBuffer(commandBuffer)!;
    vk::SubmitInfo submitInfo = {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &this.image_available_semaphore[this.current_frame],
        .p_wait_dst_stage_mask = &&vk::PipelineStageFlags { .color_attachment_output },
        .command_buffer_count = 1,
        .p_command_buffers = &this.command_buffers[this.current_frame],
        .signal_semaphore_count = 1,
        .p_signal_semaphores = &this.render_finished_semaphore[this.current_frame],
    };
    vk::queueSubmit(this.graphics_queue, 1, &submitInfo, this.in_flight_fences[this.current_frame])!;
    vk::PresentInfoKHR presentInfo = {
        .s_type = vk::STRUCTURE_TYPE_PRESENT_INFO_KHR,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &this.render_finished_semaphore[this.current_frame],
        .swapchain_count = 1,
        .p_swapchains = &this.swap_chain,
        .p_image_indices = &imageIndex,
    };
    anyfault excuse = @catch(vk::queuePresentKHR(this.present_queue, &presentInfo));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    this.current_frame = (this.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! Renderer.frameRender(Renderer* this, Scene* scene, ResourceManager* resource_manager) {
    vk::CommandBuffer command_buffer = this.command_buffers[this.current_frame];
    List(<NodeHandle>) node_stack;
    List(<Matrix4f>) transform_stack;
    defer {
        node_stack.free();
        transform_stack.free();
    }
    node_stack.push(scene.root);
    transform_stack.push(Matrix4f.IDENTITY);
    while (!node_stack.empty()) {
        Node* node = getNode(resource_manager, node_stack.pop());
        Matrix4f local_matrix = calculateTransform(node.transform);
        Matrix4f world_matrix = transform_stack.pop().mul(local_matrix);
        switch (node.type) {
            case NodeType.STATIC_MESH: {
                StaticMeshGPU* mesh = getStaticMeshGPU(resource_manager, node.static_mesh);
                MaterialGPU* material = getMaterialGPU(resource_manager, node.material);
                vk::cmdBindPipeline(command_buffer, vk::PIPELINE_BIND_POINT_GRAPHICS, material.pipeline);
                vk::DescriptorSet[*] descriptor_sets = {
                    scene.gpu.descriptor_sets[renderer.current_frame],
                    material.descriptor_sets[renderer.current_frame]
                };
                vk::cmdBindDescriptorSets(
                    command_buffer,
                    vk::PIPELINE_BIND_POINT_GRAPHICS,
                    material.pipeline_layout,
                    0,
                    descriptor_sets.len,
                    &descriptor_sets,
                    0,
                    null
                );
                vk::cmdPushConstants(
                    command_buffer,
                    material.pipeline_layout,
                    {.vertex},
                    0,
                    sizeof(Matrix4f),
                    &world_matrix
                );
                vk::DeviceSize[*] offsets = {0};
                vk::cmdBindVertexBuffers(command_buffer, 0, 1, &mesh.vertex.buffer, offsets);
                vk::cmdBindIndexBuffer(command_buffer, mesh.index.buffer, 0, vk::INDEX_TYPE_UINT32);
                vk::cmdDrawIndexed(command_buffer, mesh.index_count, 1, 0, 0, 0);
                break;
            }
            default:
                break;
        }
        foreach (child : current_node.children) {
            node_stack.push(child);
            transform_stack.push(world_matrix);
        }
    }
}

fn void! Renderer.render(Renderer* this, Scene* scene) {
    uint imageIdx = this.frameBegin();
    this.frameRender(scene);
    this.frameEnd(imageIdx);
}
