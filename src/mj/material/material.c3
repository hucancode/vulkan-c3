module mj;
import vk;

struct Material {
    TextureHandle albedo;
    TextureHandle metallic;
    TextureHandle roughness;
    struct gpu {
        vk::PipelineLayout pipeline_layout;
        vk::Pipeline pipeline;
        vk::DescriptorPool descriptor_pool;
        vk::DescriptorSetLayout descriptor_set_layout;
        vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
    }
}

const char[*] VERTEX_CODE = $embed("shaders/vert.spv");
const char[*] FRAGMENT_CODE = $embed("shaders/frag.spv");

fn void! Renderer.initMaterial(this, Material* mat, vk::DescriptorSetLayout shared_descriptor_set_layout) {
    vk::ShaderModule v = createShaderModule(this.device, &VERTEX_CODE)!;
    defer vk::destroyShaderModule(this.device, v);
    vk::ShaderModule f = createShaderModule(this.device, &FRAGMENT_CODE)!;
    defer vk::destroyShaderModule(this.device, f);
    vk::PipelineShaderStageCreateInfo[*] shader_stages = {{
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = { .vertex },
        .module_ = v,
        .p_name = "main",
    }, {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = { .fragment },
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
        .cull_mode = { .back },
        .front_face = vk::FRONT_FACE_CLOCKWISE,
        .line_width = 1.0,
    };
    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .rasterization_samples = { .n_1 },
        .min_sample_shading = 1.0,
    };
    vk::PipelineColorBlendStateCreateInfo colorBlending = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .attachment_count = 1,
        .p_attachments = &&vk::PipelineColorBlendAttachmentState { .color_write_mask = { .r, .g, .b, .a } },
    };
    {
        // material-level descriptor set layout
        vk::DescriptorSetLayoutBinding albedo = {
            .binding = 0,
            .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .stage_flags = { .fragment },
        };
        vk::DescriptorSetLayoutBinding metalic = {
            .binding = 1,
            .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .stage_flags = { .fragment },
        };
        vk::DescriptorSetLayoutBinding roughness = {
            .binding = 2,
            .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .stage_flags = { .fragment },
        };
        vk::DescriptorSetLayoutBinding[*] bindings = { albedo, metalic, roughness };
        vk::DescriptorSetLayoutCreateInfo info = {
            .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
    		.binding_count = bindings.len,
    		.p_bindings    = &bindings,
    	};
    	mat.gpu.descriptor_set_layout = vk::createDescriptorSetLayout(renderer.device, &info)!;
	}
	{
        vk::DescriptorSetLayout[*] set_layouts = {
            shared_descriptor_set_layout,
            mat.gpu.descriptor_set_layout,
        };
        mat.gpu.pipeline_layout = vk::createPipelineLayout(
            renderer.device,
            &&vk::PipelineLayoutCreateInfo {
                .s_type = vk::STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
                .set_layout_count = set_layouts.len,
                .p_set_layouts = &set_layout,
            })!;
    }
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
        .layout = mat.gpu.pipeline_layout,
        .base_pipeline_index = -1,
        .p_next = &dynamic_rendering_info,
    };
    mat.gpu.pipeline = vk::createGraphicsPipelines(this.device, (vk::PipelineCache)0, 1, &pipelineInfo)!;
    vk::DescriptorPoolSize albedo_sampler = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize metalic_sampler = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize roughness_sampler = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize[*] pool_sizes = {
        albedo_sampler,
        metalic_sampler,
        roughness_sampler,
    };
    vk::DescriptorPoolCreateInfo create_info = {
        .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .pool_size_count = pool_sizes.len,
        .p_pool_sizes    = &pool_sizes,
        .max_sets       = MAX_FRAMES_IN_FLIGHT,
    };
    mat.descriptor_pool = vk::createDescriptorPool(this.device, &create_info)!;
	vk::DescriptorSetLayout[] set_layouts = @repeat(&mat.gpu.descriptor_set_layout, MAX_FRAMES_IN_FLIGHT);
	defer free(set_layouts);
	vk::DescriptorSetAllocateInfo alloc_info = {
		.s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
		.descriptor_pool     = mat.descriptor_pool,
		.descriptor_set_count = set_layouts.len,
		.p_set_layouts        = &set_layouts,
	};
	mat.gpu.descriptor_sets = vk::allocateDescriptorSets(this.device, &alloc_info)!;
}

fn void Renderer.updateMaterialTextures(this, Material* mat, Texture* albedo, Texture* metalic, Texture* roughness) {
    for (uint i =0; i < MAX_FRAMES_IN_FLIGHT; i++) {
		vk::WriteDescriptorSet albedo = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = mat.gpu.descriptor_sets[i],
            .dst_binding      = 0,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = albedo.gpu.sampler,
                .image_view = albedo.gpu.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet metalic = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = mat.gpu.descriptor_sets[i],
            .dst_binding      = 1,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = metalic.gpu.sampler,
                .image_view = metalic.gpu.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet roughness = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = mat.gpu.descriptor_sets[i],
            .dst_binding      = 2,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &&vk::DescriptorImageInfo {
                .sampler = roughness.gpu.sampler,
                .image_view = roughness.gpu.view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            },
		};
		vk::WriteDescriptorSet[*] writes = {
			albedo,
			metalic,
			roughness,
		};
		vk::updateDescriptorSets(this.device, writes.len, &writes, 0, null);
	}
}

fn vk::ShaderModule! createShaderModule(vk::Device device, char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .code_size = code.len,
        .p_code = (uint*)code.ptr,
    };
    return vk::createShaderModule(device, &createInfo)!;
}

fn void Renderer.destroyMaterial(this, Material* mat) {
    vk::destroyPipeline(this.device, mat.gpu.pipeline);
    vk::destroyPipelineLayout(this.device, mat.gpu.pipeline_layout);
    vk::destroyDescriptorSetLayout(this.device, mat.gpu.descriptor_set_layout);
    foreach (set: mat.gpu.descriptor_sets) {
        vk::destroyDescriptorSet(this.device, set);
    }
    vk::destroyBuffer(this.device, mat.gpu.color_buffer);
}
