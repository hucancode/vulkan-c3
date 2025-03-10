module mj;
import std::math::matrix;
import std::math::quaternion;
enum CameraProjection {
    PERSPECTIVE,
    ORTHOGRAPHIC
}

struct Camera {
    union {
        struct {
            float fov;
            float aspect_ratio;
            float near;
            float far;
        }
        struct {
            float right;
            float bottom;
            float near;
            float far;
        }
    }
    Vec3f up;
    Position position;
    CameraProjection projection;
    Quaternion rotation;
}

fn Matrix4f calculate_camera_projection_matrix(Camera camera) {
    switch (camera.projection) {
        case CameraProjection.PERSPECTIVE:
            return matrix::perspective(<float>)(camera.fov, camera.aspect_ratio, camera.near, camera.far)
                .transpose();
        case CameraProjection.ORTHOGRAPHIC:
            return matrix::ortho(<float>)(0.0, camera.right, 0.0, camera.bottom, camera.near, camera.far)
                .transpose();
    }
    return matrix::perspective(<float>)(camera.fov, camera.aspect_ratio, camera.near, camera.far)
        .transpose();
}

fn Matrix4f calculate_camera_lookat_matrix(Camera camera, Position target = {}) {
    return matrix::look_at(<float>)(camera.position, target, camera.up)
        .transpose();
}

fn Matrix4f calculate_camera_view_matrix(Camera camera) {
    return camera.rotation.to_matrix()
        .translate(camera.position)
        .transpose();
}
