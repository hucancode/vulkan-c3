module mj;
// rewrite this to support scene rendering

const MAX_FRAMES_IN_FLIGHT = 2;
struct Renderer {
    uint current_frame;
    vk::Semaphore[MAX_FRAMES_IN_FLIGHT] image_available_semaphore;
    vk::Semaphore[MAX_FRAMES_IN_FLIGHT] render_finished_semaphore;
    vk::Fence[MAX_FRAMES_IN_FLIGHT] in_flight_fences;
    vk::CommandBuffer[MAX_FRAMES_IN_FLIGHT] command_buffers;
}

fn void! Renderer.init(Renderer* this, Engine* engine) {
    vk::CommandBufferAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .command_pool = engine.command_pool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_buffer_count = this.command_buffers.len,
    };
    vk::allocateCommandBuffers(engine.device, &allocInfo, &this.command_buffers)!;
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .s_type = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .s_type = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = { .signaled },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        this.image_available_semaphore[i] = vk::createSemaphore(engine.device, &semaphoreInfo)!;
        this.render_finished_semaphore[i] = vk::createSemaphore(engine.device, &semaphoreInfo)!;
        this.in_flight_fences[i] = vk::createFence(engine.device, &fenceInfo)!;
    }
}

fn void Renderer.destroy(Renderer* this, Engine* engine) {
    vk::freeCommandBuffers(engine.device, engine.command_pool, this.command_buffers.len, &this.command_buffers);
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(engine.device, this.image_available_semaphore[i]);
        vk::destroySemaphore(engine.device, this.render_finished_semaphore[i]);
        vk::destroyFence(engine.device, this.in_flight_fences[i]);
    }
}

fn uint! Renderer.frameBegin(Renderer* renderer, Engine* engine) {
    vk::waitForFences(engine.device, 1, &renderer.in_flight_fences[renderer.current_frame])!;
    uint! imageIndex = vk::acquireNextImageKHR(engine.device, engine.swap_chain, ulong.max, renderer.image_available_semaphore[renderer.current_frame], (vk::Fence)0);
    if (catch excuse = imageIndex) {
        if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
            recreateSwapchain()!;
            return;
        }
        return excuse?;
    }
    vk::resetFences(engine.device, 1, &renderer.in_flight_fences[renderer.current_frame])!;
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
        .image = engine.swap_chain_images[imageIndex],
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
    vk::cmdSetViewport(commandBuffer, 0, 1, &&vk::Viewport {
        .width = engine.swap_chain_extent.width,
        .height = engine.swap_chain_extent.height,
        .max_depth = 1.0,
    });
    vk::cmdSetScissor(commandBuffer, 0, 1, &&vk::Rect2D {
        .extent = engine.swap_chain_extent,
    });
    return imageIndex;
}

fn void! Renderer.frameEnd(Renderer* this, Engine* engine, uint imageIndex) {
    vk::CommandBuffer commandBuffer = this.command_buffers[this.current_frame];
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
        .p_swapchains = &engine.swap_chain,
        .p_image_indices = &imageIndex,
    };
    anyfault excuse = @catch(vk::queuePresentKHR(engine.present_queue, &presentInfo));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    this.current_frame = (this.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! Renderer.frameRender(Renderer* this, Engine* engine, Scene* scene, ResourceManager* resource_manager) {
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

fn void! Renderer.render(Renderer* renderer, Engine* engine, Scene* scene) {
    uint imageIdx = renderer.frameBegin(engine);
    renderer.frameRender(engine, scene);
    renderer.frameEnd(engine, imageIdx);
}
