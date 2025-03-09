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

// fn Transform new_transform() {
//     return Transform {
//         .position= {0.0, 0.0, 0.0, 1.0},
//         .rotation= {0.0, 0.0, 0.0, 1.0},
//         .scale= {1.0, 1.0, 1.0, 1.0},
//     };
// }

// fn Node new_node() {
//     return Node {
//         .transform = new_transform(),
//     };
// }

// fn Node new_static_mesh_node(uint mesh_handle = 0) {
//     return Node {
//         .type = NodeType.STATIC_MESH,
//         .static_mesh = mesh_handle,
//         .transform = new_transform(),
//     };
// }


// fn Node new_light_node(uint light_handle = 0) {
//     return Node {
//         .type = NodeType.LIGHT,
//         .light = light_handle,
//         .transform = new_transform(),
//     };
// }

// fn Node new_skeletal_mesh_node(uint mesh_handle = 0) {
//     return Node {
//         .type = NodeType.SKELETAL_MESH,
//         .skeletal_mesh = mesh_handle,
//         .transform = new_transform(),
//     };
// }

struct NodeGPU {
    MappedBuffer[MAX_FRAMES_IN_FLIGHT] model_buffer;
    vk::DescriptorPool descriptor_pool;
    vk::DescriptorSetLayout descriptor_set_layout;
    vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
}

fn NodeGPU! createNode(Engine* engine, Node* data) {
    NodeGPU node;
    {
            // node-level descriptor set layout
            vk::DescriptorSetLayoutBinding model = {
                .binding = 0,
                .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .descriptor_count = 1,
                .stage_flags = { .vertex },
            };
            vk::DescriptorSetLayoutBinding[*] bindings = { model };
            vk::DescriptorSetLayoutCreateInfo info = {
                .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
          		.binding_count = bindings.len,
          		.p_bindings    = &bindings,
           	};
           	node.descriptor_set_layout = vk::createDescriptorSetLayout(engine.device, &info)!;
	}
	{
        	vk::DescriptorPoolSize model = {
                .type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .descriptor_count = MAX_FRAMES_IN_FLIGHT,
            };
            vk::DescriptorPoolSize[*] pool_sizes = {
                model,
            };
            vk::DescriptorPoolCreateInfo create_info = {
                .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
                .pool_size_count = pool_sizes.len,
                .p_pool_sizes    = &pool_sizes,
                .max_sets       = MAX_FRAMES_IN_FLIGHT,
            };
            node.descriptor_pool = vk::createDescriptorPool(engine.device, &create_info)!;
            vk::DescriptorSetLayout[] set_layouts = @repeat(&node.descriptor_set_layout, MAX_FRAMES_IN_FLIGHT);
            defer free(set_layouts);
            vk::DescriptorSetAllocateInfo alloc_info = {
                .s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
                .descriptor_pool     = gpu.descriptor_pool,
                .descriptor_set_count = set_layouts.len,
                .p_set_layouts        = &set_layouts,
            };
            node.descriptor_sets = vk::allocateDescriptorSets(engine.device, &alloc_info)!;
	}
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        node.model_buffer[i] = createMappedBuffer(engine, &Matrix4x4(<float>).IDENTITY, Matrix4x4(<float>).sizeof, { .uniform_buffer })!;
    }
    return node;
}

fn void destroyNode(Engine* engine, NodeGPU* node) {
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        destroyBuffer(engine, node.model_buffer.buffer, node.model_buffer.memory);
    }
}
