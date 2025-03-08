module mj;
import std::math::matrix;
import std::collections::list;
def NodeHandle = usz;

enum NodeType {
    GROUP,
    LIGHT,
    SKELETAL_MESH,
    STATIC_MESH,
}
struct Transform {
    float[<4>] position;
    float[<4>] rotation;
    float[<4>] scale;
}

struct Node {
    NodeHandle parent;
    List(<NodeHandle>) children;
    NodeType type;
    union {
        StaticMeshHandle static_mesh;
        SkeletalMeshHandle skeletal_mesh;
        LightHandle light;
    }
    Transform transform;
}

struct NodeGPU {
    vk::DescriptorSetLayout descriptor_set_layout;
    vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
}

fn Transform new_transform() {
    return Transform {
        .position= {0.0, 0.0, 0.0, 1.0},
        .rotation= {0.0, 0.0, 0.0, 1.0},
        .scale= {1.0, 1.0, 1.0, 1.0},
    };
}

fn Node new_node() {
    return Node {
        .transform = new_transform(),
    };
}

fn Node new_static_mesh_node(uint mesh_handle = 0) {
    return Node {
        .type = NodeType.STATIC_MESH,
        .static_mesh = mesh_handle,
        .transform = new_transform(),
    };
}


fn Node new_light_node(uint light_handle = 0) {
    return Node {
        .type = NodeType.LIGHT,
        .light = light_handle,
        .transform = new_transform(),
    };
}

fn Node new_skeletal_mesh_node(uint mesh_handle = 0) {
    return Node {
        .type = NodeType.SKELETAL_MESH,
        .skeletal_mesh = mesh_handle,
        .transform = new_transform(),
    };
}

fn vk::DescriptorSetLayout! createNodeDescriptorSetLayout(Engine* engine) {
    vk::DescriptorSetLayoutBinding world = {
        .binding = 0,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.vertex},
    };
    vk::DescriptorSetLayoutBinding[*] bindings = { world };
    vk::DescriptorSetLayoutCreateInfo info = {
        .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		.binding_count = bindings.len,
		.p_bindings    = &bindings,
	};
	return vk::createDescriptorSetLayout(engine.device, &info)!;
}

fn void! createNodeDescriptorSets(Engine* engine, NodeGPU* gpu) {
    vk::DescriptorPoolSize world = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize[*] pool_sizes = {
        world,
    };
    vk::DescriptorPoolCreateInfo create_info = {
        .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .pool_size_count = pool_sizes.len,
        .p_pool_sizes    = &pool_sizes,
        .max_sets       = MAX_FRAMES_IN_FLIGHT,
    };
    gpu.descriptor_pool = vk::createDescriptorPool(engine.device, &create_info)!;
	vk::DescriptorSetLayout* set_layouts = (vk::DescriptorSetLayout*) malloc(vk::DescriptorSetLayout.sizeof* MAX_FRAMES_IN_FLIGHT);
	for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        set_layouts[i] = gpu.descriptor_set_layout;
    }
	vk::DescriptorSetAllocateInfo alloc_info = {
		.s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
		.descriptor_pool     = gpu.descriptor_pool,
		.descriptor_set_count = MAX_FRAMES_IN_FLIGHT,
		.p_set_layouts        = set_layouts,
	};
	gpu.descriptor_sets = vk::allocateDescriptorSets(engine.device, &alloc_info)!;
}
