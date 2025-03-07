module mj;
import std::collections::list;

struct Scene {
    Node root;
    Camera camera;
}

fn Scene make_scene() {
    Node root;
    Camera camera = {
        .projection = CameraProjection.PERSPECTIVE,
        .fov = 45.0,
        .aspect_ratio = 16.0 / 9.0,
        .near = 0.1,
        .far = 10000.0,
        .up = VEC_UP,
    };
    return Scene {
        .root = root,
        .camera = camera,
    };
}
