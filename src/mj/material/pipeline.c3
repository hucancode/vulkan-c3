module mj;
import vk;

fn void destroyGraphicsPipeline() {
    vk::destroyPipeline(g_device, g_graphics_pipeline);
    vk::destroyPipelineLayout(g_device, g_pipeline_layout);
}

fn vk::ShaderModule! createShaderModule(vk::Device device, char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .code_size = code.len,
        .p_code = (uint*)code.ptr,
    };
    return vk::createShaderModule(device, &createInfo)!;
}

fn void destroyDescriptorSetLayout() {
    vk::destroyDescriptorSetLayout(g_device, g_descriptor_set_layout);
}
