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
