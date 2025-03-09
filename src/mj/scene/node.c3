module mj;
import std::math::matrix;
import std::math::quaternion;
import std::collections::list;

def NodeHandle = uint;

enum NodeType {
    GROUP,
    LIGHT,
    SKELETAL_MESH,
    STATIC_MESH,
}
struct Transform {
    float[<3>] position;
    Quaternion rotation;
    float[<3>] scale;
    bool is_dirty;
    Matrix4f local_matrix;
    Matrix4f world_matrix;
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

fn Matrix4f calculateTransform(Transform transform) {
    return transform.rotation.to_matrix()
        .mul(Matrix4f.translate(transform.position))
        .mul(Matrix4f.scale(transform.scale));
}

fn Transform new_transform() {
    return Transform {
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
