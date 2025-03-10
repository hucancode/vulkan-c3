module mj;
import std::math::matrix;
import std::math::quaternion;
import std::collections::list;

enum NodeType {
    ROOT,
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

fn Matrix4f Transform.calculate(Transform* this) {
    return this.rotation.to_matrix()
        .mul(Matrix4f.translate(this.position))
        .mul(Matrix4f.scale(this.scale));
}

fn Transform Transform.new() {
    return Transform {
        .scale= {1.0, 1.0, 1.0, 1.0},
    };
}

fn Node Node.new() {
    return Node {
        .transform = Transform.new(),
    };
}
