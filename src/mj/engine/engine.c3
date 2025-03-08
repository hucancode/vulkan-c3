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

struct Engine {
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
    vk::Semaphore[MAX_FRAMES_IN_FLIGHT] image_available_semaphore;
    vk::Semaphore[MAX_FRAMES_IN_FLIGHT] render_finished_semaphore;
    vk::Fence[MAX_FRAMES_IN_FLIGHT] in_flight_fences;
    vk::CommandPool command_pool;
    vk::CommandBuffer[] command_buffers;
    vk::Buffer[MAX_FRAMES_IN_FLIGHT] uniform_buffers;
    vk::DeviceMemory[MAX_FRAMES_IN_FLIGHT] uniform_memory;
    void*[MAX_FRAMES_IN_FLIGHT] uniform_buffer_mapped;
    uint current_frame;
}

fn void! init(Engine* engine, glfw::Window* window) {
    engine.window = window;
    createVulkanInstance(engine)!;
    createWindowSurface(engine)!;
    pickPhysicalDevice(engine)!;
    createLogicalDevice(engine)!;
    createSwapchain(engine)!;
    createSemaphores(engine)!;
    createCommandPool(engine)!;
    createUBO(engine);
}

fn void destroy(Engine* engine) {
    vk::deviceWaitIdle(engine.device)!!;
    destroySemaphores(engine);
    destroyCommandPool(engine);
    destroyGraphicsPipeline(engine);
    destroyDescriptorSetLayout(engine);
    destroyDescriptorSets(engine);
    destroySwapchain(engine);
    destroyDevice(engine);
    destroySurface(engine);
    destroyVulkanInstance(engine);
}

fn void update(Engine* engine) {
    engine.ubo.time = (float)time::now().diff_sec(g_start_timestamp);
    engine.ubo.model = matrix::IDENTITY4(<float>)
        .rotate_x((float)math::sin(g_ubo.time*0.53))
        .rotate_y((float)math::sin(g_ubo.time*0.97))
        .rotate_z((float)math::sin(g_ubo.time*1.17))
        .transpose();
    engine.last_frame_timestamp = time::now();
    updateUniforms();
}

fn void! createVulkanInstance(Engine* engine) {
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
    engine.instance = vk::createInstance(&createInfo)!;
    vk::loadProcAddressesInstance(engine.instance);
    $if ENABLE_VALIDATION_LAYERS:
        engine.debug_messenger = vk::createDebugUtilsMessengerEXT(&engine.instance, &debugCreateInfo)!;
    $endif
}

fn void destroyVulkanInstance(Engine* engine) {
    $if ENABLE_VALIDATION_LAYERS:
        vk::destroyDebugUtilsMessengerEXT(engine.instance, engine.debug_messenger);
    $endif
    vk::destroyInstance(engine.instance);
}

fn void! createWindowSurface(Engine* engine) {
    vk::check(glfw::createWindowSurface(engine.instance, engine.window, null, &engine.surface))!;
}

