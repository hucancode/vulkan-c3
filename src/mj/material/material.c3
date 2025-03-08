module mj;
import vk;

def MaterialHandle = uint;

struct Material {
    float[<4>] color;
    TextureHandle albedo;
    TextureHandle metallic;
    TextureHandle roughness;
}

struct MaterialGPU {
    vk::DescriptorSet descriptor_set;
    vk::PipelineLayout pipeline_layout;
    vk::Pipeline pipeline;
    vk::DescriptorSetLayout descriptor_set_layout;
    vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
    vk::Buffer color_buffer;
}

const char[*] VERTEX_CODE = $embed("shaders/vert.spv");
const char[*] FRAGMENT_CODE = $embed("shaders/frag.spv");

fn void! createGraphicsPipeline(Engine* engine, MaterialGPU* gpu) {
    vk::ShaderModule v = createShaderModule(engine.device, &VERTEX_CODE)!;
    defer vk::destroyShaderModule(engine.device, v, null);
    vk::ShaderModule f = createShaderModule(engine.device, &FRAGMENT_CODE)!;
    defer vk::destroyShaderModule(engine.device, f, null);
    vk::PipelineShaderStageCreateInfo[*] shader_stages = {{
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .vertex },
        .module_ = v,
        .p_name = "main",
    }, {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .fragment },
        .module_ = f,
        .p_name = "main",
    }};
    vk::DynamicState[*] dynamicStates = {
        vk::DYNAMIC_STATE_VIEWPORT,
        vk::DYNAMIC_STATE_SCISSOR
    };
    vk::PipelineDynamicStateCreateInfo dynamicState = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
        .dynamic_state_count = dynamicStates.len,
        .p_dynamic_states = &dynamicStates,
    };
    vk::PipelineVertexInputStateCreateInfo vertexInputInfo = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
        .vertex_binding_description_count   = VERTEX_DESCRIPTION.len,
    	.p_vertex_binding_descriptions      = &VERTEX_DESCRIPTION,
    	.vertex_attribute_description_count = VERTEX_ATTR_DESCRIPTION.len,
    	.p_vertex_attribute_descriptions    = &VERTEX_ATTR_DESCRIPTION,
    };
    vk::PipelineInputAssemblyStateCreateInfo inputAssembly = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        .topology = vk::PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
    };
    vk::PipelineViewportStateCreateInfo viewportState = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        .viewport_count = 1,
        .scissor_count = 1,
    };
    vk::PipelineRasterizationStateCreateInfo rasterizer = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        .polygon_mode = vk::POLYGON_MODE_FILL,
        .cull_mode = vk::CullModeFlags { .back },
        .front_face = vk::FRONT_FACE_CLOCKWISE,
        .line_width = 1.0,
    };
    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .rasterization_samples = vk::SampleCountFlags { .n_1 },
        .min_sample_shading = 1.0,
    };
    vk::PipelineColorBlendAttachmentState colorBlendAttachment = {
        .color_write_mask = vk::ColorComponentFlags { .r, .g, .b, .a },
    };
    vk::PipelineColorBlendStateCreateInfo colorBlending = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .attachment_count = 1,
        .p_attachments = &colorBlendAttachment,
    };
    vk::DescriptorSetLayout[*] set_layouts = {
        createSceneDescriptorSetLayout(engine),
        createNodeDescriptorSetLayout(engine),
        createMaterialDescriptorSetLayout(engine),
    };
    gpu.pipeline_layout = vk::createPipelineLayout(
        engine.device,
        &&vk::PipelineLayoutCreateInfo {
            .s_type = vk::STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .set_layout_count = set_layouts.len,
            .p_set_layouts = &set_layout,
        })!;
    vk::PipelineRenderingCreateInfoKHR dynamic_rendering_info = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_RENDERING_CREATE_INFO_KHR,
        .color_attachment_count = 1,
        .p_color_attachment_formats = &g_swap_chain_format.format,
    };
    vk::GraphicsPipelineCreateInfo pipelineInfo = {
        .s_type = vk::STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
        .stage_count = shader_stages.len,
        .p_stages = &shader_stages,
        .p_vertex_input_state = &vertexInputInfo,
        .p_input_assembly_state = &inputAssembly,
        .p_viewport_state = &viewportState,
        .p_rasterization_state = &rasterizer,
        .p_multisample_state = &multisampling,
        .p_color_blend_state = &colorBlending,
        .p_dynamic_state = &dynamicState,
        .layout = gpu.pipeline_layout,
        .base_pipeline_index = -1,
        .p_next = &dynamic_rendering_info,
    };
    gpu.pipeline = vk::createGraphicsPipelines(engine.device, (vk::PipelineCache)0, 1, &pipelineInfo)!;
}