fn void destroySurface(Engine* engine) {
    vk::destroySurfaceKHR(engine.instance, engine.surface);
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

fn void! pickPhysicalDevice(Engine* engine) {
    vk::PhysicalDevice[] devices = vk::enumeratePhysicalDevices(engine.instance)!;
    defer free(devices);
    engine.physical_device = devices[0];
    uint bestScore = 0;
    foreach (device: devices) {
        int score = scorePhysicalDevice(device);
        io::printfn("Device %x score: %d", device, score);
        if (score > bestScore) {
            engine.physical_device = device;
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %x with score %d", engine.physical_device, bestScore);
}

fn void destroyDevice(Engine* engine) {
    vk::destroyDevice(engine.device);
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

fn QueueFamilyIndices! findQueueFamilies(Engine* engine, vk::SurfaceKHR surface) {
    vk::QueueFamilyProperties[] families = vk::getPhysicalDeviceQueueFamilyProperties(engine.physical_device);
    QueueFamilyIndices indices;
    bool foundGraphics = false;
    bool foundPresent = false;
    for (uint i = 0; i < families.len; i++) {
        if (families[i].queue_flags.graphics) {
            indices.graphics_family = i;
            foundGraphics = true;
            io::printfn("Queue family %d support graphics", i);
        }
        uint supported = glfw::getPhysicalDevicePresentationSupport(engine.instance, engine.physical_device, i);
        // uint! supported = vk::getPhysicalDeviceSurfaceSupportKHR(engine.physical_device, i, surface);
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

fn void! createLogicalDevice(Engine* engine) {
    QueueFamilyIndices indices = findQueueFamilies(engine.physical_device)!;
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
    engine.device = vk::createDevice(engine.physical_device, &createInfo)!;
    engine.graphic_queue = vk::getDeviceQueue(engine.device, indices.graphics_family, 0);
    engine.present_queue = vk::getDeviceQueue(engine.device, indices.present_family, 0);
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

fn void! createSwapchain(Engine* engine) {
    QueueFamilyIndices indices = findQueueFamilies(engine.physical_device)!;
    SwapchainSupportDetails supported = querySwapchainSupport(engine.physical_device)!;
    vk::PresentModeKHR presentMode = pickSwapPresentMode(supported.present_modes);
    engine.swap_chain_format = pickSwapSurfaceFormat(supported.formats);
    engine.swap_chain_extent = pickSwapExtent(supported.capabilities);
    uint count = supported.capabilities.min_image_count + 1;
    bool unlimited = supported.capabilities.max_image_count == 0;
    if (!unlimited && count > supported.capabilities.max_image_count) {
        count = supported.capabilities.max_image_count;
    }
    uint[*] indiceArray = { indices.graphics_family, indices.present_family };
    vk::SwapchainCreateInfoKHR createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = engine.surface,
        .min_image_count = count,
        .image_format = engine.swap_chain_format.format,
        .image_color_space = engine.swap_chain_format.color_space,
        .image_extent = engine.swap_chain_extent,
        .image_array_layers = 1,
        .image_usage = vk::ImageUsageFlags { .color_attachment },
        .image_sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .queue_family_index_count = indiceArray.len,
        .p_queue_family_indices = &indiceArray,
        .pre_transform = supported.capabilities.current_transform,
        .composite_alpha = vk::CompositeAlphaFlagsKHR { .opaque },
        .present_mode = presentMode,
        .clipped = vk::TRUE,
    };
    if (indices.graphics_family != indices.present_family) {
        createInfo.image_sharing_mode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queue_family_index_count = indiceArray.len;
        createInfo.p_queue_family_indices = &indiceArray;
    }
    engine.swap_chain = vk::createSwapchainKHR(engine.device, &createInfo)!;
    engine.swap_chain_images = vk::getSwapchainImagesKHR(engine.device, engine.swap_chain)!;
    uint n = engine.swap_chain_images.len;
    vk::ImageView* buffer = (vk::ImageView*) malloc(n * vk::ImageView.sizeof);
    engine.swap_chain_image_views = buffer[:n];
    for (uint i = 0; i < n; i++) {
        engine.swap_chain_image_views[i] = createImageView(engine.swap_chain_images[i], engine.swap_chain_format.format)!;
    }
}

fn void destroySwapchain(Engine* engine) {
    foreach (view : engine.swap_chain_image_views) {
        vk::destroyImageView(engine.device, view);
    }
    vk::destroySwapchainKHR(engine.device, engine.swap_chain);
    free(engine.swap_chain_image_views);
    free(engine.swap_chain_images);
}

fn void! recreateSwapchain(Engine* engine) {
    vk::deviceWaitIdle(engine.device)!;
    destroySwapchain(engine);
    createSwapchain(engine)!;
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

fn vk::DeviceMemory! allocateMemory(vk::Device device, vk::MemoryRequirements req, vk::MemoryPropertyFlags properties) {
    vk::MemoryAllocateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = req.size,
        .memory_type_index = findMemoryType(req.memory_type_bits, properties)!,
    };
    return vk::allocateMemory(device, &info)!;
}

fn void! createSemaphores(Engine* engine) {
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .s_type = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .s_type = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = vk::FenceCreateFlags { .signaled },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        engine.image_available_semaphore[i] = vk::createSemaphore(engine.device, &semaphoreInfo)!;
        engine.render_finished_semaphore[i] = vk::createSemaphore(engine.device, &semaphoreInfo)!;
        engine.in_flight_fences[i] = vk::createFence(engine.device, &fenceInfo)!;
    }
}

fn void destroySemaphores(Engine* engine) {
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(engine.device, engine.image_available_semaphore[i]);
        vk::destroySemaphore(engine.device, engine.render_finished_semaphore[i]);
        vk::destroyFence(engine.device, engine.in_flight_fences[i]);
    }
}

fn void! createCommandPool(Engine* engine) {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(engine.physical_device)!;
    vk::CommandPoolCreateInfo poolInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = vk::CommandPoolCreateFlags { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    engine.command_pool = vk::createCommandPool(engine.device, &poolInfo)!;
    vk::CommandBufferAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .command_pool = engine.command_pool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_buffer_count = MAX_FRAMES_IN_FLIGHT,
    };
    engine.command_buffers = vk::allocateCommandBuffers(engine.device, &allocInfo)!;
}

fn void destroyCommandPool(Engine* engine) {
    vk::freeCommandBuffers(engine.device, engine.command_pool, engine.command_buffers.len, &engine.command_buffers);
    vk::destroyCommandPool(engine.device, engine.command_pool);
}

fn void! render(Engine* engine) {
    vk::waitForFences(engine.device, 1, &engine.in_flight_fences[engine.current_frame])!;
    uint! imageIndex = vk::acquireNextImageKHR(engine.device, engine.swap_chain, ulong.max, engine.image_available_semaphore[engine.current_frame], (vk::Fence)0);
    if (catch excuse = imageIndex) {
        if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
            recreateSwapchain()!;
            return;
        }
        return excuse?;
    }
    vk::resetFences(engine.device, 1, &engine.in_flight_fences[engine.current_frame])!;
    vk::resetCommandBuffer(engine.command_buffers[engine.current_frame])!;
    recordCommandBuffer(engine.command_buffers[engine.current_frame], imageIndex)!;

    vk::SubmitInfo submitInfo = {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &engine.image_available_semaphore[engine.current_frame],
        .p_wait_dst_stage_mask = &&vk::PipelineStageFlags { .color_attachment_output },
        .command_buffer_count = 1,
        .p_command_buffers = &engine.command_buffers[engine.current_frame],
        .signal_semaphore_count = 1,
        .p_signal_semaphores = &engine.render_finished_semaphore[engine.current_frame],
    };
    vk::queueSubmit(engine.graphics_queue, 1, &submitInfo, engine.in_flight_fences[engine.current_frame])!;
    vk::PresentInfoKHR presentInfo = {
        .s_type = vk::STRUCTURE_TYPE_PRESENT_INFO_KHR,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &engine.render_finished_semaphore[engine.current_frame],
        .swapchain_count = 1,
        .p_swapchains = &engine.swap_chain,
        .p_image_indices = &imageIndex,
    };
    anyfault excuse = @catch(vk::queuePresentKHR(engine.present_queue, &presentInfo));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    engine.current_frame = (engine.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! recordCommandBuffer(Engine* engine, vk::CommandBuffer commandBuffer, uint imageIndex) {
    vk::beginCommandBuffer(commandBuffer, &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    })!;
    vk::ImageMemoryBarrier barrier_before = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .new_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = engine.swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = vk::ImageAspectFlags {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = vk::AccessFlags{},
        .dst_access_mask = vk::AccessFlags{.color_attachment_write},
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        vk::PipelineStageFlags{.top_of_pipe},
        vk::PipelineStageFlags{.color_attachment_output},
        vk::DependencyFlags{},
        0, null,
        0, null,
        1, &barrier_before
    );

    // Begin dynamic rendering
    vk::RenderingAttachmentInfoKHR color_attachment = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR,
        .image_view = engine.swap_chain_image_views[imageIndex],
        .image_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .load_op = vk::ATTACHMENT_LOAD_OP_CLEAR,
        .store_op = vk::ATTACHMENT_STORE_OP_STORE,
        .clear_value = { .color = { .float32 = {0.0117, 0.0117, 0.0179, 1.0} } }
    };

    vk::RenderingInfoKHR render_info = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_INFO_KHR,
        .render_area = {.extent = engine.swap_chain_extent},
        .layer_count = 1,
        .color_attachment_count = 1,
        .p_color_attachments = &color_attachment
    };
    vk::cmdBeginRenderingKHR(commandBuffer, &render_info);
    vk::cmdBindPipeline(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, engine.graphics_pipeline);
    vk::cmdSetViewport(commandBuffer, 0, 1, &&vk::Viewport {
        .width = engine.swap_chain_extent.width,
        .height = engine.swap_chain_extent.height,
        .max_depth = 1.0,
    });
    vk::cmdSetScissor(commandBuffer, 0, 1, &&vk::Rect2D {
        .extent = engine.swap_chain_extent,
    });
    draw(commandBuffer);
    vk::cmdEndRenderingKHR(commandBuffer);
    // Transition to PRESENT_SRC_KHR
    vk::ImageMemoryBarrier barrier_after = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .new_layout = vk::IMAGE_LAYOUT_PRESENT_SRC_KHR,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = engine.swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = vk::ImageAspectFlags{.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = vk::AccessFlags{.color_attachment_write},
        .dst_access_mask = vk::AccessFlags{}
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        vk::PipelineStageFlags{.color_attachment_output},
        vk::PipelineStageFlags{.bottom_of_pipe},
        vk::DependencyFlags{},
        0, null,
        0, null,
        1, &barrier_after
    );
    vk::endCommandBuffer(commandBuffer)!;
}

fn void draw(vk::CommandBuffer commandBuffer) {
    vk::cmdBindVertexBuffers(commandBuffer, 0, 1, &g_vertex_buffer, &&(vk::DeviceSize)0);
    vk::cmdBindIndexBuffer(commandBuffer, g_index_buffer, 0, vk::INDEX_TYPE_UINT16);
    vk::cmdBindDescriptorSets(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, g_pipeline_layout, 0, 1, &g_descriptor_sets[g_current_frame], 0, null);
    vk::cmdDrawIndexed(commandBuffer, INDICES.len, 1, 0, 0, 0);
}

fn vk::CommandBuffer! beginSingleTimeCommand(Engine* engine) {
    vk::CommandBuffer[] command_buffer = vk::allocateCommandBuffers(engine.device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = engine.command_pool,
        .command_buffer_count = 1,
    })!;
    vk::beginCommandBuffer(command_buffer[0], &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = { .one_time_submit },
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