fn vk::DescriptorSetLayout! createMaterialDescriptorSetLayout(Engine* engine) {
    vk::DescriptorSetLayoutBinding color = {
        .binding = 0,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.fragment},
    };
    vk::DescriptorSetLayoutBinding albedo = {
            .binding = 1,
            .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .stage_flags = vk::ShaderStageFlags{.fragment},
        };
    vk::DescriptorSetLayoutBinding metalic = {
            .binding = 2,
            .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .stage_flags = vk::ShaderStageFlags{.fragment},
        };
    vk::DescriptorSetLayoutBinding roughness = {
        .binding = 3,
        .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.fragment},
    };
    vk::DescriptorSetLayoutBinding[*] bindings = { color, albedo, metalic, roughness };
    vk::DescriptorSetLayoutCreateInfo info = {
        .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		.binding_count = bindings.len,
		.p_bindings    = &bindings,
	};
	return vk::createDescriptorSetLayout(engine.device, &info)!;
}

fn void createUBO() {
    int width, height;
    glfw::getFramebufferSize(g_window, &width, &height);
    if(height <= 0) {
        return;
    }
    g_ubo.model = matrix::IDENTITY4(<float>);
    g_ubo.view = matrix::look_at(<float>)({0.0, 5.0, 5.0}, {}, {0.0, 1.0, 0.0}).transpose();
    g_ubo.projection = matrix::perspective(<float>)((float)math::deg_to_rad(45), (float)width/(float)height, 0.1, 10000.0).transpose();
    g_ubo.time = 0.0;
    updateUniforms();
}

fn void! createMaterialDescriptorSets(Engine* engine, MaterialGPU* gpu) {
    vk::DescriptorPoolSize color = {
        .type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize albedo_sampler = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize[*] pool_sizes = {
        color,
        albedo_sampler,
    };
    vk::DescriptorPoolCreateInfo create_info = {
        .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .pool_size_count = pool_sizes.len,
        .p_pool_sizes    = &pool_sizes,
        .max_sets       = MAX_FRAMES_IN_FLIGHT,
    };
    gpu.descriptor_pool = vk::createDescriptorPool(engine.device, &create_info)!;
	vk::DescriptorSetLayout[] set_layouts = @duplicate(vk::DescriptorSetLayout, &gpu.set_layout, MAX_FRAMES_IN_FLIGHT);
	defer free(set_layouts);
	vk::DescriptorSetAllocateInfo alloc_info = {
		.s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
		.descriptor_pool     = engine.descriptor_pool,
		.descriptor_set_count = set_layouts.len,
		.p_set_layouts        = &set_layouts,
	};
	gpu.descriptor_sets = vk::allocateDescriptorSets(engine.device, &alloc_info)!;
}

fn void updateDescriptorSets(Engine* engine, MaterialGPU* gpu, TextureGPU* albedo, TextureGPU* metalic, TextureGPU* roughness) {
    for (uint i =0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::WriteDescriptorSet color = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = gpu.descriptor_sets[i],
            .dst_binding      = 0,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
            .descriptor_count = 1,
            .p_buffer_info     = &&vk::DescriptorBufferInfo {
                .buffer = gpu.color_buffer,
                .offset = 0,
                .range = float[<4>].sizeof,
            },
		};
		vk::WriteDescriptorSet albedo = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = gpu.descriptor_sets[i],
            .dst_binding      = 1,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = albedo.sampler,
                .image_view = albedo.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet metallic = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = gpu.descriptor_sets[i],
            .dst_binding      = 2,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = metalic.sampler,
                .image_view = metalic.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet roughness = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = gpu.descriptor_sets[i],
            .dst_binding      = 3,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = roughness.sampler,
                .image_view = roughness.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet[*] writes = {
			color,
			albedo,
			metalic,
			roughness,
		};
		vk::updateDescriptorSets(engine.device, descriptors.len, &descriptors, 0, null);
	}
}

fn void updateUniforms() {
    mem::copy(g_uniform_buffer_mapped[g_current_frame], &g_ubo, UniformBuffer.sizeof);
}
